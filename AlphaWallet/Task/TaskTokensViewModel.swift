//
//  TaskTokensViewModel.swift
//  AlphaWallet
//
//  Created by Sudan Tuladhar on 17/06/2023.
//

import Foundation
import AlphaWalletCore
import Combine
import AlphaWalletFoundation

struct TaskTokensConnection: Decodable {
    let connections: [TaskTokensFromToken]
}

//extension TaskTokensConnection {
//    var firstConnection: TaskTokensFromToken? {
//        connections.first
//    }
//}

struct TaskTokensFromToken: Decodable {
    let fromTokens: [TaskTokens]
}

struct TaskTokens: Decodable {
    let name: String
    let address: String
    let chainId: Int
    let symbol: String
}

protocol TaskTokensNetworking {
    func fetchTaskTokens() -> AnyPublisher<TaskTokensConnection, PromiseError>
}

extension Constants {
    enum TaskTokens {
        static let requestUrl = URL(string: "https://li.quest/v1/connections")!
    }
}

final class BasicTaskTokensNetworking: TaskTokensNetworking {
    private let decoder = JSONDecoder()
    private let networkService: NetworkService

    public init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchTaskTokens() -> AnyPublisher<TaskTokensConnection, PromiseError> {
        return networkService
            .dataTaskPublisher(TaskTokenAssetRequest(), callbackQueue: .main)
            .receive(on: DispatchQueue.global())
            .tryMap { [decoder] in try decoder.decode(TaskTokensConnection.self, from: $0.data) }
            .mapError { PromiseError.some(error: $0) }
            .eraseToAnyPublisher()
    }
}

extension BasicTaskTokensNetworking {
    struct TaskTokenAssetRequest: URLRequestConvertible {
        func asURLRequest() throws -> URLRequest {
            guard var components = URLComponents(url: Constants.TaskTokens.requestUrl, resolvingAgainstBaseURL: false) else { throw URLError(.badURL) }
            
            components.queryItems = [ "fromChain": 1, "toChain": 1 ]
                .map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
            
            print(components.url, components.queryItems)
            
            let urlRequest = try URLRequest(url: try components.url ?? components.asURL(), method: .get)
            
            print(urlRequest.url)
            
            return urlRequest
        }
    }
}

final class TaskTokensViewModel {
    
    let service = BasicTaskTokensNetworking(networkService: BaseNetworkService(analytics: AnalyticsService()))
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetch() {
        service.fetchTaskTokens()
            .sink(receiveCompletion: { completion in
                
                guard case .failure(let error) = completion else { return }
                print(error)
                
            }, receiveValue: { result in
                print("Total Results: ", result.connections.first?.fromTokens.count)
            })
            .store(in: &cancellables)
    }
}

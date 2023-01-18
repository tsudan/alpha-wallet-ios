//
//  BlockNumberSchedulerProvider.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 20.08.2022.
//

import Foundation
import Combine
import AlphaWalletCore
import CombineExt

public typealias BlockNumber = Int

public protocol ChainStateSchedulerProviderDelegate: AnyObject {
    func didReceive(result: Result<BlockNumber, PromiseError>)
}

public final class BlockNumberSchedulerProvider: SchedulerProvider {
    private let server: RPCServer
    private let analytics: AnalyticsLogger
    private lazy var blockNumberProvider = GetBlockNumber(server: server, analytics: analytics)

    var interval: TimeInterval { return Constants.BlockNumberProvider.getChainStateInterval }
    var name: String { "BlockNumberSchedulerProvider" }
    var operation: AnyPublisher<Void, SchedulerError> {
        blockNumberProvider.getBlockNumber().publisher(queue: .global())
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.didReceiveValue(response: response)
            }, receiveCompletion: { [weak self] result in
                guard case .failure(let e) = result else { return }
                self?.didReceiveError(error: e)
            }).mapToVoid()
            .mapError { SchedulerError.promiseError($0) }
            .eraseToAnyPublisher()
    }
    public weak var delegate: ChainStateSchedulerProviderDelegate?

    public init(server: RPCServer, analytics: AnalyticsLogger) {
        self.server = server
        self.analytics = analytics
    }

    private func didReceiveValue(response block: BlockNumber) {
        delegate?.didReceive(result: .success(block))
    }

    private func didReceiveError(error: PromiseError) {
        delegate?.didReceive(result: .failure(error))
    }
}

//
//  TaskTokenCoordinator.swift
//  AlphaWallet
//
//  Created by Sudan Tuladhar on 17/06/2023.
//

import UIKit
import FloatingPanel
import Combine
import AlphaWalletFoundation

protocol TaskTokensCoordinatorDelegate: AnyObject {
    func didClose(in coordinator: TaskTokensCoordinator)
}

final class TaskTokensCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let service: TaskTokensNetworking
    private let title: String
    
    private lazy var rootViewController: TaskTokensController = {
        let viewModel = TaskTokensViewModel(title: title, service: service)
        let viewController = TaskTokensController(viewModel: viewModel)
        viewController.delegate = self
        return viewController
    }()
    
    private lazy var hostingViewController: FloatingPanelController = {
        let panel = FloatingPanelController(isPanEnabled: false)
        panel.layout = FullScreenScrollableFloatingPanelLayout()
        
        panel.surfaceView.contentPadding = .init(top: 20, left: 0, bottom: 0, right: 0)
        panel.shouldDismissOnBackdrop = true
        panel.delegate = self
        
        return panel
    }()
    
    var coordinators: [Coordinator] = []
    weak var delegate: TaskTokensCoordinatorDelegate?

    init(navigationController: UINavigationController, service: TaskTokensNetworking, title: String) {
        self.navigationController = navigationController
        self.service = service
        self.title = title
    }

    func start() {
        let navigationController = NavigationController(rootViewController: rootViewController)
        hostingViewController.set(contentViewController: navigationController)
        
        self.navigationController.present(hostingViewController, animated: true)
    }
}

extension TaskTokensCoordinator: FloatingPanelControllerDelegate {
    func floatingPanelDidRemove(_ fpc: FloatingPanelController) {
        delegate?.didClose(in: self)
    }
}

extension TaskTokensCoordinator: TaskTokensControllerDelegate {
    func didTapClose(on: TaskTokensController) {
        hostingViewController.dismiss(animated: true) { [weak self] in
            
            if let strongSelf = self {
                strongSelf.delegate?.didClose(in: strongSelf)
            }
        }
    }
}

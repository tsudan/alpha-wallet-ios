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
    private lazy var rootViewController: TaskTokensController = {
        let viewModel = TaskTokensViewModel()
        let viewController = TaskTokensController(viewModel: viewModel)
        return viewController
    }()
    
    var coordinators: [Coordinator] = []
    weak var delegate: TaskTokensCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let navigationController = NavigationController(rootViewController: rootViewController)
        let panel = FloatingPanelController(isPanEnabled: false)
        panel.layout = FullScreenScrollableFloatingPanelLayout()
        panel.set(contentViewController: navigationController)
        panel.surfaceView.contentPadding = .init(top: 20, left: 0, bottom: 0, right: 0)
        panel.shouldDismissOnBackdrop = true
        panel.delegate = self

        self.navigationController.present(panel, animated: true)
    }
}

extension TaskTokensCoordinator: FloatingPanelControllerDelegate {
    func floatingPanelDidRemove(_ fpc: FloatingPanelController) {
        delegate?.didClose(in: self)
    }
}

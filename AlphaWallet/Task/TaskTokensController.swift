//
//  TaskTokensController.swift
//  AlphaWallet
//
//  Created by Sudan Tuladhar on 17/06/2023.
//

import UIKit
import Combine

class TaskTokensController: UIViewController {

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.buildPlainTableView()
        tableView.register(SettingTableViewCell.self)
        tableView.register(SwitchTableViewCell.self)
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = DataEntry.Metric.anArbitraryRowHeightSoAutoSizingCellsWorkIniOS10
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let viewModel: TaskTokensViewModel
    
    private let input: PassthroughSubject<TaskTokensViewModel.Input, Never> = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var taskTokens: [TaskTokens] = []
    
    init(viewModel: TaskTokensViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.anchorsIgnoringBottomSafeArea(to: view)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Configuration.Color.Semantic.defaultViewBackground
        
        self.navigationItem.title = viewModel.title
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        input.send(.viewDidAppear)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchTaskTokens(let tokens):
                    self?.taskTokens = tokens
                    self?.tableView.reloadData()
                case .fetchTaskTokensError(let error):
                    print(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
}

extension TaskTokensController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskTokens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = taskTokens[indexPath.row].symbol
        return cell
    }
}

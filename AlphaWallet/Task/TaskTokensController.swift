//
//  TaskTokensController.swift
//  AlphaWallet
//
//  Created by Sudan Tuladhar on 17/06/2023.
//

import UIKit

class TaskTokensController: UIViewController {

    private let viewModel: TaskTokensViewModel
    
    init(viewModel: TaskTokensViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Configuration.Color.Semantic.defaultViewBackground
        
        viewModel.fetch()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

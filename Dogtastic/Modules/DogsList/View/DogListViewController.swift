//
//  DogListViewController.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import UIKit
import Combine

class DogListViewController: UIViewController {
    
    typealias Strings = DogListString
    
    private lazy var tableView: UITableView = {
        let tView = UITableView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.delegate = self
        tView.dataSource = self
        tView.register(DogListTableViewCell.self,
                       forCellReuseIdentifier: DogListTableViewCell.cellName)
        tView.backgroundColor = .dogWhite
        tView.separatorStyle = .none
        tView.refreshControl = refreshControl
        return tView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rControl = UIRefreshControl()
        rControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        return rControl
    }()
    
    let viewModel: DogListViewModelProtocol
    private var subscribers = Set<AnyCancellable>()
    private var inputViewModel = DogListViewModelInput()
    
    init(viewModel: DogListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        bind()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.refreshControl.beginRefreshing()
        })
        inputViewModel.viewDidLoadPublisher.send()
    }
    
    func bind() {
        let outputViewModel = viewModel.bind(input: inputViewModel)
         
        outputViewModel.fillWithDataPublisher.sink { [weak self] error in
            switch error {
            case .finished:
                break
            case .failure(_):
                self?.showErrorAlert()
            }
        } receiveValue: { [weak self] in
            self?.fillWithData()
        }.store(in: &subscribers)
        
        outputViewModel.showErrorAlertPublisher.sink { [weak self] in
            self?.showErrorAlert()
        }.store(in: &subscribers)
    }
    
    func setupController() {
        view.addSubview(tableView)
        title = "Dogs We Love"
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func refreshContent() {
        inputViewModel.loadDataPublisher.send()
    }
    
    func fillWithData() {
        UIView.transition(with: tableView, duration: 0.3,
                       options: .transitionCrossDissolve,
                       animations: {
            self.tableView.reloadData()
        }, completion: { _ in
            self.refreshControl.endRefreshing()
        })
    }
    
    func showErrorAlert() {
        refreshControl.endRefreshing()
        let retryAction = UIAlertAction(title: Strings.errorRetry, style: .default) { _ in
            self.refreshControl.beginRefreshing()
            self.refreshContent()
        }
        let cancel = UIAlertAction(title: Strings.errorCancel, style: .cancel)
        let action = UIAlertController(title: Strings.errorTitle,
                                       message: Strings.errorMessage,
                                       preferredStyle: .alert)
        action.addAction(retryAction)
        action.addAction(cancel)
        
        present(action, animated: true)
    }
}

extension DogListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dogs.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DogListTableViewCell.cellName,
                                                 for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? DogListTableViewCell {
            cell.configure(dog: viewModel.dogs[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 0.35 * 1.5 + 30.0
    }
}

//
//  ViewController.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit
import SnapKit

protocol MainViewProtocol: AnyObject {
    // Shall have reference to Presenter
    var presenter: MainPresenterProtocol? { get set }
    
    func showFetchedTasks(_ result: [TaskList])
    func showError(_ error: Error)
}

final class MainViewController: UIViewController, MainViewProtocol {
    var presenter: MainPresenterProtocol?
//    private var coreDataManager = CoreDataManager.shared
    
    // MARK: - UI Elements
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add new task here"
        textField.textColor = .gray
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = .systemGray6
        textField.textAlignment = .natural
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        // Метод, чтобы убрать тап вне экрана
        return textField
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.backgroundColor = .specialColorE
        button.tintColor = .white
        button.setTitle("Add task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addTaskButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .systemGray6
        return grayView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "defaultCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        // Метод, чтобы убрать тап вне экрана
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        title = "ToDo List"
        setupTitle()
        setupUserPresenter()
        setupViewHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
    
    // MARK: - Setup & Layout
    
    private func setupTitle() {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUserPresenter() {
        presenter?.viewDidLoad()
    }
    
    private func setupViewHierarchy() {
        [textField, addTaskButton, grayView].forEach { view.addSubview($0) }
        grayView.addSubview(tableView)
    }
    
    private func setupLayout() {
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(view).offset(-245)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            make.height.equalTo(45)
        }
        
        addTaskButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            make.height.equalTo(45)
        }
        
        grayView.snp.makeConstraints { make in
            make.top.equalTo(addTaskButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(grayView.snp.top).offset(15)
            make.leading.equalTo(grayView.snp.leading).offset(15)
            make.trailing.equalTo(grayView.snp.trailing).offset(-15)
            make.bottom.equalTo(grayView.snp.bottom).offset(-25)
//            make.height.lessThanOrEqualTo(tableView.contentSize.height)
            make.height.equalTo(0)
        }
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    deinit {
         tableView.removeObserver(self, forKeyPath: "contentSize")
     }
    
    func showFetchedTasks(_ result: [TaskList]) {
        DispatchQueue.main.async {
//            print("Tasks received: \(result.count)")
            self.tableView.reloadData()
//            self.tableView.layoutIfNeeded()
        }
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @objc
    private func addTaskButtonPressed() {
//        guard let task = textField.text, !task.isEmpty else { return }
//        presenter?.addNewTask(title: title ?? "Task unavailable")
//        textField.text = ""
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.tasksCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        if let task = presenter?.receiveTask(at: indexPath.row) {
            cell.textLabel?.text = task.todo
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //           let task = tasks[indexPath.row]
    //            presenter?.deleteTask(task)
    //            tableView.reloadData()
    //        }
    //    }
}

extension MainViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            tableView.snp.updateConstraints { make in
                make.height.equalTo(tableView.contentSize.height)
            }
        }
    }
}


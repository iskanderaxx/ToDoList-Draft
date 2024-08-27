//
//  ViewController.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit
import SnapKit

protocol MainViewProtocol: AnyObject {
    var presenter: MainPresenterProtocol? { get set }
    
//    func showFetchedTasks(_ result: [TaskList])
    func showData(of: [ToDoList])
    func showError(_ error: Error)
}

final class MainViewController: UIViewController, MainViewProtocol {
    var presenter: MainPresenterProtocol?
    
    private var coreDataManager = CoreDataManager.shared
    
    // MARK: - UI Elements
    
    private lazy var wallpaperView: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "mountain"))
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Task List"
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
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
        button.backgroundColor = .specialColorA
        button.tintColor = .white
        button.setTitle("Add task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
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

        setupTitle()
        setupUserPresenter()
        setupViewHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchTasksFromApi()
    }
    
    // MARK: - Setup & Layout
    
    private func setupTitle() {
        title = "ToDo List"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUserPresenter() {
        presenter = MainPresenter(view: self)
        presenter?.getAllTasks()
//        presenter?.fetchTasksFromApi()
    }
    
    private func setupViewHierarchy() {
        view.addSubview(wallpaperView)
        [headerLabel, textField, addTaskButton, grayView].forEach { wallpaperView.addSubview($0) }
        grayView.addSubview(tableView)
    }
    
    private func setupLayout() {
        wallpaperView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.height.width.equalTo(view)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(textField.snp.top).offset(-50)
            make.height.equalTo(45)
        }
        
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
        }
    }
    
    func updateTableViewHeight() {
        tableView.snp.updateConstraints { make in
            make.height.equalTo(tableView.contentSize.height)
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @objc
    private func addTaskButtonPressed() {
        guard let task = textField.text, !task.isEmpty else { return }
        presenter?.addTask(title: task)
        textField.text = ""
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.coreDataTasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = presenter?.coreDataTasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = task?.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let task = presenter?.coreDataTasks[indexPath.row] else { return }
            presenter?.deleteTask(task)
            tableView.reloadData()
        }
    }
}

extension MainViewController {
    
    //    func showFetchedTasks(_ result: [TaskList]) {
    //        DispatchQueue.main.async {
    //            self.tableView.reloadData()
    //        }
    //    }
    
    func showData(of tasks: [ToDoList]) {
        self.presenter?.coreDataTasks = tasks
        self.tableView.reloadData()
        self.updateTableViewHeight()
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

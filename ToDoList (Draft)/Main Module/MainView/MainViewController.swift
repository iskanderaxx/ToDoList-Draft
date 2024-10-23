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
    
    func showData(of: [ToDoList])
    func showError(_ error: Error)
    
    func showFetchedTasks(_ result: [TaskList])
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
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupViewHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchApiTasks()
    }
    
    // MARK: - Setup & Layout
    
    private func setupPresenter() {
//        presenter = MainPresenter(view: self)
//        presenter?.interactor = MainInteractor()
        
        presenter?.getAllTasks()
        presenter?.fetchApiTasks()
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
            make.height.equalTo(0)
        }
    }
    
    func updateTableViewHeight() {
        DispatchQueue.main.async {
            let contentHeight = self.tableView.contentSize.height
            self.tableView.snp.updateConstraints { make in
                make.height.equalTo(contentHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func showFetchedTasks(_ result: [TaskList]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateTableViewHeight()
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func addTaskButtonPressed() {
        guard let task = textField.text, !task.isEmpty else { return }
        presenter?.addTask(title: task)
        textField.text = ""
    }
}

// MARK: - Extensions

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allCoreDataTasks = presenter?.coreDataTasks.count ?? 0
        let allApiTasks = presenter?.apiTasks.count ?? 0
        return allCoreDataTasks + allApiTasks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        if indexPath.row < presenter?.coreDataTasks.count ?? 0 {
            let task = presenter?.coreDataTasks[indexPath.row]
            cell.textLabel?.text = task?.title
        } else {
            let apiTaskIndex = indexPath.row - (presenter?.coreDataTasks.count ?? 0)
            if let task = presenter?.receiveApiTask(at: apiTaskIndex) {
                cell.textLabel?.text = task.title
            }
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < presenter?.coreDataTasks.count ?? 0 {
            if let task = presenter?.coreDataTasks[indexPath.row] {
                presenter?.didSelectTask(task)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let task = presenter?.coreDataTasks[indexPath.row] else { return }
            presenter?.deleteTask(task)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
}

extension MainViewController {
    func showData(of tasks: [ToDoList]) {
        tableView.reloadData()
        updateTableViewHeight()
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

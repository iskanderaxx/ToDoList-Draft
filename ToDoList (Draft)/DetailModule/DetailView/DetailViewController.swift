//
//  DetailViewController.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

//import UIKit
//import SnapKit
//import CoreData
//
//final class DetailViewController: UIViewController, DetailViewProtocol {
//    
//    private let member: MemberList
//    private let coreDataManager = CoreDataManager.shared
//    private var isEditingEnabled = false
//    
//    // MARK: Initializers
//    
//    init(member: MemberList) {
//        self.member = member
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: UI Elements & Outlets
//    
//    private lazy var editButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.clipsToBounds = true
//        button.backgroundColor = .white
//        button.tintColor = .black
//        button.setTitle("Edit", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        button.setTitleColor(.black, for: .normal)
//        button.layer.cornerRadius = 10
//        button.layer.borderWidth = 3.0
//        button.layer.borderColor =
//        UIColor.systemBlue.cgColor
//        button.addTarget(self, action: #selector(
//            editButtonPressed), for: .touchUpInside) // Исправлено.
//        return button
//    }()
//    
//    private lazy var memberImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "eurovision")
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 125
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//    
//    private lazy var detailGrayView: UIView = {
//        let grayView = UIView()
//        grayView.backgroundColor = .systemGray6
//        return grayView
//    }()
//    
//    private lazy var memberDataTable: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.register(DetailViewCell.self,
//                           forCellReuseIdentifier: "detailDefaultCell")
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.layer.cornerRadius = 15
//        tableView.layer.masksToBounds = true
//        tableView.isScrollEnabled = false
//        return tableView
//    }()
//    
//    // MARK: Lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViewsHierarchy()
//        setupLayout()
//    }
//    
//    // MARK: Setup & Layout
//    
//    private func setupViewsHierarchy() {
//        [editButton, memberImage, detailGrayView].forEach { view.addSubview($0) }
//        detailGrayView.addSubview(memberDataTable)
//    }
//    
//    private func setupLayout() {
//        editButton.snp.makeConstraints { make in
//            make.top.equalTo(view).offset(140)
//            make.trailing.equalTo(view).offset(-20)
//            make.width.equalTo(100)
//            make.height.equalTo(40)
//        }
//        
//        memberImage.snp.makeConstraints { make in
//            make.centerX.equalTo(view)
//            make.top.equalTo(view).offset(210)
//            make.width.height.equalTo(250)
//        }
//        
//        detailGrayView.snp.makeConstraints { make in
//            make.top.equalTo(memberImage.snp.bottom).offset(30)
//            make.leading.trailing.bottom.equalTo(view)
//        }
//        
//        memberDataTable.snp.makeConstraints { make in
//            make.centerX.equalTo(detailGrayView)
//            make.top.equalTo(detailGrayView).offset(15)
//            make.leading.equalTo(detailGrayView.snp.leading).offset(15)
//            make.trailing.equalTo(detailGrayView.snp.trailing).offset(-15)
//            make.height.equalTo(4 * 60).priority(.high)
//        }
//    }
//    
//    func showError(with error: Error) {
//        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//    
//    // MARK: Actions
//    
//    @objc
//    func editButtonPressed() {
//        isEditingEnabled.toggle()
//
//        editButton.setTitle(isEditingEnabled ? "Save" : "Edit", for: .normal)
//        editButton.backgroundColor = isEditingEnabled ? .systemBlue : .white
//        
//        if !isEditingEnabled { coreDataManager.saveContext() }
//    }
//}
//
//// MARK: - Extensions
//
//extension DetailViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        MemberList.managedPropertiesCount
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        60
//    }
//    
//    // Не оч. модульно - добавить enum, который будет описывать кейсы
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailDefaultCell", for: indexPath) as? DetailViewCell else  {
//            return UITableViewCell()
//        }
//
//        switch indexPath.row {
//        case 0:
//            cell.configureCell(with: member.name ?? "", iconName: "person")
//        case 1:
//            if let dateOfBirth = member.dateOfBirth {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateStyle = .medium
//                cell.configureCell(with: dateFormatter.string(from: dateOfBirth), iconName: "calendar")
//            } else { cell.configureCell(with: "", iconName: "calendar") }
//        case 2:
//            cell.configureCell(with: member.gender ?? "", iconName: "person.2.circle")
//        case 3:
//            cell.configureCell(with: member.song ?? "", iconName: "music.note")
//        default:
//            break
//        }
//        return cell
//    }
//}
//
//extension DetailViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//         
//        if isEditingEnabled {
//            switch indexPath.row {
//            case 0:
//                presentTextInputAlert(for: indexPath, title: "Edit Name", text: member.name, placeholder: "Enter name") { [weak self] newName in
//                    self?.member.name = newName
//                    self?.memberDataTable.reloadRows(at: [indexPath], with: .automatic)
//                }
//            case 1:
//                presentDatePickerAlert(for: indexPath)
//            case 2:
//                presentGenderSelectionAlert(for: indexPath)
//            case 3:
//                presentTextInputAlert(for: indexPath, title: "Edit Song", text: member.song, placeholder: "Enter song") { [weak self] newSong in
//                    self?.member.song = newSong
//                    self?.memberDataTable.reloadRows(at: [indexPath], with: .automatic)
//                }
//            default:
//                break
//            }
//        }
//     }
//}
//
//private extension DetailViewController {
//    private func presentGenderSelectionAlert(for indexPath: IndexPath) {
//        let alert = UIAlertController(title: "Choose gender", message: nil, preferredStyle: .actionSheet)
//        let genders = ["Male", "Female", "Non-Binary"]
//        
//        genders.forEach { gender in
//            alert.addAction(UIAlertAction(title: gender, style: .default, handler: { [weak self] _ in
//                self?.member.gender = gender
//                self?.coreDataManager.saveContext()
//                self?.memberDataTable.reloadRows(at: [indexPath], with: .automatic)
//            }))
//        }
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        present(alert, animated: true, completion: nil)
//    }
//    
//    private func presentDatePickerAlert(for indexPath: IndexPath) {
//        let alert = UIAlertController(title: "Select date of birth", message: nil, preferredStyle: .actionSheet)
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        
//        if #available(iOS 14.0, *) { datePicker.preferredDatePickerStyle = .wheels }
//        alert.view.addSubview(datePicker)
//        
//        datePicker.snp.makeConstraints { make in
//            make.top.equalTo(alert.view).offset(20)
//            make.leading.equalTo(alert.view).offset(20)
//            make.trailing.equalTo(alert.view).offset(-20)
//            make.bottom.equalTo(alert.view).offset(-60)
//        }
//        
//        let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] _ in
//            self?.member.dateOfBirth = datePicker.date
//            self?.coreDataManager.saveContext()
//            self?.memberDataTable.reloadRows(at: [indexPath], with: .automatic)
//        }
//        alert.addAction(selectAction)
//        
//        present(alert, animated: true, completion: nil)
//    }
//    
//    private func presentTextInputAlert(for indexPath: IndexPath, title: String, text: String?, placeholder: String, completion: @escaping (String) -> Void) {
//        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
//        alert.addTextField { textField in
//            textField.text = text
//            textField.placeholder = placeholder
//        }
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
//            if let textField = alert.textFields?.first, let inputText = textField.text {
//                completion(inputText)
//            }
//        }))
//        present(alert, animated: true, completion: nil)
//    }
//}

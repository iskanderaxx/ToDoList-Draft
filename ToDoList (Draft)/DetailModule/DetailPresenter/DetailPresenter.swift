//
//  DetailPresenter.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

//import CoreData
//
//// Это должно быть отдельным файлом или в контроллере
//protocol DetailViewProtocol: AnyObject {
//    func showError(with error: Error)
//}
//
//final class DetailPresenter {
//    private let member: MemberList
//    private let coreDataManager: CoreDataManager
//    
//    init(member: MemberList, coreDataManager: CoreDataManager) {
//        self.member = member
//        self.coreDataManager = coreDataManager
//    }
//    
//    func getMemberName() -> String { member.name ?? "" }
//    
//    func getMemberGender() -> String { member.gender ?? "" }
//    
//    func getMemberSong() -> String { member.song ?? "" }
//    
//    func setMemberName(_ name: String) { member.name = name }
//    
//    func setMemberDateOfBirth(_ date: Date) { member.dateOfBirth = date }
//    
//    func setMemberGender(_ gender: String) { member.gender = gender }
//    
//    func setMemberSong(_ song: String) { member.song = song }
//    
//    func updateMember(name: String?, dateOfBirth: Date?, gender: String?, song: String?) {
//        if let name = name { setMemberName(name) }
//        if let dateOfBirth = dateOfBirth { setMemberDateOfBirth(dateOfBirth) }
//        if let gender = gender { setMemberGender(gender) }
//        if let song = song { setMemberSong(song) }
//        
//        coreDataManager.saveContext()
//    }
//}

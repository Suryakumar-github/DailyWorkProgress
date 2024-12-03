//
//  AdminDAO.swift
//  HelpDeskManagement
//
//  Created by incubation on 26/11/24.
//

protocol AdminDAO {
    func updatePassword(user: Admin, password: String) -> Result<Void, DatabaseError>
    func setDefaultpassword(passwordState : Bool,adminId : Int) -> Result<Void, DatabaseError>
}

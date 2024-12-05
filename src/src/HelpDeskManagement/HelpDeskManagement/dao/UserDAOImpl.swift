//
//  UserDAOImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 26/11/24.
//
import Foundation

class UserDAOImpl: UserDAO {

    var dataBase : DataBase
    init(dataBase : DataBase) {
        self.dataBase = dataBase
        do{
            try dataBase.createTable(createTableQuery: Queries.createUserTable)
        }
        catch {
            print("Error : \(error)")
        }
    }

    func getUserById(userId: Int) -> Result<User, DatabaseError> {
        let query = "SELECT * FROM Users WHERE user_id = ?"
        let data: [Any] = [
            userId
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            let result = try dataBase.executeQueryData(query: finalQuery)
            
            switch result {
            case .success(let usersData):
                if let userDict = usersData.first,
                   let id = userDict["user_id"] as? Int,
                   let name = userDict["name"] as? String,
                   let role = userDict["role"] as? String {
                    return .success(User(id: id, name: name, role: Role(rawValue: role) ?? Role.user))
                } else {
                    return .failure(.executionFailed("Failed to extract user data."))
                }
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }

    func changePassword(user: User, newPassword password: String) -> Result<Void, DatabaseError>  {
        let query = "UPDATE userNameAndPasswords SET password = ? where userId = ?;"
        
        let data: [Any] = [
            password,
            user.getId
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }

    func addUser(user: User) -> Result<Void, DatabaseError> {
        let query = "INSERT INTO Users (name, role) VALUES (?, ?)"
        
        let data: [Any] = [
            user.getName,
            user.getRole.rawValue
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            print("Query : \(finalQuery)")
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }

    func getAllUsers() throws -> Result<[User], DatabaseError> {
        let query = "SELECT id, name, role FROM Users;"
            
        let result = try dataBase.executeQueryData(query: query)
        switch result {
        case .success(let usersData):
                
            let users = usersData.compactMap { userDict -> User? in
                guard let id = userDict["id"] as? Int,
                        let name = userDict["name"] as? String,
                        let role = userDict["role"] as? String else {
                        return nil
                }
                return User(id: id, name: name, role: Role(rawValue: role) ?? Role.user)
            }
            return .success(users)
                
            case .failure(let error):
                return .failure(error)
        }
    }
    
    func addUsersUserNamePassword(userName: String, password: String, user: User) -> Result<Void, DatabaseError> {
        let query = "INSERT INTO userNameAndPasswords (userName, password, userId) values (?,?,?);"
        let data: [Any] = [userName, password, user.getId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            let result: Result<Void, DatabaseError> = try dataBase.insertRecord(query: finalQuery)
            
            switch result {
            case .success:
                return .success(())
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }

    func getUserNameAndPassword(userId: Int) -> Result<[String], DatabaseError> {
        let query = "SELECT userName, password FROM userNameAndPasswords WHERE userId = ?;"
        let data: [Any] = [userId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            let result = try dataBase.executeQueryData(query: finalQuery)
            
            switch result {
            case .success(let usersData):
                let credentials = usersData.compactMap { userDict -> [String]? in
                    guard let userName = userDict["userName"] as? String,
                          let password = userDict["password"] as? String else {
                        return nil
                    }
                    return [userName, password]
                }
                
                return .success(credentials.flatMap { $0 })
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }

    func getUserRole(userName: String, password: String) -> Result<(String, Int), DatabaseError> {
        let query = """
        SELECT Users.role, Users.user_id
        FROM Users
        JOIN userNameAndPasswords
        ON Users.user_id = userNameAndPasswords.userId
        WHERE userNameAndPasswords.userName = ?
        AND userNameAndPasswords.password = ?;
        """
        let data: [Any] = [
            userName,
            password
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            let result = try dataBase.executeQueryData(query: finalQuery)
            
            switch result {
            case .success(let usersData):
                
                if let userDict = usersData.first,
                   let role = userDict["role"] as? String,
                   let userId = userDict["user_id"] as? Int {
                    return .success((role, userId))
                } else {
                    return .failure(.executionFailed("Failed to extract role or user_id."))
                }
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getAgentByUserId(userId: Int) -> Result<Agent, DatabaseError> {
        let query = "SELECT * FROM Agents WHERE userId = ?;"
        let data: [Any] = [userId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            let result = try dataBase.executeQueryData(query: finalQuery)
            
            switch result {
            case .success(let usersData):
                guard let userDict = usersData.first else {
                    
                    return .failure(.noRecordFound("No agent found with userId \(userId)."))
                }
                
                if let userDict = usersData.first,
                   let id = userDict["agent_id"] as? Int,
                   let department = userDict["department"] as? String,
                   let availabilityStatus = userDict["availabilityStatus"] as? String,
                   let ticketsResolvedCount = userDict["ticketsResolvedCount"] as? Int,
                   let userId = userDict["userId"] as? Int,
                   let name = userDict["name"] as? String
                {
                    return .success(Agent(
                        id: id,
                        name: name,
                        department: department,
                        status: AgentStatus(rawValue: availabilityStatus) ?? .available,
                        ticketResolved: ticketsResolvedCount,
                        userId: userId
                    ))
                } else {
                    return .failure(.executionFailed("Failed to extract user data: \(userDict)"))
                }
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getAdminByUserId(userId: Int) -> Result<Admin?, DatabaseError> {
        let query = "SELECT * FROM admin WHERE userId = ?;"
        let data: [Any] = [userId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            let result = try dataBase.executeQueryData(query: finalQuery)
            
            switch result {
            case .success(let usersData):
                if let userDict = usersData.first,
                   let hasDefaultPasswordInt = userDict["hasDefaultPassword"] as? Int,
                   let userId = userDict["userId"] as? Int,
                   let name = userDict["name"] as? String {
                    
                    let hasDefaultPassword = (hasDefaultPasswordInt == 1)
                    
                    return .success(Admin(
                        name: name,
                        role: .admin,
                        userId: userId,
                        hasDefaultPassword: hasDefaultPassword
                    ))
                } else {
                    return .failure(.executionFailed("Failed to extract user data: \(usersData)"))
                }
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getLastCreatedUserId() throws -> Result<Int, DatabaseError> {
        let query = "SELECT MAX(user_id) AS lastUserId FROM Users;"
        
        let result = try dataBase.executeQueryData(query: query)
        
        switch result {
        case .success(let userIdData):
            if let userDict = userIdData.first,
               let lastUserId = userDict["lastUserId"] as? Int {
                return .success(lastUserId)
            } else {
                return .failure(.executionFailed("Failed to extract the last created user ID."))
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }

}

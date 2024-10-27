import UIKit

import Foundation

//  Representing and Throwing Errors
enum BankAccountError: Error {
    case insufficientFunds(required: Double)
    case invalidAmount
    case accountFrozen
}

class BankAccount {
    var balance: Double
    var isFrozen: Bool
    
    init(balance: Double, isFrozen: Bool = false) {
        self.balance = balance
        self.isFrozen = isFrozen
    }
    
    // Propagating Errors Using Throwing Functions
    func withdraw(amount: Double) throws {
        guard !isFrozen else {
            throw BankAccountError.accountFrozen
        }
        
        guard amount > 0 else {
            throw BankAccountError.invalidAmount
        }
        
        guard balance >= amount else {
            throw BankAccountError.insufficientFunds(required: amount - balance)
        }
        
        balance -= amount
    }
    
    func deposit(amount: Double) throws {
        guard !isFrozen else {
            throw BankAccountError.accountFrozen
        }
        
        guard amount > 0 else {
            throw BankAccountError.invalidAmount
        }
        
        balance += amount
    }
}

// A function to demonstrate error handling and cleanup actions
func performBankOperations() {
    let account = BankAccount(balance: 100)
    
    //  Specifying Cleanup Actions using `defer`
    defer {
        print("Thank you for using our bank services!")
    }
    
    // Handling Errors Using Do-Catch
    do {
        try account.withdraw(amount: 50)
        print("Withdrawal successful! Current balance: \(account.balance)")
        
        try account.withdraw(amount: 70)
        print("Withdrawal successful! Current balance: \(account.balance)")
        
    } catch BankAccountError.insufficientFunds(let required) {
        print("Insufficient funds. You need \(required) more.")
    } catch BankAccountError.invalidAmount {
        print("Invalid amount. Please enter a valid number.")
    } catch BankAccountError.accountFrozen {
        print("The account is frozen. You can't perform transactions.")
    } catch {
        print("An unknown error occurred.")
    }
    
    // Converting Errors to Optional Values using `try?`
    let depositSuccess = try? account.deposit(amount: 200)
    if depositSuccess != nil {
        print("Deposit successful! Current balance: \(account.balance)")
    } else {
        print("Failed to deposit funds.")
    }
    
    // Converting a failure case to nil
    account.isFrozen = true
    if let _ = try? account.withdraw(amount: 10) {
        print("Withdrawal successful! Current balance: \(account.balance)")
    } else {
        print("Failed to withdraw funds because the account is frozen.")
    }
}

performBankOperations()

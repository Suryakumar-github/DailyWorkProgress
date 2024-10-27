import UIKit

struct BankAccount {
    var balance: Double

    mutating func deposit(amount: Double) {
        balance += amount
    }
}

extension BankAccount {
    mutating func transfer(amount: Double, to: inout BankAccount) {
        guard amount <= balance else { return }
        balance -= amount
        deposit(amount: amount)
    }
}

var account1 = BankAccount(balance: 1000)
var account2 = BankAccount(balance: 500)

account1.transfer(amount: 200, to: &account2)

account1.transfer(amount: 100, to: &account1)


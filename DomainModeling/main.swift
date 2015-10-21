//
//  main.swift
//  DomainModeling
//
//  Created by Cechi Shi on 10/14/15.
//  Copyright © 2015 Cechi Shi. All rights reserved.
//

import Foundation

protocol CustomStringConvertible {
    var description: String { get }
}

protocol Mathematics {
    mutating func add(other: Self) -> Void
    mutating func subtract(other: Self) -> Void
}

extension Double {
    var USD: Money { return Money(amount: self, currency: Currency.USD) }
    var GBP: Money { return Money(amount: self, currency: Currency.GBP) }
    var CAN: Money { return Money(amount: self, currency: Currency.CAN) }
    var EUR: Money { return Money(amount: self, currency: Currency.EUR) }
}

enum Currency: String {
    case USD, GBP, CAN, EUR
}

struct Money: CustomStringConvertible, Mathematics {
    var amount: Double
    var currency: Currency
    var description: String
    
    init(amount: Double, currency: Currency) {
        self.amount = amount
        self.currency = currency
        self.description = currency.rawValue + String(amount)
    }
    
    func convert(currency: Currency) -> Double {
        switch self.currency {
        case .USD:
            switch currency {
            case .GBP: return self.amount / 2.0
            case .CAN: return self.amount * 1.25
            case .EUR: return self.amount * 1.5
            default: break
            }
        case .GBP:
            switch currency {
            case .USD: return self.amount * 2.0
            case .CAN: return self.amount * 1.5
            case .EUR: return self.amount * 2.5
            default: break
            }
        case .CAN:
            switch currency {
            case .USD: return self.amount / 1.25
            case .GBP: return self.amount / 1.5
            case .EUR: return self.amount * 1.2
            default: break
            }
        case .EUR:
            switch currency {
            case .USD: return self.amount / 1.5
            case .GBP: return self.amount / 2.5
            case .CAN: return self.amount / 1.2
            default: break
            }
        }
        return self.amount
    }
    
    mutating func add(other: Money) -> Void {
        self.amount += other.convert(self.currency)
    }
    
    mutating func subtract(other: Money) -> Void {
        self.amount -= other.convert(self.currency)
    }
}

enum Salary {
    case hourly(Double)
    case annual(Double)
}

class Job: CustomStringConvertible {
    var title: String
    var salary: Salary
    var description: String
    
    init(title: String, salary: Salary) {
        self.title = title
        self.salary = salary
        switch salary {
        case .hourly(let amount):
            self.description = "Title: \(title)\nHourly salary: \(amount)"
        case .annual(let amount):
            self.description = "Title: \(title)\nAnnual salary: \(amount)"
        }
    }
    
    // calculate annual salary
    func calculateIncome(annualHours: Double) -> Double {
        switch self.salary {
        case .hourly(let amount):
            return amount * annualHours
        case .annual(let amount):
            return amount
        }
    }
    
    // raises salary by passed percentage
    func raise(percentage: Double) -> Void {
        switch self.salary {
        case .hourly(let amount):
            self.salary = Salary.hourly(amount * (1.0 + (percentage / 100.0)))
        case .annual(let amount):
            self.salary = Salary.annual(amount * (1.0 + (percentage / 100.0)))
        }
    }
}

class Person: CustomStringConvertible {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job?
    var spouse: Person?
    var description: String
    
    let WORKING_AGE = 16 // Age below 16 cannot have a job or a spouse
    let MARRIAGE_AGE = 18 // Age below 18 cannot have a spouse
    
    init(firstName: String, lastName: String, age: Int, job: Job?, spouse: Person?) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
        self.description = ""
        
        // Input cleaning
        if age < WORKING_AGE {
            self.job = nil
            self.spouse = nil
        }
        
        if age < MARRIAGE_AGE {
            self.spouse = nil
        }
        
        // married and employed
        if self.spouse != nil && self.job != nil {
            self.description = "\(firstName) \(lastName) is \(age) years old, working as a \(self.job!.title) and married to \(self.spouse!.firstName) \(self.spouse!.lastName)."
        }
        // unmarried and employed
        else if self.spouse == nil && self.job != nil {
            self.description = "\(firstName) \(lastName) is \(age) years old, working as a \(self.job!.title)."
        }
        // married and unemployed
        else if self.spouse != nil && self.job == nil {
            self.description = "\(firstName) \(lastName) is \(age) years old, married to \(self.spouse!.firstName) \(self.spouse!.lastName)."
        }
        // unmarried and unemployed
        else {
            self.description = "\(firstName) \(lastName) is \(age) years old."
        }
    }
    
    func toString() -> String {
        return self.description
    }
}

class Family: CustomStringConvertible {
    var members: [Person]
    var isLegal: Bool
    var description: String
    let LEGAL_AGE = 21
    
    init(members: [Person]) {
        self.members = members
        self.isLegal = false
        self.description = ""
        for member in members {
            // a legal family contains at least one person that is aged above 21
            if member.age >= LEGAL_AGE {
                self.isLegal = true
            }
            self.description += "\(member.firstName) \(member.lastName), "
        }
        let index = self.description.endIndex.advancedBy(-2)
        self.description = self.description.substringToIndex(index)
    }
    
    func householdIncome(individualAnnualHours: Double) -> Double {
        var result = 0.0
        for member in members {
            result += (member.job?.calculateIncome(individualAnnualHours))!
        }
        return result
    }
    
    func haveChild(firstName: String, lastName: String) -> Void {
        let baby = Person(firstName: firstName, lastName: lastName, age: 0, job: nil, spouse: nil)
        self.members.append(baby)
    }
}

// Unit Tests

print("======Extension======")
print("2.USD.convert(Currency.EUR) = \(2.USD.convert(Currency.EUR))")
print("2.5.USD.convert(Currency.GBP) = \(2.5.USD.convert(Currency.GBP))")
print("3.USD.convert(Currency.CAN) = \(3.USD.convert(Currency.CAN))")
print("8.USD.convert(Currency.USD) = \(8.USD.convert(Currency.USD))")
print("")
print("======Protocol Property======")
print("1.USD.description = \(1.USD.description)")
print("22.EUR.description = \(22.EUR.description)")
let researcher = Job(title: "researcher", salary: Salary.annual(100000.0))
print("let researcher = Job(title: \"researcher\", salary: Salary.annual(100000.0))")
print("print(researcher.description)")
print("Output: \(researcher.description)")
print("let me = Person(firstName: \"Tristan\", lastName: \"Shi\", age: 22, job: nil, spouse: nil)")
let me = Person(firstName: "Tristan", lastName: "Shi", age: 22, job: nil, spouse: nil)
print("let sibling = Person(firstName: \"John\", lastName: \"Shi\", age: 25, job: researcher, spouse: nil)")
let sibling = Person(firstName: "John", lastName: "Shi", age: 25, job: researcher, spouse: nil)
print("print(me.description)")
print("Output:\n\(me.description)")
print("print(sibling.description)")
print("Output:\n\(sibling.description)")
print("let myFamily = Family(members: [me, sibling])")
let myFamily = Family(members: [me, sibling])
print("print(myFamily.description)")
print("Output: \(myFamily.description)")
print("")
print("")
print("======Protocol Methods======")
var oneBuck = 1.USD
print("var oneBuck = 1.USD")
oneBuck.add(1.GBP)
print("oneBuck.add(1.GBP)")
print("oneBuck.amount = \(oneBuck.amount)")
oneBuck.subtract(2.CAN)
print("oneBuck.subtract(2.CAN)")
print("oneBuck.amount = \(oneBuck.amount)")

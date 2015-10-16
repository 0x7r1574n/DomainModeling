//
//  main.swift
//  DomainModeling
//
//  Created by Cechi Shi on 10/14/15.
//  Copyright © 2015 Cechi Shi. All rights reserved.
//

import Foundation

struct Money {
    var amount: Double
    var currency: String
    
    init(amount: Double, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    mutating func convert(currency: String) -> Void {
        switch self.currency {
        case "USD":
            switch currency {
            case "USD": break
            case "GBP": self.amount /= 2.0
            case "CAN": self.amount *= 1.25
            case "EUR": self.amount *= 1.5
            default: break
            }
        case "GBP":
            switch currency {
            case "USD": self.amount *= 2.0
            case "GBP": break
            case "CAN": self.amount *= 1.5
            case "EUR": self.amount *= 2.5
            default: break
            }
        case "CAN":
            switch currency {
            case "USD": self.amount /= 1.25
            case "GBP": self.amount /= 1.5
            case "CAN": break
            case "EUR": self.amount *= 1.2
            default: break
            }
        case "EUR":
            switch currency {
            case "USD": self.amount /= 1.5
            case "GBP": self.amount /= 2.5
            case "CAN": self.amount /= 1.2
            case "EUR": break
            default: break
            }
        default: break
        }
    }
    
    mutating func add(other: Money) {
        var temp = other
        temp.convert(self.currency)
        self.amount += temp.amount
    }
    
    mutating func subtract(other: Money) {
        var temp = other
        temp.convert(self.currency)
        self.amount -= temp.amount
    }
}

class Job {
    var title: String
    // first element is type of salary (annually/hourly), second element is the amount
    var salary: (String, Double)
    
    init(title: String, salary: (String, Double)) {
        self.title = title
        self.salary = salary
    }
    
    // calculate annual salary
    func calculateIncome(annualHours: Double) -> Double {
        if self.salary.0 != "Annual" {
            return annualHours * self.salary.1
        } else {
            return self.salary.1
        }
    }
    
    // raises salary by passed percentage
    func raise(percentage: Double) -> Void {
        self.salary.1 *= (1.0 + percentage / 100.0)
    }
}

class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job?
    var spouse: Person?
    
    let WORKING_AGE = 16 // Age below 16 cannot have a job or a spouse
    let MARRIAGE_AGE = 18 // Age below 18 cannot have a spouse
    
    init(firstName: String, lastName: String, age: Int, job: Job?, spouse: Person?) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
        
        // Input cleaning
        if age < WORKING_AGE {
            self.job = nil
            self.spouse = nil
        }
        
        if age < MARRIAGE_AGE {
            self.spouse = nil
        }
    }
    
    func toString() -> String {
        // married and employed
        if self.spouse != nil && self.job != nil {
            return "\(firstName) \(lastName) is \(age) years old, working as a \(job!.title) and married to \(self.spouse!.firstName) \(self.spouse!.lastName)."
        }
        // unmarried and employed
        else if self.spouse == nil && self.job != nil {
            return "\(firstName) \(lastName) is \(age) years old, working as a \(job!.title)."
        }
        // married and unemployed
        else if self.spouse != nil && self.job == nil {
            return "\(firstName) \(lastName) is \(age) years old, married to \(self.spouse!.firstName) \(self.spouse!.lastName)."
        }
        // unmarried and unemployed
        else {
            return "\(firstName) \(lastName) is \(age) years old."
        }
    }
}

class Family {
    var members: [Person]
    var isLegal: Bool
    let LEGAL_AGE = 21
    
    init(members: [Person]) {
        self.members = members
        self.isLegal = false
        for member in members {
            // a legal family contains at least one person that is aged above 21
            if member.age >= LEGAL_AGE {
                self.isLegal = true
            }
        }
    }
    
    func householdIncome(individualAnnualHours: Double) -> Double {
        var result = 0.0
        for member in members {
            if member.job != nil {
                result += (member.job?.calculateIncome(individualAnnualHours))!
            }
        }
        return result
    }
    
    func haveChild(firstName: String, lastName: String, age: Int = 0) -> Void {
        let baby = Person(firstName: firstName, lastName: lastName, age: age, job: nil, spouse: nil)
        self.members.append(baby)
    }
}

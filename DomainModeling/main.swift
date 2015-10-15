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
    enum Salary: Double {
        case Yearly
        case Hourly
    }
    var salary: Salary
    init(title: String, salary: Salary) {
        self.title = title
        self.salary = salary
    }
}

class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job?
    var spouse: Person?
    
    init(firstName: String, lastName: String, age: Int, job: Job?, spouse: Person?) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
        // Input cleaning
        // Age below 16 cannot have a job or a spouse
        if age < 16 {
            self.job = nil
            self.spouse = nil
        }
        // Age below 18 cannot have a spouse
        if age < 18 {
            self.spouse = nil
            self.job = job
        }
    }
    
    func toString() -> String {
        if self.spouse != nil && self.job != nil {
            return "\(firstName) \(lastName) is \(age) years old, working as a \(job!.title) and married to \(self.spouse!.firstName) \(self.spouse!.lastName)."
        }
        else if self.spouse == nil && self.job != nil {
            return "\(firstName) \(lastName) is \(age) years old, working as a \(job!.title)."
        }
        else if self.spouse != nil && self.job == nil {
            return "\(firstName) \(lastName) is \(age) years old, married to \(self.spouse!.firstName) \(self.spouse!.lastName)."
        }
        else {
            return "\(firstName) \(lastName) is \(age) years old."
        }
    }
}







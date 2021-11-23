//
//  Person.swift
//  ChristmasCardApp
//
//  Created by James Daniel on 10/16/21.
//

import Foundation
import RealmSwift


class Person: Object {
    @Persisted var firstName: String?
    @Persisted var lastName: String?
    @Persisted var address1: String?
    @Persisted var address2: String?
    @Persisted var city: String?
    @Persisted var state: String?
    @Persisted var zipcode: String?
    @Persisted var holidayIcon: String?
    @Persisted var relation: String?
    @Persisted var beliefs: String?
    
    @Persisted var sentCards: List<String?>
    
    @Persisted var recievedCards: List<String?>
    
    
    func getFullName() -> String {
        return "\(firstName!) \(lastName!)" //", \(relation!), \(beliefs!)"
    }
    func getAddress1() -> String {
        return "\(address1!) - \(address2!)"
    }
    func getCityStateZip() -> String {
        return "\(city!), \(state!) \(zipcode!)"
    }
    
    
}

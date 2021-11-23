//
//  PeopleManager.swift
//  ChristmasCardApp
//
//  Created by James Daniel on 10/13/21.
//

import Foundation
import RealmSwift

class PeopleManager: NSObject {
    
    var realm = try! Realm()
    private override init() {} // this is to protect the class
    
    static let sharedInstance = PeopleManager() // this creates ONE of these
    
    var people: [Person] = []
    
    private var currentPerson: Person?
    
    func getPeople(num: Int) -> [Person] {
        
        let peeps = realm.objects(Person.self)
        
        if peeps.count <= 0 {
            createPeople(num: 10-1)
        } else {
            people.removeAll()
            for p in peeps {
                people.append(p)
            }
        }
        

        return people
    }
    // Set current person
    func setCurrentPerson(person: Person) {
        currentPerson = person
    }
    // Get current person
    func getCurrentPerson() -> Person? {
        return currentPerson
    }
    // Add person to people array
    func addPerson(person: Person) {
        //people.append(person)
        try! realm.write{
            var p = Person()
            p = person
            realm.add(p)
        }
    }
    // Update a person object with an edited version of the object in the same index location.
    func updatePerson(editedPerson: Person) {
        // I am getting the index of the person object in the array and replacing it with the new one.
//        if let editedPersonIndex = people.firstIndex(of: person) {
//            people[editedPersonIndex] = editedPerson
//            currentPerson = editedPerson
//        }
        try! realm.write{
            currentPerson?.firstName = editedPerson.firstName
            currentPerson?.lastName = editedPerson.lastName
            currentPerson?.address1 = editedPerson.address1
            currentPerson?.address2 = editedPerson.address2
            currentPerson?.city = editedPerson.city
            currentPerson?.state = editedPerson.state
            currentPerson?.zipcode = editedPerson.zipcode
            currentPerson?.relation = editedPerson.relation
            currentPerson?.holidayIcon = editedPerson.holidayIcon ?? self.getRandomIcon()
            currentPerson?.beliefs = editedPerson.beliefs
        }
        
        
    }
    
    func addSentCard(dateSent: String) {
        try! realm.write{
            currentPerson?.sentCards.append(dateSent)
        }
    }
    
    // Delete person from people array
    func deletePerson(person: Person) {
        
//        if people.contains(person) {
//            people.remove(at: people.firstIndex(of: person)!)
//        }
        
        try! realm.write{
            realm.delete(person)
        }
        
    }
    
    func resetCurrentPerson() {
        currentPerson = nil
    }
    
    
    
    private func createPeople(num: Int) {
//        for person in 0...num {
//            let p: Person = Person()
//            p.firstName = "First \(person)"
//            p.lastName = "Last \(person)"
//            p.address1 = "Address 1 - \(person)"
//            p.address2 = "Address 2 - \(person)"
//            p.city = "City \(person)"
//            p.state = "XX"
//            p.zipcode = "\(11110 + person)"
//            //p.sentCards
//            //p.recievedCards = []
//            p.relation = "Relation"
//            p.holidayIcon = getRandomIcon()
//            p.beliefs = "Celebrates"
//
//            people.append(p)
//        }
        
        for person in 0...num {
            try! realm.write {
                let p: Person = Person()
                p.firstName = "First \(person)"
                p.lastName = "Last \(person)"
                p.address1 = "Address 1 - \(person)"
                p.address2 = "Address 2 - \(person)"
                p.city = "City \(person)"
                p.state = "XX"
                p.zipcode = "\(11110 + person)"
                //p.sentCards
                //p.recievedCards = []
                p.relation = "Relation"
                p.holidayIcon = getRandomIcon()
                p.beliefs = "Celebrates"
                people.append(p)
                realm.add(p)
            }
        }
        
    }
    
    func getRandomIcon() -> String {
        let rndInt = Int.random(in: 0...1)
        if rndInt == 0 {
            return "xmas"
        } else {
            return "starofdavid"
        }
    }
}

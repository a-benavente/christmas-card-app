//
//  ViewController.swift
//  ChristmasCardApp
//
//  Created by James Daniel on 9/29/21.
//

import UIKit
import RealmSwift


class ViewController: UIViewController {
    
  
    
    
    @IBOutlet weak var peopleTableView: UITableView!
    @IBOutlet weak var addPersonButton: UIButton!
    
    @IBOutlet weak var sortButton: UIButton!
    
    let realm = try! Realm()

        
    
    var people: [Person] = []
    var sortedPeople: [Person] = []
    
    var isColor: Bool = false
    var sortOrder: Bool = true // true is ascending / false is descending or not sorted
    var areTheySorted: Bool = false
    
    var peopleManager: PeopleManager!
    let currentPerson = PeopleManager.sharedInstance.getCurrentPerson()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm is located at:", realm.configuration.fileURL!)
        peopleManager = PeopleManager.sharedInstance
        // PUT DB calls
        people = peopleManager.getPeople(num: 10)
        sortButtonTapped(self)
        print("ViewDidLoad")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        peopleManager.resetCurrentPerson() // making sure that when the main screen is viewed. No current person is active
//        if sortedPeople.count <= 0 && peopleManager.people.count > people.count {
//            people = peopleManager.getPeople(num: 0)
//            self.sortButtonTapped(self)
//        }
        //people = peopleManager.getPeople(num: 0)
       
        people = peopleManager.getPeople(num: 0)
        self.sortButtonTapped(self)
        peopleTableView.reloadData()
        
        print("ViewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewDidAppear")
    }
    
    
    @IBAction func addPersonButtonTapped(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditPersonViewController")
//        vc?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        self.present(vc!, animated: true, completion: nil)
        var nav = self.navigationController
        nav?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        
        if sortOrder == false {
            sortedPeople.removeAll()
            sortedPeople.append(contentsOf: people)
            sortedPeople.sort{$0.firstName! > $1.firstName!}
            sortOrder = true
        } else {
            sortedPeople.removeAll()
            sortedPeople.append(contentsOf: people)
            sortedPeople.sort{$0.firstName! < $1.firstName!}
            sortOrder = false
        }
        
        peopleTableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if people.count <= 0 {
            return 0
        } else if sortedPeople.count > 0 {
            return sortedPeople.count
        } else {
            return people.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peoplecell", for: indexPath)
        var firstname = ""
        var lastname = ""
        var celebration = ""
        
        if let celebr8 = sortedPeople[indexPath.row].beliefs{
            if celebr8 == "Kwanzaa" {
                celebration = "🕎"
            } else if celebr8 == "Hanukkah"{
                celebration = "✡️"
            } else if celebr8 == "Christmas" {
                celebration = "✝️"
                
            } else {
                celebration = "❓"
            }
        }
        if let fname = sortedPeople[indexPath.row].firstName {
            firstname = fname
        }
        if let lname = sortedPeople[indexPath.row].lastName {
            lastname = lname
        }
        cell.textLabel?.text = "\(firstname) \(lastname), \(celebration)"
       //cell.detailTextLabel?.text = "This is detail text"
        cell.imageView?.image = UIImage(named: sortedPeople[indexPath.row].holidayIcon!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        peopleManager.setCurrentPerson(person: sortedPeople[indexPath.row])
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PersonInfoViewController") as! PersonInfoViewController
        //vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //self.present(vc, animated: true, completion: nil)
        var nav = self.navigationController
        nav?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
            if (editingStyle == .delete) {
                //tableView.beginUpdates()
                
                //self.people.remove(at: indexPath.item)
                self.peopleManager.deletePerson(person: sortedPeople[indexPath.row])
                self.people = self.peopleManager.getPeople(num: 0)
                self.sortButtonTapped(self)
                self.peopleTableView.reloadData()
                //tableView.deleteRows(at: [indexPath], with: .automatic)
                //tableView.endUpdates()
                
        
            }
        
    }
//    func tableView(_ tableView: UITableView,
//        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//     {
//         let modifyAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
////             [indexPath.row].remove(at: people[indexPath.row])
////             self.peopleTableView.reloadData()
//             print("Update action ...")
//             success(true)
//         })
//
//         modifyAction.image = UIImage(systemName: "trash")
//         modifyAction.backgroundColor = .red
//
//         return UISwipeActionsConfiguration(actions: [modifyAction])
//     }
//    func deleteData(at indexPath: IndexPath) {
//        self.delete(forRowAtIndexPath: indexPath)
//        }
    
    
}

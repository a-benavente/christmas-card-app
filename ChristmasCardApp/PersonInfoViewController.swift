//
//  PersonInfoViewController.swift
//  ChristmasCardApp
//
//  Created by James Daniel on 10/16/21.
//

import UIKit
import RealmSwift

class PersonInfoViewController: UIViewController {

    
    @IBOutlet weak var personNameLabel: UILabel!
    
    @IBOutlet weak var personAddressLabel: UILabel!
    @IBOutlet weak var personCityStateZipcodeLabel: UILabel!
    
    @IBOutlet weak var sentTableView: UITableView!
    @IBOutlet weak var recievedTableView: UITableView!
    
    @IBOutlet weak var editPersonButton: UIButton!
    
    @IBOutlet weak var addSentButton: UIButton!
    @IBOutlet weak var addRecievedButton: UIButton!
    
    @IBOutlet weak var holidayImageView: UIImageView!
    
    var peopleManager: PeopleManager!
    var currentPerson: Person?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peopleManager = PeopleManager.sharedInstance
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentPerson = peopleManager.getCurrentPerson()
        
        if let fullName = currentPerson?.getFullName() {
            personNameLabel.text = fullName
        }
        if let fullAddress = currentPerson?.getAddress1() {
            personAddressLabel.text = fullAddress
        }
        if let cityStateZip = currentPerson?.getCityStateZip() {
            personCityStateZipcodeLabel.text = cityStateZip
        }
        
        if let holidayPic = currentPerson?.holidayIcon {
            holidayImageView.image = UIImage(named: holidayPic)
//            switch holidayPic {
//            case "xmas":
//                self.view.backgroundColor = UIColor(red: 50 / 255, green: 125 / 255, blue: 50 / 255, alpha: 1.0)
//            case "starofdavid":
//                self.view.backgroundColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 125 / 255, alpha: 1.0)
//            default:
//                break
//            }
        }
        
    
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @IBAction func editPersonButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditPersonViewController") as! AddEditPersonViewController
//        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        self.present(vc, animated: true, completion: nil)
        var nav = self.navigationController
        nav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addSentButtonTapped(_ sender: Any) {
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY hh:mm:ss"
        
        //currentPerson?.sentCards.append(dateFormatter.string(from: Date()))
        peopleManager.addSentCard(dateSent: dateFormatter.string(from: Date()))
        sentTableView.reloadData()
    }
    
    @IBAction func addRecievedButtonTapped(_ sender: Any) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY hh:mm:ss"
        
        currentPerson?.recievedCards.append(dateFormatter.string(from: Date()))
        recievedTableView.reloadData()
    }
    
}

extension PersonInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == sentTableView {
            return 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == sentTableView {
            return (currentPerson?.sentCards.count)!
        } else {
            return (currentPerson?.recievedCards.count)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sentCell", for: indexPath)
            cell.textLabel?.text = currentPerson?.sentCards[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recievedCell", for: indexPath)
            cell.textLabel?.text = currentPerson?.recievedCards[indexPath.row]
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sentTableView {
            print("Sent table Tapped")
        } else {
            print("Recieved table Tapped")
        }
    }
    
    
}

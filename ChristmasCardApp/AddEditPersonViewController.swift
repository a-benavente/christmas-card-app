//
//  AddEditPersonViewController.swift
//  ChristmasCardApp
//
//  Created by James Daniel on 10/6/21.
//

import UIKit
import RealmSwift

class AddEditPersonViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var addressOneTextField: UITextField!
    @IBOutlet weak var addressTwoTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var topSaveButton: UIButton!
    @IBOutlet weak var buttonSaveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addEditPersonLabel: UILabel!
    @IBOutlet weak var beliefsTextField: UITextField!
    @IBOutlet weak var relationTextField: UITextField!
    
    let realm = try! Realm()
    
    var peopleManager: PeopleManager!
    let currentPerson = PeopleManager.sharedInstance.getCurrentPerson()
    var editingPerson: Bool = false
    
    
    var textFieldArray: [UITextField] = []
    var buttonArray: [UIButton] = []
    
    var pickerView = UIPickerView()
    let beliefs = ["Christmas", "Hanukkah", "Kwanzaa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        beliefsTextField.inputView = pickerView
        
        peopleManager = PeopleManager.sharedInstance
        
        if currentPerson == nil{
            addEditPersonLabel.text = "Add Person"
            editingPerson = false
        } else {
            addEditPersonLabel.text = "Edit Person"
            editingPerson = true
        }
        
        self.stateTextField.delegate = self
        self.zipcodeTextField.delegate = self
        
        textFieldArray = [firstNameTextField, lastnameTextField, addressTwoTextField, addressOneTextField, cityTextField, stateTextField, zipcodeTextField, relationTextField, beliefsTextField]
        buttonArray = [buttonSaveButton]
        
        setupFields(fields: textFieldArray)
        setupButtons(buttons: buttonArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firstNameTextField.text = currentPerson?.firstName
        lastnameTextField.text = currentPerson?.lastName
        addressOneTextField.text = currentPerson?.address1
        addressTwoTextField.text = currentPerson?.address2
        cityTextField.text = currentPerson?.city
        stateTextField.text = currentPerson?.state
        zipcodeTextField.text = currentPerson?.zipcode
        beliefsTextField.text = currentPerson?.beliefs
        
    }
    
    @IBAction func savePersonButtonTapped() {
        
        var person = Person()
        person.firstName = firstNameTextField.text
        person.lastName = lastnameTextField.text
        person.address1 = addressOneTextField.text
        person.address2 = addressTwoTextField.text
        person.city = cityTextField.text
        person.state = stateTextField.text
        person.zipcode = zipcodeTextField.text
        person.relation = relationTextField.text
        person.holidayIcon = currentPerson?.holidayIcon ?? peopleManager.getRandomIcon()
        person.beliefs = beliefsTextField.text
        
        if editingPerson {
            peopleManager.updatePerson(editedPerson: person)
        } else {
            peopleManager.addPerson(person: person)
        }
        
        //self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePersonButtonTapped() {
        if currentPerson != nil {
            peopleManager.deletePerson(person: currentPerson!)
            // this removes ALL viewcontrollers on the stack and go back to the ROOT viewcontroller
            //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            var nav = self.navigationController
            nav?.popToRootViewController(animated: true)
        } else {
            //self.presentingViewController?.dismiss(animated: true, completion: nil)
            var nav = self.navigationController
            nav?.popViewController(animated: true)
        }
    }
    

    func setupFields(fields: [UITextField]) {
        for field in fields {
            field.layer.borderColor = UIColor(red: 41.0 / 255, green: 129.0 / 255, blue: 47.0 / 255, alpha: 1.0).cgColor
            field.layer.borderWidth = 2
            field.layer.cornerRadius = 6
        }
    }
    func setupButtons(buttons: [UIButton]) {
        for button in buttons {
            button.layer.borderColor = UIColor(red: 41.0 / 255, green: 129.0 / 255, blue: 47.0 / 255, alpha: 1.0).cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 4
        }
    }

}

    

extension AddEditPersonViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == stateTextField{
            if textField.text!.count >= 2 {
                return false
            }
        }
        if textField == zipcodeTextField {
            if textField.text!.count >= 5 {
                return false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == zipcodeTextField || textField == stateTextField {
            textField.text = ""
        }
        
    }
    
}
//MARK: Extension for PickerView
extension AddEditPersonViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        beliefsTextField.text = beliefs[row]
        beliefsTextField.resignFirstResponder()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return beliefs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return beliefs[row]
    }
    
}

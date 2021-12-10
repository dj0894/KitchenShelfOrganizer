//
//  AddItemToServerDB.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 09/12/21.
//

import UIKit
import Realm
import FirebaseAuth
import Firebase


class AddItemToServerDB: UIViewController {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var pageHeadingLbl: UILabel!
    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var expiryDateTF: UITextField!
    @IBOutlet weak var purchaseDateTF: UITextField!
    @IBOutlet weak var addItemBtn: UIButton!
    var arrItemInfo:[ItemInfo] = [ItemInfo]()
    
    let datePicker=UIDatePicker();
    var isItemAddedToDBFlag=false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        createExpiryDatePicker() //create a datePicker
        createPurchaseDatePicker()
    }
    
    func setUpElements(){
        statusLbl.alpha=0;
        Utilities.stylePageHeadlingLbl(lbl: pageHeadingLbl)
        Utilities.styleTextField(itemNameTF)
        Utilities.styleTextField(expiryDateTF)
        Utilities.styleTextField(purchaseDateTF)
        Utilities.setRoundedBorderButton(btn: addItemBtn)
    }
    
    @IBAction func addItemToServerDB(_ sender: UIButton) {
        let error = validateUserInput()
        if error != nil {
            Utilities.styleStatusLabelForError(lbl: statusLbl, error: error!)
        }
        
        //add data to server
        let itemName = itemNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let expiryDate = expiryDateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let purchaseDate = purchaseDateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let currentUserId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        db.collection("itemList").document(currentUserId!).collection("items").addDocument(data:[
                "itemName":itemName,
                "expiryDate":expiryDate,
                "purchaseDate":purchaseDate,
                "itemId": UUID().uuidString
        ]){(err) in
                if let err = err {
                    Utilities.styleStatusLabelForError(lbl: self.statusLbl, error:"\(err.localizedDescription)")
                } else {
                    Utilities.styleStatusLabelForSuccess(lbl: self.statusLbl, successMsg: "Item added successfully")
                    self.updateArrItemInfo(itemName: itemName!,expiryDate: expiryDate!,purchaseDate: purchaseDate!)
                    self.transitionToTableViewServerDBDataVC()
                }
        }
 
    }
        
    func updateArrItemInfo(itemName:String,expiryDate:String,purchaseDate:String){
        let itemInfo = ItemInfo()
        itemInfo.itemName = itemName
        itemInfo.expiryDate = expiryDate
        itemInfo.purchaseDate = purchaseDate
        arrItemInfo.append(itemInfo)
    }
    
    func transitionToTableViewServerDBDataVC(){
        guard let tableViewServerDataVC=storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tableViewServerDataVC) as? TableViewServerDBData else { return }
        tableViewServerDataVC.arrItemInfo = arrItemInfo
        self.navigationController?.pushViewController(tableViewServerDataVC, animated: true)
    }
    
    func validateUserInput()->String?{
        //TODo code for validate userInput
        let itemName=itemNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let expiryDate=expiryDateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let purchaseDate=purchaseDateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if itemName=="" || expiryDate==""||purchaseDate==""{
            return "One or more field is empty"
        }
        return nil
    }
    
    func createExpiryDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        //toolbar to add doneBtn
        let toolbar=UIToolbar();
        toolbar.sizeToFit()
        let doneBtn=UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnPressed))
        toolbar.setItems([doneBtn], animated: true)
        expiryDateTF.inputAccessoryView=toolbar
        expiryDateTF.inputView=datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func doneBtnPressed(){
        let dateFormatter=DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        //set value of expiryDateTF to choosen date
        expiryDateTF.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    func createPurchaseDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        //toolbar to add doneBtn
        let toolbar=UIToolbar();
        toolbar.sizeToFit()
        let doneBtn=UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(purchaseDoneBtnPressed))
        toolbar.setItems([doneBtn], animated: true)
        purchaseDateTF.inputAccessoryView=toolbar
        purchaseDateTF.inputView=datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func purchaseDoneBtnPressed(){
        let dateFormatter=DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        //set value of expiryDateTF to choosen date
        purchaseDateTF.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
  
}
    
    


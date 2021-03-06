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
import SwiftSpinner


class AddItemToServerDB: UIViewController {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var pageHeadingLbl: UILabel!
    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var expiryDateTF: UITextField!
    @IBOutlet weak var purchaseDateTF: UITextField!
    @IBOutlet weak var addItemBtn: UIButton!
    
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    var arrItemInfo:[ItemInfo] = [ItemInfo]()
    
    let datePicker=UIDatePicker();
    var isItemAddedToDBFlag=false;
    var itemId: String = ""
    
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
        let itemName = itemNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let expiryDate = expiryDateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let purchaseDate = purchaseDateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let itemId = UUID().uuidString
        let currentUserId = Auth.auth().currentUser?.uid
        
        let db = Firestore.firestore()
        db.collection("itemList").document(currentUserId!).collection("items").document(itemId).setData([
            "itemId":itemId,
            "itemName":itemName,
            "expiryDate":expiryDate,
            "purchaseDate":purchaseDate
        ]){(err) in
                if let err = err {
                    Utilities.styleStatusLabelForError(lbl: self.statusLbl, error:"\(err.localizedDescription)")
                } else {
                    self.statusLbl.alpha = 1
                    Utilities.styleStatusLabelForSuccess(lbl: self.statusLbl, successMsg: "Item added successfully")
                    self.updateArrItemInfo(itemId:itemId,itemName: itemName!,expiryDate: expiryDate!,purchaseDate: purchaseDate!)
                    self.clearFeilds()
                    self.transitionToTableViewServerDBDataVC()
                }
        }
    }
    
    func updateArrItemInfo(itemId: String,itemName:String,expiryDate:String,purchaseDate:String){
        let itemInfo = ItemInfo()
        itemInfo.id = itemId
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
    
    
    @IBAction func logoutBtnClick(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
      do {
        try firebaseAuth.signOut()
      } catch let signOutError as NSError {
        print("Error signing out: %@", signOutError)
      }
        self.transitionToLoginScreen()
    }
    
    func transitionToLoginScreen(){
        guard let loginScreenVC=storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginScreenVC) as? LoginViewController else { return}
        self.navigationController?.pushViewController(loginScreenVC, animated: true)
        
    }
    
    func  clearFeilds(){
        itemNameTF.text=""
        expiryDateTF.text=""
        purchaseDateTF.text=""
        statusLbl.text=""
        statusLbl.alpha=0
    }
    
}
    
    


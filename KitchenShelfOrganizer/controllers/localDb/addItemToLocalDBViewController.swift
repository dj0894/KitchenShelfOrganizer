//
//  AddItemViewController.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 06/12/21.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

class addItemToLocalDBViewController: UIViewController {
    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var expiryDateTF: UITextField!
    @IBOutlet weak var purchasedDateTF: UITextField!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var pageHeadingLbl: UILabel!
    @IBOutlet weak var addItemToLocalDB: UIButton!
    let datePicker=UIDatePicker();
    var arrItemInfo:[ItemInfo] = [ItemInfo]()
    var isItemAddedToDBFlag=false;

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        createExpiryDatePicker() //create a datePicker
        createPurchaseDatePicker()
    }
    
    func setUpElements(){
        statusLbl.alpha=0
        Utilities.stylePageHeadlingLbl(lbl: pageHeadingLbl)
        Utilities.styleTextField(itemNameTF)
        Utilities.styleTextField(expiryDateTF)
        Utilities.styleTextField(purchasedDateTF)
        Utilities.setRoundedBorderButton(btn: addItemToLocalDB)
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        if itemNameTF.text == nil || expiryDateTF.text == nil || purchasedDateTF.text == nil{
            statusLbl.alpha = 1
            Utilities.styleStatusLabelForError(lbl: statusLbl, error:"One or more value is empty")
           return
        }
        if (itemNameTF.text == ""){
            statusLbl.alpha = 1
            Utilities.styleStatusLabelForError(lbl: statusLbl, error: "Item name is empty")
            return
        }
        
        guard let itemNameValue=itemNameTF.text else { return}
        guard let expiryDateValue=expiryDateTF.text else { return }
        guard let purchaseDateValue=purchasedDateTF.text  else { return}
        let itemInfo=ItemInfo()
        itemInfo.id=UUID().uuidString
        itemInfo.itemName=itemNameValue
        if(expiryDateValue==""){
            itemInfo.expiryDate = "NA"
        }else{
            itemInfo.expiryDate=expiryDateValue
        }
        
        if(purchaseDateValue==""){
            itemInfo.purchaseDate = "NA"
        }else{
            itemInfo.purchaseDate=purchaseDateValue
        }
        
        //Add ItemInfo in RealmDB
        addItemToDB(itemInfo)
        //fetch all items from DB and update the array to display it in tableView
        getAllItemsFromDB()
        itemNameTF.text=""
        expiryDateTF.text=""
        purchasedDateTF.text=""
        statusLbl.text=""
        if(isItemAddedToDBFlag){
            guard let tableViewLocalDBVC=storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tableViewLocalDBVC) as? TableViewLocalDBVC else { return }
            self.navigationController?.pushViewController(tableViewLocalDBVC, animated: true)
        }
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
        purchasedDateTF.inputAccessoryView=toolbar
        purchasedDateTF.inputView=datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func purchaseDoneBtnPressed(){
        let dateFormatter=DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        //set value of expiryDateTF to choosen date
        purchasedDateTF.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func addItemToDB(_ itemInfo:ItemInfo){
        print(Realm.Configuration.defaultConfiguration.fileURL)
        do{
            let realm = try Realm()
            if(isStockAlreadyExist(itemInfo)){
                Utilities.styleStatusLabelForError(lbl: statusLbl, error: "Error: Item already exist in DB")
                return
            }
            try realm.write{
                realm.add(itemInfo,update: .modified)
                Utilities.styleStatusLabelForSuccess(lbl: statusLbl, successMsg: "Item successfully added in Database.")
                isItemAddedToDBFlag=true;
                return
            }
        }catch{
            Utilities.styleStatusLabelForError(lbl: statusLbl, error:"Error in adding values to Database: \(error.localizedDescription)")
            return
        }
    }

    func isStockAlreadyExist(_ itemInfo:ItemInfo) -> Bool{
        do {
            let realm=try Realm()
            if(realm.object(ofType: ItemInfo.self, forPrimaryKey:itemInfo.id) != nil){
                return true;
            }
        } catch{
            statusLbl.textColor=UIColor.red
            statusLbl.text="Error in getting value\(error)"
        }
        return false;
    }
    
    func getAllItemsFromDB(){
        do {
            let realm = try Realm()
            let items=realm.objects(ItemInfo.self)
            arrItemInfo.removeAll()
            for i in 0...items.count-1{
                arrItemInfo.append(items[i])
            }
        } catch{
            Utilities.styleStatusLabelForError(lbl: statusLbl, error: error.localizedDescription)
        }
    }
}

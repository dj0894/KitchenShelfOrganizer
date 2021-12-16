//
//  TableViewServerDBData.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 09/12/21.
//

import UIKit
import Realm
import FirebaseAuth
import Firebase
import SwiftSpinner

class TableViewServerDBData: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var pageHeadingLbl: UILabel!
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    @IBOutlet weak var displayServerDataTblView: UITableView!
    @IBOutlet weak var sortByBtn: UIButton!
    @IBOutlet weak var sortStackView: UIStackView!
    @IBOutlet weak var sortByItemNameBtn: UIButton!
    @IBOutlet weak var sortByPurchaseDateBTn: UIButton!
    @IBOutlet weak var sortByExpiryDateBtn: UIButton!
    let datePicker=UIDatePicker();
    var arrItemInfo:[ItemInfo] = [ItemInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayServerDataTblView.delegate=self
        displayServerDataTblView.dataSource=self
        fetchDataFromServer()
        setUpElements()
    }
  
    func setUpElements(){
        Utilities.stylePageHeadlingLbl(lbl: pageHeadingLbl)
        Utilities.styleSortingStackView(stackView: sortStackView)
        Utilities.styleSortingBtn(btn: sortByItemNameBtn)
        Utilities.styleSortingBtn(btn: sortByPurchaseDateBTn)
        Utilities.styleSortingBtn(btn: sortByExpiryDateBtn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItemInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell
    
        cell.itemNameLbl.text!="\(arrItemInfo[indexPath.row].itemName)"
        cell.expiryDateLbl.text!="\(arrItemInfo[indexPath.row].expiryDate)"
        cell.purchaseDateLbl.text!="\(arrItemInfo[indexPath.row].purchaseDate)"
        return cell
    }
    
    func fetchDataFromServer(){
        SwiftSpinner.show("Fetching Items from server")
        let currUserId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let docRef=db.collection("itemList").document(currUserId!)
        docRef.collection("items").getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                self.arrItemInfo.removeAll()
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let itemInfo=ItemInfo()
                    let docDetails = document.data()
                    itemInfo.itemName = docDetails["itemName"] as! String
                    itemInfo.expiryDate = docDetails["expiryDate"] as! String
                    itemInfo.purchaseDate = docDetails["purchaseDate"] as! String
                    self.arrItemInfo.append(itemInfo)
                }
                self.arrItemInfo = Utilities.sortArrayItemInfoByItemName(arr: self.arrItemInfo)
                self.displayServerDataTblView.reloadData()
                SwiftSpinner.hide(nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(arrItemInfo[indexPath.row])
            print(indexPath.row)
            removeFromServerDB(item: arrItemInfo[indexPath.row])
            arrItemInfo.remove(at: indexPath.row)
            displayServerDataTblView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func removeFromServerDB(item: ItemInfo){
        print(arrItemInfo)
        print(item.id)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBarBtnSegue" {
            let addItemToServerDBVC = segue.destination as! AddItemToServerDB
            print("Preparing segue")
        }
    }
    
    @IBAction func goToAddItemToServerDBVC(_ sender: Any) {
        performSegue(withIdentifier:"addBarBtnSegue",sender: self)
    }

    @IBAction func sortByItemNameBtnClick(_ sender: UIButton) {
        arrItemInfo=Utilities.sortArrayItemInfoByItemName(arr:arrItemInfo)
        displayServerDataTblView.reloadData()
    }
    
    @IBAction func sortByPurchaseDateBtnClick(_ sender: UIButton) {
        arrItemInfo=Utilities.sortArrayItemInfoByPurchaseDate(arr:arrItemInfo)
        displayServerDataTblView.reloadData()
    }
    @IBAction func sortByExpiryDateBtnClick(_ sender: UIButton) {
        arrItemInfo=Utilities.sortArrayItemInfoByExpiryDate(arr:arrItemInfo)
        displayServerDataTblView.reloadData()
    }
}

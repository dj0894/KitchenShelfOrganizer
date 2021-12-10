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


class TableViewServerDBData: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var pageHeadingLbl: UILabel!
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    @IBOutlet weak var displayServerDataTblView: UITableView!
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
        let currUserId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let docRef=db.collection("itemList").document(currUserId!)
        docRef.collection("items").getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
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
                print(self.arrItemInfo)
                self.displayServerDataTblView.reloadData()
            }
        }
        
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
}

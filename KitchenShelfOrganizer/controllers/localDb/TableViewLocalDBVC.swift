//
//  TableViewLocalDBVC.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 09/12/21.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

class TableViewLocalDBVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var displayItemsTblView: UITableView!
    
    @IBOutlet weak var sortingStackView: UIStackView!
    
    @IBOutlet weak var sortByItemNameBtn: UIButton!
    
    @IBOutlet weak var sortByPurchaseDateBtn: UIButton!
    
    @IBOutlet weak var sortByExpiryDateBtn: UIButton!
    
    
    @IBOutlet weak var pageHeadingLbl: UILabel!
    @IBOutlet weak var addItemBarBtn: UIBarButtonItem!
    
    
    
    
   
    let datePicker=UIDatePicker();
    var arrItemInfo:[ItemInfo] = [ItemInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayItemsTblView.delegate=self
        displayItemsTblView.dataSource=self
        loadItemsFromDB()
        setUpElements()
        
    }
    
    func setUpElements(){
        Utilities.stylePageHeadlingLbl(lbl: pageHeadingLbl)
        Utilities.styleSortingStackView(stackView: sortingStackView)
        Utilities.styleSortingBtn(btn: sortByItemNameBtn)
        Utilities.styleSortingBtn(btn: sortByExpiryDateBtn)
        Utilities.styleSortingBtn(btn: sortByPurchaseDateBtn)
        Utilities.styleUIBarBtn(barBtn: addItemBarBtn)
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
    

        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeItemFromDB(arrItemInfo[indexPath.row])
            arrItemInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addItemBarBtnAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addItemSegue", sender: self)
    }
    
    func loadItemsFromDB(){
        SwiftSpinner.show("Fetching item list from database", animated: true)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let realm = try! Realm()
        let itemsFromDB=realm.objects(ItemInfo.self)
        let itemsFromDBLen=itemsFromDB.count
        if(itemsFromDBLen==0){
            print("No data in database")
            return
        }
        
        arrItemInfo = [ItemInfo]()
        for i in 0...(itemsFromDBLen-1){
            arrItemInfo.append(itemsFromDB[i])
        }
        
        self.displayItemsTblView.reloadData()  //reload Data in table
        SwiftSpinner.hide(nil)
    }
    
    func removeItemFromDB(_ item : ItemInfo){
        if(!arrItemInfo.contains(item)){
            return
        }
        
        do{
            let realm=try! Realm()
            let object=realm.objects(ItemInfo.self)
            if(object.count==0){
                print("Database is Empty")
                return
            }
            try realm.write({
                realm.delete(item)
            })
        }catch{
            print("Error in deleting values from DB \(error)")
        }
    }
    
 
    @IBAction func sortByItemNameBtnClick(_ sender: UIButton) {
        arrItemInfo=Utilities.sortArrayItemInfoByItemName(arr:arrItemInfo)
        displayItemsTblView.reloadData()
    }
    
    @IBAction func sortByExpiryDateBtnClick(_ sender: UIButton) {
        arrItemInfo=Utilities.sortArrayItemInfoByExpiryDate(arr:arrItemInfo)
        displayItemsTblView.reloadData()
    }
    
    @IBAction func sortByPurchaseDateBtnClick(_ sender: UIButton) {
        arrItemInfo=Utilities.sortArrayItemInfoByPurchaseDate(arr:arrItemInfo)
        displayItemsTblView.reloadData()
    }
    

  
    
}

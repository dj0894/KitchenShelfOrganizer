//
//  ViewController.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 02/12/21.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var displayItemsTblView: UITableView!
    let datePicker=UIDatePicker();
    var arrItemInfo:[ItemInfo] = [ItemInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        displayItemsTblView.delegate=self
        displayItemsTblView.dataSource=self
       // checkForUpdatedDB()
        loadItemsFromDB()
        
    }
    
//    func checkForUpdatedDB(){
//        let realm=try! Realm()
//
//    }
    
//    @objc func refreshData(){
//        loadItemsFromDB()
//        self.refreshControl?.endRefreshing()
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItemInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=displayItemsTblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)?.first as! CustomTableViewCell
        
        cell.textLabel?.text=" \(arrItemInfo[indexPath.row].itemName)  "+"|"+"  \(arrItemInfo[indexPath.row].expiryDate)   "+"|"+"   \(arrItemInfo[indexPath.row].purchaseDate) "
        
        //To Do check why customTable cell is not working
//        cell.itemNameLbl.text!="\(arr1[indexPath.row].itemName!)"
//        cell.expiryDateLbl.text!="\(arr1[indexPath.row].expiryDate!)"
//        cell.purchaseDateLbl.text!="\(arr1[indexPath.row].purchaseDate!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Item Details"
    }
    
    @IBAction func addItemBarBtnAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addItemSegue", sender: self)
    }
    
    func loadItemsFromDB(){
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
        
        print(arrItemInfo)
        //reload Data in table
        self.displayItemsTblView.reloadData()
    }
    
    
     
}


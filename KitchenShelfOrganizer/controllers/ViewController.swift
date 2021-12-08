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

        let cell=Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell

        cell.itemNameLbl.text!="\(arrItemInfo[indexPath.row].itemName)"
        cell.expiryDateLbl.text!="\(arrItemInfo[indexPath.row].expiryDate)"
        cell.purchaseDateLbl.text!="\(arrItemInfo[indexPath.row].purchaseDate)"
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Item Name             Expiry Date            PurchaseDate"
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = " Item Details"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .red
        label.backgroundColor=UIColor.yellow
        
        headerView.addSubview(label)
        
        return headerView
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
     
}


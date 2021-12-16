//
//  DashboardViewController.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 16/12/21.
//

import UIKit
import Realm
import FirebaseAuth
import Firebase
import SwiftSpinner

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var displayUpcomingExpiryDateTblView: UITableView!
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var checkAllItemsBtn: UIButton!
    @IBOutlet weak var pageHeadingLbl: UILabel!
    var itemInfoArr:[ItemInfo] = [ItemInfo]()
    var formattedItemInfoArr:[ItemInfoDashboard] = [ItemInfoDashboard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayUpcomingExpiryDateTblView.delegate=self
        displayUpcomingExpiryDateTblView.dataSource=self
        setUpElements()
        fetchDataFromServer()
        displayUpcomingExpiryDateTblView.reloadData()
        refreshData()
    }
    
    func refreshData(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        displayUpcomingExpiryDateTblView.addSubview(refreshControl)
    }
    @objc func refresh(_ sender: AnyObject) {
        formattedItemInfoArr.removeAll()
        fetchDataFromServer()
        displayUpcomingExpiryDateTblView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    func setUpElements(){
        Utilities.styleTableView(tblView: displayUpcomingExpiryDateTblView)
        Utilities.stylePageHeadlingLbl(lbl: pageHeadingLbl)
        Utilities.setRoundedBorderButton(btn: checkAllItemsBtn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formattedItemInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=Bundle.main.loadNibNamed("dashboardCustomTableViewCell", owner: self, options: nil)?.first as! dashboardCustomTableViewCell
        cell.itemNameLbl.text!="\(formattedItemInfoArr[indexPath.row].itemName)"
        cell.noOfDaysToExpire.text!="Expiring in \(formattedItemInfoArr[indexPath.row].noOfdaysToExpire) days"
        return cell
    }
    
    func fetchDataFromServer(){
        SwiftSpinner.show("Fetching Items from server")
        let currUserId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let docRef = db.collection("itemList").document(currUserId!)
        docRef.collection("items").getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
 
                self.itemInfoArr.removeAll()
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let itemInfo=ItemInfo()
                    let docDetails = document.data()
                    itemInfo.id = docDetails["itemId"] as! String
                    itemInfo.itemName = docDetails["itemName"] as! String
                    itemInfo.expiryDate = docDetails["expiryDate"] as! String
                    itemInfo.purchaseDate = docDetails["purchaseDate"] as! String
                    self.itemInfoArr.append(itemInfo)
                }
                self.formatDataToFillTableView(self.itemInfoArr)
                self.displayUpcomingExpiryDateTblView.reloadData()
                SwiftSpinner.hide(nil)
            }
        }
    }
    
    func formatDataToFillTableView(_ itemInfoArr: [ItemInfo]){
        let dateFormatterUK = DateFormatter()
        dateFormatterUK.dateFormat = "MMM-dd-yyyy"
        for item in self.itemInfoArr {
            let id = item.id
            let itemName = item.itemName
            let expiryDate = item.expiryDate
            let convertedExpiryDate = dateFormatterUK.date(from: expiryDate)!
            let currDate = Date()
            let noOfdays = Calendar.current.dateComponents([.day], from: currDate, to: convertedExpiryDate)
            //print("Number of days: \(noOfdays.day!)")
            let formattedItemInfo = ItemInfoDashboard()
            formattedItemInfo.id = id
            formattedItemInfo.itemName = itemName
            formattedItemInfo.expiryDate = expiryDate
            formattedItemInfo.noOfdaysToExpire = noOfdays.day!
            formattedItemInfoArr.append(formattedItemInfo)
            
        }
        
         formattedItemInfoArr = Utilities.sortArrayByNoOfDaysToExpire(arr: formattedItemInfoArr)
        
        print(formattedItemInfoArr)
    }
    
    
    func  transitionToTableViewServerDBDataVC(){
        guard let tableViewServerDataVC=storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tableViewServerDataVC) as? TableViewServerDBData else { return }
        self.navigationController?.pushViewController(tableViewServerDataVC, animated: true)

    }
    
    
    @IBAction func checkAllItemsBtnClick(_ sender: UIButton) {
        transitionToTableViewServerDBDataVC()
        
    }
    
}

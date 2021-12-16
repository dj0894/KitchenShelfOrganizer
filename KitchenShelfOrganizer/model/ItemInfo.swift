//
//  ItemInfo.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 05/12/21.
//

import Foundation
import RealmSwift

class ItemInfo: Object{
    @objc dynamic var id:String=""
    @objc dynamic var itemName:String=""
    @objc dynamic var expiryDate:String=""
    @objc dynamic var purchaseDate:String=""
    

    override init() {
            super.init()
    }
    init(itemName:String,expiryDate:String,purchaseDate:String){
        self.itemName=itemName
        self.expiryDate=expiryDate
        self.purchaseDate=purchaseDate
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
  
   
}

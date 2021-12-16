//
//  ItemInfoDashboard.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 16/12/21.
//

import Foundation
import RealmSwift

class ItemInfoDashboard: Object{
    @objc dynamic var id:String=""
    @objc dynamic var itemName:String="Apple"
    @objc dynamic var expiryDate:String=""
    @objc dynamic var noOfdaysToExpire:Int=0
    

    override init() {
            super.init()
    }
    init(itemName:String,expiryDate:String,noOfdaysToExpire:Int){
        self.itemName=itemName
        self.expiryDate=expiryDate
        self.noOfdaysToExpire=noOfdaysToExpire
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }

}


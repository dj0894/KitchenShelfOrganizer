//
//  Utilities.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 08/12/21.
//

import Foundation
import UIKit
import SwiftUI
class Utilities{
    
    static func styleTextField(_ tf: UITextField){
        tf.textAlignment = .center
        tf.layer.cornerRadius = 5
        tf.clipsToBounds = true
        tf.textColor = .black
        tf.frame.size.height=50
      
        NSLayoutConstraint.init(item: tf, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        

    }
    
    static func styleVCPageHeading(_ lbl:UILabel){
        lbl.center = CGPoint(x: 160, y: 285)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.red
    }
    
    static func setRoundedBorderButton(btn:UIButton){
        let defaultColor = UIColor(red: 100/255, green: 130/255, blue: 230/255, alpha: 1).cgColor
//        let selectedColor = UIColor(red: 251/255, green: 186/255, blue: 8/255, alpha: 1).cgColor
        btn.layer.cornerRadius = btn.frame.size.height/2
        btn.layer.borderWidth = 0.5
        btn.layer.backgroundColor = UIColor.systemGreen.cgColor
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        btn.setTitleColor(.black, for: .normal)
        
    }
    
    static func stylePageHeadlingLbl(lbl:UILabel){
        lbl.frame.size.height = 50
        lbl.textAlignment = .center
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
    }
    
    static func styleStatusLabelForError(lbl:UILabel,error: String){
        lbl.textColor = .red
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.text = error
        lbl.alpha=1
    }
    
    static func styleStatusLabelForSuccess(lbl:UILabel,successMsg: String){
        lbl.textColor = .green
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.text = successMsg
        lbl.alpha=1
    }
    
    static func styleSortingBtn(btn:UIButton){
        let defaultColor = UIColor(red: 100/255, green: 130/255, blue: 230/255, alpha: 1)
        btn.frame.size.height = 20
        btn.layer.cornerRadius = btn.frame.size.height/3
        btn.setTitleColor(.black, for: .normal)
    }
    
    static func styleSortingStackView(stackView: UIStackView){
        stackView.frame.size.height = 40
        stackView.frame.size.width = 380
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.contentMode = .left
        stackView.backgroundColor = .systemPink
        
    }
    
    static func styleTableView(tblView: UITableView){
        tblView.translatesAutoresizingMaskIntoConstraints = true
        tblView.rowHeight = 50

    }
    
    
    static func styleUIBarBtn(barBtn: UIBarButtonItem){
        
    }

    
    static func addDelay(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {}
    }
    
    static func isValidPassword(_ password:String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
    }
    
    static func isValidEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    //validate input and returns nil if everything is fine else return error msg.
    static func validateInput(email:String, password: String)->String?{
       
        if email == nil || password == nil {
            return "Invalid email or password"
        }
        if email == "" || password == "" {
            return "One or more field is empty"
        }
        if  Utilities.isValidEmail(email) == false {
            return "Invalid email"
        }
        if Utilities.isValidPassword(password) == false{
            return "Invalid password"
        }
        return nil
    }
    
    
    
    
}


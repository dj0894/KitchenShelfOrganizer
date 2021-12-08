//
//  SignUpViewController.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 07/12/21.
//

import UIKit
import FirebaseAuth
import Firebase
import RealmSwift

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
   
    
    func setUpElements(){
        statusLbl.alpha=0
    }
    
    func isValidPassword(password:String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
    
    func isValidEmail(email:String) -> Bool {
        print("validate emilId: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    //validate input and returns nil if everything is fine else return error msg.
    func validateInput()->String?{
        if firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return " One or more fields is empty."
        }
        let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(email: email) == false {
            return "Please enter correct email."
        }
        
        let password=passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isValidPassword(password: password) == false {
            return "Password is incorrect."
        }
        
        return nil
    }
    
   
    
    @IBAction func signupBtnClick(_ sender: UIButton) {
        //validate the feilds
        
        let error = validateInput()
        
        if error != nil {
            showStatus(error!)
        }else{
            let firstName = firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            //create the user and transition to home screeen
            Auth.auth().createUser(withEmail:email!, password: password!) { (result, err) in
                if err != nil {
                    self.showStatus("Error in creating user or User already exist")
                }else {
                    //user created successfully store the firstname and last name
                    let db=Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName" : firstName,"lastName":lastName,"uid":result!.user.uid]){(error) in
                        if error != nil {
                            self.showStatus("Error in saving user data. first name and last name not stored in db")
                        }
                    }
                    self.showStatus("User's signed up successfully. Proceed to login screen to login")
                    //self.clearFeilds()
                   // self.transitionToFirstScreen()
                    
                }
            }
        }
       
        
        
    }
    
    func clearFeilds(){
        firstNameTF.text = ""
        lastNameTF.text=""
        emailTF.text=""
        passwordTF.text=""
    }
    
    func  transitionToFirstScreen(){

        
    }
    
    func showStatus(_ error : String){
        statusLbl.text = error
        statusLbl.alpha=1
    }
    
   
    

}

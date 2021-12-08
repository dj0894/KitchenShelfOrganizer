//
//  LoginViewController.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 07/12/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements() // for setting up initial values
    }
    
    func setUpElements(){
        statusLbl.alpha=0
        //ToDo: Import code for styling the UI componnents
        
    }
    
    func isValidPassword(_ password:String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
    }
    
    func isValidEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    //validate input and returns nil if everything is fine else return error msg.
    func validateInput()->String?{
        let email=emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password=passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email == nil || password == nil {
            return "Invalid email or password"
        }
        
        if email == "" || password == "" {
            return "One or more field is empty"
        }
        
        if  isValidEmail(email!) == false {
            return "Invalid email"
        }
        
        if isValidPassword(password!) == false{
            return "Invalid password"
        }
        
        return nil
    }
    
    func showError(_ error : String){
        statusLbl.text = error
        statusLbl.alpha=1
    }
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        //validate the textFields
        //SignIn User
        let err = validateInput()
        if err != nil {
            showError(err!)
            return
        } else {
            let email=emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password=passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
                if error != nil {
                    self.statusLbl.text=error!.localizedDescription
                    self.statusLbl.alpha=1
                }else{
                    self.transitionToHomeScreen()
                }
            }
        }
    }
    
    //home screen VC is ViewController
    func  transitionToHomeScreen(){
        guard let homeViewController=storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? ViewController else { return }
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
}

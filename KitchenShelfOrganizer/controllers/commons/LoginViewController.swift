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
    @IBOutlet weak var pageHeadingLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements() // for setting up initial values
    }
    
    func setUpElements(){
        statusLbl.alpha=0
        passwordTF.isSecureTextEntry = true
        Utilities.stylePageHeadlingLbl(lbl: pageHeadingLbl)
        Utilities.setRoundedBorderButton(btn: loginBtn)
        
    
    }
 
    func showError(_ error : String){
        statusLbl.text = error
        statusLbl.alpha=1
    }
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        //validate the textFields
        //SignIn User
        guard let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return }
        guard let password=passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        let err = Utilities.validateInput(email: email,password: password)
        if err != nil {
            Utilities.styleStatusLabelForError(lbl: statusLbl, error: err!)
            return
        } else {
            let email=emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password=passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
                if error != nil {
                    Utilities.styleStatusLabelForError(lbl: self.statusLbl, error: error!.localizedDescription)
                    return
                }else{
                    self.clearFields()
                    self.transitionToTableViewServerDBDataVC()
                   
                }
            }
        }
    }
    
    
    func  transitionToTableViewServerDBDataVC(){
        guard let tableViewServerDataVC=storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tableViewServerDataVC) as? TableViewServerDBData else { return }
        self.navigationController?.pushViewController(tableViewServerDataVC, animated: true)

    }
    
    func clearFields(){
        emailTF.text = ""
        passwordTF.text = ""
    }
}

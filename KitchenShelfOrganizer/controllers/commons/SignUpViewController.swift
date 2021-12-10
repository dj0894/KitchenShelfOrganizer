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
    
    @IBOutlet weak var signUpPageHeadingLbl: UILabel!
    
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var statusLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    func setUpElements(){
        statusLbl.alpha=0
        Utilities.styleTextField(firstNameTF)
        Utilities.styleTextField(lastNameTF)
        Utilities.styleTextField(emailTF)
        Utilities.styleTextField(passwordTF)
        Utilities.setRoundedBorderButton(btn: signUpBtn)
        Utilities.stylePageHeadlingLbl(lbl: signUpPageHeadingLbl)
    }
    
    @IBAction func signupBtnClick(_ sender: UIButton) {
        guard let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return }
        guard let password=passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        //validate the feilds
        let error = Utilities.validateInput(email:email, password: password)
        if error != nil {
            Utilities.styleStatusLabelForError(lbl: statusLbl,error: error!)
        }else{
            let firstName = firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            //create the user and transition to home screeen
            Auth.auth().createUser(withEmail:email!, password: password!) { (result, err) in
                if err != nil {
                    Utilities.styleStatusLabelForError(lbl: self.statusLbl, error: err!.localizedDescription)
                }else {
                    //user created successfully store the firstname and last name
                    let db=Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName" : firstName,"lastName":lastName,"uid":result!.user.uid]){(error) in
                        if error != nil {
                            Utilities.styleStatusLabelForError(lbl: self.statusLbl,error: error!.localizedDescription)
                        }
                    }
                    let successMessage="User's signed up successfully. Proceed to login Page."
                    Utilities.styleStatusLabelForSuccess(lbl: self.statusLbl, successMsg: successMessage)
                    Utilities.addDelay()
                    self.clearFeilds()
                    //self.transitionToFirstScreen() //Todo: Not working fix it
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
    
    func transitionToFirstScreen(){
        print("Inside Screen transition toFirst SCreen VC")
        guard let firstScreenVC=storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.firstScreenVC) as? FirstScreenViewController else { return}
        self.navigationController?.pushViewController(firstScreenVC, animated: true)
        
    }
  
}

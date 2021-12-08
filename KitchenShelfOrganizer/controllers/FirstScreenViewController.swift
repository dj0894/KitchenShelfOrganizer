//
//  FirstScreenViewController.swift
//  KitchenShelfOrganizer
//
//  Created by Deepika Jha on 07/12/21.
//

import UIKit
import Firebase

class FirstScreenViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpElements() function to write styling for UI elements
        FirebaseApp.configure()
        
    }

    
    @IBAction func loginBtnClick(_ sender: UIButton) {
    }
    
    @IBAction func signUpBtnClick(_ sender: UIButton) {
    }
}

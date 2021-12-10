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
    @IBOutlet weak var loginAnonymouslyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpElements()
        FirebaseApp.configure()
        let backgroundImage = UIImage.init(named: "KitchenShelf.jpeg")
        let backgroundImageView = UIImageView.init(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.3
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    func setUpElements(){
        //Utilities.styleFirstScreenBackgroundImage()
        Utilities.setRoundedBorderButton(btn: loginBtn)
        Utilities.setRoundedBorderButton(btn: signUpBtn)
        Utilities.setRoundedBorderButton(btn: loginAnonymouslyBtn)
        
    }

    
    @IBAction func loginBtnClick(_ sender: UIButton) {
    }
    
    @IBAction func signUpBtnClick(_ sender: UIButton) {
    }
    
    
    @IBAction func loginAnonymouslyBtnClick(_ sender: UIButton) {
        guard let tableViewLocalDBVC=storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tableViewLocalDBVC) as? TableViewLocalDBVC
        else { return }
        self.navigationController?.pushViewController(tableViewLocalDBVC, animated: true)
        
    }
}

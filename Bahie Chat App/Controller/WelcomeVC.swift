//
//  WelcomeVC.swift
//  Bahie Chat App
//
//  Created by tarek bahie on 2/17/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeVC: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "toChat", sender: self)
            
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func registerBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toCreate", sender: self)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    @IBAction func prepareForUnwind(segue : UIStoryboardSegue){}
}

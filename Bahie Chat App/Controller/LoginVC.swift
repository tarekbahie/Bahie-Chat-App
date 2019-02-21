//
//  LoginVC.swift
//  Bahie Chat App
//
//  Created by tarek bahie on 2/17/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    @objc func handleTap() {
        view.endEditing(true)
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show()
        AuthService.instance.loginUser(withEmail: emailLbl.text!, withPassword: self.passwordLbl.text!, loginComplete: { (success, error) in
            if success {
                print("login successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "toChat", sender: self)
            } else {
                print("Login failed")
            }
        })
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

//
//  ViewController.swift
//  Bahie Chat App
//
//  Created by tarek bahie on 2/17/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class RegisterVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var usernameLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.handleTap))
        view.addGestureRecognizer(tap)
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.handlePhotoTap))
        profileImg.addGestureRecognizer(photoTap)
        profileImg.isUserInteractionEnabled = true
    }
    @objc func handleTap() {
        view.endEditing(true)
    }
    @objc func handlePhotoTap() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            self.profileImg.image = image
            self.selectedImage = image
            self.profileImg.contentMode = .scaleAspectFill
            
                   dismiss(animated: true, completion: nil)
                }
            }
    @IBAction func createBtnPressed(_ sender: Any) {
        if usernameLbl.text != "" && passwordLbl.text != "" {
            AuthService.instance.createUser(name: usernameLbl.text!, pass: passwordLbl.text!) { (success, error) in
                if success {
                    let storageRef = Storage.storage().reference(forURL: "gs://bahie-s-chat.appspot.com").child("profileImg").child((Auth.auth().currentUser?.uid)!)
                    if let profileImage = self.selectedImage, let imgData = profileImage.jpegData(compressionQuality: 0.1) {
                        storageRef.putData(imgData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                    return
                            }
                            storageRef.downloadURL(completion: { (URL, error) in
                                guard let profileImgURL = URL?.absoluteString else {return}
                                self.ref.child("users/\((Auth.auth().currentUser?.uid)!)/Profile-Image").setValue(profileImgURL)
                            })
                            
                            
                        })
                    }
                    
                    
                    
                    AuthService.instance.loginUser(withEmail: self.usernameLbl.text!, withPassword: self.passwordLbl.text!, loginComplete: { (success, error) in
                        if success {
                        print("login successful")
                            self.performSegue(withIdentifier: "toHome", sender: self)
                        } else {
                            print("Login failed")
                        }
                    })
                }
            }
        }
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


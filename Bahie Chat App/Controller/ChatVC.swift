//
//  ChatVC.swift
//  Bahie Chat App
//
//  Created by tarek bahie on 2/17/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

var ref: DatabaseReference! = Database.database().reference()
var storageRef : StorageReference! = Storage.storage().reference(forURL: "gs://bahie-s-chat.appspot.com")

class ChatVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userIDLbl: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            self.usernameLbl.text = Auth.auth().currentUser?.email
            self.userIDLbl.text = Auth.auth().currentUser?.uid
            let userID = Auth.auth().currentUser?.uid
            let imageRef = storageRef.child("profileImg").child(userID!)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print(error)
                    return
                } else {
                    let image = UIImage(data: data!)
                    self.userImage.image = image
                }
            }
        }
}
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

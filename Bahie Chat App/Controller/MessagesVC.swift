//
//  MessagesVC.swift
//  Bahie Chat App
//
//  Created by tarek bahie on 2/19/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class MessagesVC: UIViewController {
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTxtField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageView: UIView!
    
    var messagesArray = [Message]()
    var label: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
       view.bindToKeyboard()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        onLoginGetMessages()
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    @objc func handleTap() {
        view.endEditing(true)
    }
    func onLoginGetMessages() {
        DataService.instance.retrieveMessages { (returnedMessageArray) in
            self.messagesArray = returnedMessageArray
            self.messageTableView.reloadData()
            if self.messagesArray.count > 0 {
                let endIndex = IndexPath(row: (self.messagesArray.count) - 1, section: 0)
                self.messageTableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
            }
            
        }
    }
    @IBAction func sendBtnPressed(_ sender: Any) {
        if messageTxtField.text != "" && Auth.auth().currentUser != nil {
            messageTxtField.isEnabled = false
            sendBtn.isEnabled = false
            let userID = Auth.auth().currentUser?.uid
            let imageRef = storageRef.child("profileImg").child(userID!)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print(error)
                    return
                } else {
                    DataService.instance.createMessage(withContent: self.messageTxtField.text!, andUserID: userID!)
                    self.messageTxtField.text = ""
                    self.messageTxtField.isEnabled = true
                    self.sendBtn.isEnabled = true
                    
                }
            }
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            addCustomView(text: "success")
            
            
        } catch {
            print(error)
            addCustomView(text: "error")
        }
    }
    
    func addCustomView(text : String) {
        let height = 50
        let width = 200
        label.frame = CGRect(x: (view.frame.width / 2) - CGFloat(width / 2), y: (view.frame.height / 2) - CGFloat(height / 2), width: CGFloat(width), height: CGFloat(height))
        label.backgroundColor = #colorLiteral(red: 0.1565752923, green: 0.180654496, blue: 0.2063922584, alpha: 0.6799550514)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = NSTextAlignment.center
        if text == "success"{
            label.text = "sign-out successful"
            view.addSubview(label)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.label.removeFromSuperview()
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            label.text = "sign-out unsuccessful"
            view.addSubview(label)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.label.removeFromSuperview()
            }
        }
        
    }
        
    }
extension MessagesVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        cell.configureCell(image: messagesArray[indexPath.row].senderImage, content: messagesArray[indexPath.row].messageBody)
        return cell
    }
}

import Foundation
import Alamofire
import SwiftyJSON
import FirebaseAuth
import Firebase
import FirebaseStorage

let ST_BASE = Storage.storage().reference(forURL: "gs://bahie-s-chat.appspot.com")

class DataService {
    public static let instance = DataService()
    
    var messageArray = [Message]()

    func createMessage(withContent content : String, andUserID ID: String) {
        let newMessageDictionary = ["Sender":ID, "MessageBody": content]
        DB_BASE.child("Messages").childByAutoId().setValue(newMessageDictionary) { (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("Message Saved Successfully")
            }
        }
    }
    func retrieveMessages(handler : @escaping(_ messageArray : [Message])->()) {
        
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (messagesReceived) in
            let value = messagesReceived.value as! Dictionary<String,String>
            let text = value["MessageBody"]!
            let sender = value["Sender"]!
            
            let newMessage = Message()
            newMessage.sender = sender
            newMessage.messageBody = text
            
            let imageRef = ST_BASE.child("profileImg").child(sender)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print(error)
                    let image = UIImage(named: "profileDefault")
                    newMessage.senderImage = image!
                    return
                } else {
                    let image = UIImage(data: data!)
                    newMessage.senderImage = image!
                }
            }
            self.messageArray.append(newMessage)
            handler(self.messageArray)
            
        }
    }
}

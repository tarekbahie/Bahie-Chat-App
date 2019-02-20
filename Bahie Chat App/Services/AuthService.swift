import Foundation
import Alamofire
import SwiftyJSON
import FirebaseAuth
import Firebase
import FirebaseStorage

let DB_BASE = Database.database().reference(fromURL: "https://bahie-s-chat.firebaseio.com/")
class AuthService {
    static let instance = AuthService()
    
    
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_PHOTOS = DB_BASE.child("photos")
    private var _REF_MESSAGES = DB_BASE.child("messages")
    
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    var REF_Messages: DatabaseReference{
        return _REF_MESSAGES
    }
    var REF_PHOTOS: DatabaseReference{
        return _REF_PHOTOS
    }
        func createDBUser(uid : String, userData : Dictionary<String,Any>){
            REF_USERS.child(uid).updateChildValues(userData)
        }
        
    let defaults = UserDefaults.standard
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    var authToken : String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    var userId: String {
        get {
            return defaults.value(forKey: USER_ID) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_ID)
        }
}
    
    func createUser(name: String, pass: String, completionHandler : @escaping (_ status : Bool, _ error : Error?)->()) {
        Auth.auth().createUser(withEmail: name, password: pass) { (user, error) in
            guard let user = user else {
                completionHandler(false,error)
                return
            }
            let userData = ["provider": user.user.providerID, "email": user.user.email]
            self.createDBUser(uid: user.user.uid, userData: userData as Dictionary<String, Any>)
            completionHandler(true, nil)
        }
    }
        func loginUser(withEmail email : String, withPassword password : String, loginComplete : @escaping (_ status : Bool, _ error : Error?)->()){
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil{
                    loginComplete(false, error)
                    return
                }
                loginComplete(true, nil)
                
            }
        }
    
   
    
    
        
    }


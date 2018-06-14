//
//  AuthViewController.swift
//  Infoquest2K18
//
//  Created by rohit on 09/02/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import Alamofire
import SwiftyJSON

class AuthViewController : UIViewController , FUIAuthDelegate{
    var ps = ""
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if error != nil {
            
            let av = UIAlertController(title: "Some Problem!!", message: "Error whil logging in.", preferredStyle: UIAlertControllerStyle.alert)
            let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                
            }
            av.addAction(no2Action)
            self.present(av, animated: true, completion: nil)
            
        }
        else {
            
        }
    }
    let defaults = UserDefaults.standard
    let manager = Alamofire.SessionManager.default
    let login = "https://infoquest.in/api/infoquest18/prod/v1/userRegister.php"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FIRApp.configure()
        let authui = FUIAuth.defaultAuthUI()
        authui?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIFacebookAuth(),
            FUIGoogleAuth()
        ]
        authui?.providers = providers
        let authViewController = authui?.authViewController();
        self.view.addSubview((authViewController?.view!)!)
        self.addChildViewController(authViewController!)
        
        let handle = FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
            if auth.currentUser != nil {
                
                var email  = ""
                var displayimageurl : URL!
                var usertoken = ""
                var displayname  = ""
                var AppKey = ""
                var fcmtoken = ""
                self.manager.session.configuration.timeoutIntervalForRequest = 120
                if let dpname = auth.currentUser?.displayName {
                    displayname = dpname
                }
                
                if let em = auth.currentUser?.email{
                    email = em
                }
                
                if let displayurl = auth.currentUser?.photoURL {
                    displayimageurl = displayurl
                }
                if let utoken = auth.currentUser?.uid {
                    usertoken = utoken
                }
                if let appkey = self.defaults.value(forKey: "AppKey") {
                    AppKey = appkey as! String
                }
                if let ftoken = self.defaults.value(forKey: "fcmtoken") {
                    fcmtoken = ftoken as! String
                }
                
                let data : [String : Any] = ["AppKey" : AppKey , "displayname" : displayname , "email" :  email, "displayimageurl" :  displayimageurl, "phonenumber" : NSNull.self() ,  "fcmtoken" : fcmtoken , "usertoken" : usertoken]
                
                self.manager.request(self.login, method: .post, parameters: data, encoding: URLEncoding.default, headers: nil).responseJSON {
                    [unowned self] response in
                    
                    response.result.ifSuccess {
                        let json = JSON(response.result.value)
                        
                        let y = json.object as! [String : Any]
                        if y["AuthKeyError"] == nil {
                            if y["Exception"] == nil {
                                if y["error"] == nil {
                                    if y["SessionExpired"] == nil {
                                        
                                        if let stoken = json.dictionaryObject!["SessionToken"] {
                                            self.defaults.set(stoken, forKey: "SessionToken")
                                        }
                                        if let UID = json.dictionaryObject!["UserID"] {
                                            self.defaults.set(UID, forKey: "UserID")
                                        }
                                        var pro = ""
                                        if let pstatus = json.dictionaryObject!["ProfileStatus"] {
                                            pro = pstatus as! String
                                            self.defaults.set(pstatus, forKey: "ProfileStatus")
                                        }
                                    }
                                    else {
                                        let av = UIAlertController(title: "Some Problem!!", message: "SessionExpired", preferredStyle: UIAlertControllerStyle.alert)
                                        let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                                            
                                        }
                                        av.addAction(no2Action)
                                        self.present(av, animated: true, completion: nil)
                                    }
                                }
                                else {
                                    let av = UIAlertController(title: "Some Problem!!", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                                    let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                                        
                                    }
                                    av.addAction(no2Action)
                                    self.present(av, animated: true, completion: nil)
                                }
                            }
                            else {
                                let av = UIAlertController(title: "Some Problem!!", message: "Exception", preferredStyle: UIAlertControllerStyle.alert)
                                let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                                    
                                }
                                av.addAction(no2Action)
                                self.present(av, animated: true, completion: nil)
                            }
                        }
                        else {
                            let av = UIAlertController(title: "Some Problem!!", message: "AuthKeyError", preferredStyle: UIAlertControllerStyle.alert)
                            let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                                
                            }
                            av.addAction(no2Action)
                            self.present(av, animated: true, completion: nil)
                        }
                        
                        
                        
                    }
                    
                    response.result.ifFailure {
                        let av = UIAlertController(title: "Some Problem!!", message: "Please check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
                        let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                            
                        }
                        av.addAction(no2Action)
                        self.present(av, animated: true, completion: nil)
                    }
                    
                }
                
            }
            else{
                
            }
        }
        
    }
    
}

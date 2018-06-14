//
//  ViewController.swift
//  Infoquest2K18
//
//  Created by rohit on 15/01/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import Alamofire
import SwiftyJSON
import Firebase



class ViewController: UIViewController {
    let defaults = UserDefaults.standard
    var ProfileStatus = ""
    let login = "https://infoquest.in/api/infoquest18/prod/v1/initialCheck.php"
    let manager = Alamofire.SessionManager.default
    var Appkey = ""
    var SessionToken = ""
    var UserID = ""
    var testvalue = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func letsgo(_ sender: Any) {
        var tempid = ""
        var tempss = ""
        
        if let wo = defaults.value(forKey: "UserID") {
            tempid = wo as! String
        }
        if let xo = defaults.value(forKey: "SessionToken") {
            tempss = xo as! String
        }
        
        if FIRAuth.auth()?.currentUser != nil  && tempid.elementsEqual("") && tempss.isEmpty{
            print("this shit has been entered")
            performSegue(withIdentifier: "test", sender: nil)
            
        }
        else if FIRAuth.auth()?.currentUser != nil {
            print("this one has been entered")
            testing()
            if let p = defaults.value(forKey: "ProfileStatus"){
                let x = p as! String
                if x == "0" {
                    performSegue(withIdentifier: "status", sender: nil)
                }
                else {
                    performSegue(withIdentifier: "home", sender: nil)
                    
                }
            }
        }
        else {
            performSegue(withIdentifier: "test", sender: nil)
            
        }
    }
    
    func testing(){
        manager.session.configuration.timeoutIntervalForRequest = 120
        if let ak = defaults.value(forKey: "AppKey") {
            Appkey = ak as! String
        }
        if let st = defaults.value(forKey: "SessionToken") {
            SessionToken = st as! String
        }
        if let uid = defaults.value(forKey: "UserID") {
            UserID = uid as! String
        }
        
        let data : [String : Any] = ["AppKey" : Appkey , "SessionToken" : SessionToken , "UserID" : UserID]
        print(data)
        
        manager.request(login, method: .post, parameters: data, encoding: URLEncoding.default, headers: nil).responseJSON{
            [unowned self] response in
            
            response.result.ifSuccess {
                let json = JSON(response.result.value)
                
                let y = json.object as! [String : Any]
                if y["SessionExpired"] == nil {
                    if y["Exception"] == nil{
                        if y["error"] == nil {
                            if y["AuthKeyError"] == nil {
                                if let pstat =  json.dictionaryObject!["ProfileStatus"] {
                                    self.defaults.setValue(pstat, forKey: "ProfileStatus")
                                }
                            }
                            else {
                                let av = UIAlertController(title: "Some Problem!!", message: "AuthKey Error", preferredStyle: UIAlertControllerStyle.alert)
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
                    let av = UIAlertController(title: "Some Problem!!", message: "Session Expired.", preferredStyle: UIAlertControllerStyle.alert)
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


}


//
//  StatusUpdateViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 18/02/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class StatusUpdateViewController: UIViewController {
    
    
    @IBOutlet weak var welcome: UITextView!
    let remotecall = "https://infoquest.in/api/infoquest18/prod/v1/updateUserDetails.php"
    let defaults = UserDefaults.standard
    @IBOutlet weak var referral: UITextField!
    @IBOutlet weak var clgname: UITextField!
    @IBOutlet weak var phone: UITextField!
    let manager = Alamofire.SessionManager.default
    override func viewDidLoad() {
        super.viewDidLoad()
        let str = FIRAuth.auth()?.currentUser
        if str != nil {
            welcome.text = "HELLO \t" + (str?.displayName)!
        }
        
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func statupdate(_ sender: Any) {
        manager.session.configuration.timeoutIntervalForRequest = 120
        var AppKey = ""
        var SessionToken = ""
        var UserID = ""
        var PhoneNumber = ""
        var CollegeName = ""
        var ReferralCode = ""
        phone.isUserInteractionEnabled = true
        clgname.isUserInteractionEnabled = true
        referral.isUserInteractionEnabled = true
        if phone.text != nil {
            if clgname.text != nil {
                
                if let akey = self.defaults.value(forKey: "AppKey") {
                    AppKey = akey as! String
                }
                if let stoken = self.defaults.value(forKey: "SessionToken") {
                    SessionToken = stoken as! String
                }
                if let uid = self.defaults.value(forKey: "UserID") {
                    UserID = uid as! String
                }
                if let pno = phone.text {
                    PhoneNumber = pno
                }
                if let clgnames = clgname.text {
                    CollegeName = clgnames
                }
                if let rcode = referral.text {
                    ReferralCode = rcode
                }
                
                
                let data : [String : Any] = ["AppKey" : AppKey , "SessionToken" : SessionToken , "UserID" : UserID , "PhoneNumber" : PhoneNumber , "CollegeName" : CollegeName , "ReferralCode" : ReferralCode]
                
                manager.request(remotecall, method: .post, parameters: data, encoding: URLEncoding.default, headers: nil).responseJSON {
                    response in
                    
                     response.result.ifSuccess {
                        
                        let json = JSON(response.result.value)
                        let y = json.object as! [String : Any]
                        
                        if y["AuthKeyError"] == nil {
                            if y["Exception"] == nil {
                                if y["error"] == nil {
                                    if y["SessionExpired"] == nil {
                                        
                                        if let pstat = json.dictionaryObject!["ProfileStatus"] {
                                            self.defaults.setValue(pstat, forKey: "ProfileStatus")
                                        }
                                        if json.error == nil {
                                            self.performSegue(withIdentifier: "statushomescreen", sender: nil)
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
            else {
                clgname.placeholder = "Enter College name."
            }
            
        }
        else {
            phone.placeholder = "Enter Phone number."
        }
    }
    
}

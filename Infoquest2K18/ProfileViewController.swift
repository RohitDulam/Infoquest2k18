//
//  ProfileViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 20/02/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    let defaults = UserDefaults.standard
    var displayname = ""
    var playpoints = ""
    var referrerstatus = ""
    var refcount = ""
    var email = ""
    var clgname = ""
    var phone = ""
    var refcode = ""
    @IBOutlet weak var tableview: UITableView!
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.m.count == 0 {
            return 0
        }
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(250)
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = Bundle.main.loadNibNamed("TestTableViewCell", owner: self, options: nil)?.first as! TestTableViewCell
            cell.img.sd_setImage(with: FIRAuth.auth()?.currentUser?.photoURL, placeholderImage: #imageLiteral(resourceName: "applogo"))
            return cell
        case 1:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            cell.hd.text = "IQ'18 ID"
            cell.stuff.textAlignment = .center
            cell.stuff.text = defaults.value(forKey: "UserID") as! String
            return cell
        case 2:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            cell.hd.text = "USERNAME"
            cell.stuff.textAlignment = .center
            cell.stuff.text = displayname
            return cell
        case 3:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            //cell.hd.isHidden = true
            cell.hd.text = "PLAY POINTS"
            cell.stuff.textAlignment = .center
            cell.stuff.text = playpoints
            return cell
        case 4:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            if self.referrerstatus == "" {
                cell.hd.text = "REFERRAL STATUS"
                cell.stuff.textAlignment = .center
                cell.stuff.text = "NOT ELIGIBLE"
            }
            else {
                //cell.hd.isHidden = true
                cell.hd.text = "REFERRAL STATUS"
                cell.stuff.isHidden = false
                cell.stuff.textAlignment = .center
                cell.stuff.text = "REFERRAL CODE : \(refcode) \n REFERRAL COUNT : \(refcount)"
            }
            return cell
        case 5:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            //cell.hd.isHidden = true
            cell.hd.text = "EMAIL"
            cell.stuff.isHidden = false
            cell.stuff.textAlignment = .center
            cell.stuff.text = email
            return cell
        case 6:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            //cell.hd.isHidden = true
            cell.hd.text = "PHONE NUMBER"
            cell.stuff.isHidden = false
            cell.stuff.textAlignment = .center
            cell.stuff.text = phone
            return cell
        default:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            //cell.hd.isHidden = true
            cell.hd.text = "COLLEGE NAME"
            cell.stuff.isHidden = false
            cell.stuff.textAlignment = .center
            cell.stuff.text = clgname
            return cell
        }
    }
    
    
    let manager = Alamofire.SessionManager.default
    var AppKey = ""
    var SessionToken = ""
    var UserID = ""
    var m : [String : Any] = ["" : ""]
    
    let remotecall = "https://infoquest.in/api/infoquest18/prod/v1/getUserProfile.php"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.estimatedRowHeight = 70
        tableview.separatorStyle = .none
        if let ak = defaults.value(forKey: "AppKey") {
            AppKey = ak as! String
        }
        if let st = defaults.value(forKey: "SessionToken") {
            SessionToken = st as! String
        }
        if let uid = defaults.value(forKey: "UserID") {
            UserID = uid as! String
        }
        
        let data : [String : Any] = ["AppKey" : AppKey , "SessionToken" : SessionToken , "UserID" : UserID]
        manager.request(remotecall, method: .post, parameters: data, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            
             response.result.ifSuccess {
                let json = JSON(response.result.value)
                self.m = json.object as! [String : Any]
                if self.m["AuthKeyError"] == nil {
                    if self.m["Exception"] == nil {
                        if self.m["error"] == nil {
                            if self.m["SessionExpired"] == nil {
                                let n = self.m["Details"] as! [Any]
                                let d = n[0] as! [String : Any]
                                self.displayname = d["DisplayName"] as! String
                                self.playpoints = d["PlayPoints"] as! String
                                self.referrerstatus = d["ReferrerStatus"] as! String
                                self.refcount = d["ReferralCount"] as! String
                                self.clgname = d["CollegeName"] as! String
                                self.email = d["Email"] as! String
                                self.phone = d["PhoneNumber"] as! String
                                self.refcode = d["ReferralCode"] as! String
                                
                                self.tableview.reloadData()
                            }
                            else {
                                let av = UIAlertController(title: "Some Problem!!", message: "Session Expired", preferredStyle: UIAlertControllerStyle.alert)
                                let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                                    
                                }
                                av.addAction(no2Action)
                                self.present(av, animated: true, completion: nil)
                            }
                        }
                        else {
                            let av = UIAlertController(title: "Some Problem!!", message: "error", preferredStyle: UIAlertControllerStyle.alert)
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

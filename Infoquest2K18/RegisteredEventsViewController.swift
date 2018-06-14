//
//  RegisteredEventsViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 04/03/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisteredEventsViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if eventids.count == 0 {
            return 0
        }
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = Bundle.main.loadNibNamed("RegisteredEventsTableViewCell", owner: self, options: nil)?.first as! RegisteredEventsTableViewCell
        cell.eventname.text = names[indexPath.row]
        cell.eventdetails.text = "EventPlayID : \(eventids[indexPath.row]) \n Event ID : \(events[indexPath.row]) \n Player(s) Count : \(teamcount[indexPath.row])"
        
        let ind = (teamcount[index] as! NSString).integerValue
        let v = listfinal[indexPath.row] as! [Any]
        let w = uidlistfinal[indexPath.row] as! [Any]
        //print(v[0])
        var strplayers = ""
        for i in 0...v.count-1 {
            strplayers += "\n \(v[i]) \t \(w[i])"
        }
        print(strplayers)
        cell.players.text = strplayers
        cell.status.text = ""
        if paidstatus[index] == "0" {
            str1 = "PAID : YET TO BE PAID \n"
        }
        else {
            str1 = "PAID : PAID \n"
        }
        if attended[index] == "0" {
            str2 = "ATTENDED : YET TO ATTEND \n"
        }
        else {
            str2 = "ATTENDED : ATTENDED \n"
        }
        if priceelg[index] == "0" {
            str3 = "REWARD : NOT ELIGIBLE \n"
        }
        else {
            if pricegivenstatus[index] == "0" {
                if attended[index] == "1" {
                    str5 = "AMOUNT AWARDED : \(pricegivenstatus[index]) \n"
                    if pricetaken[index] == "0" {
                        str3 = "REWARD : YET TO BE COLLECTED \n"
                    }
                    else {
                        str3 = "REWARD : COLLECTED \n"
                    }
                }
            }
        }
        if certif[index] == "0" {
            str4 = "CERTIFICATE STATUS : NOT ELIGIBLE \n"
        }
        else {
            if attended[index] == "0" {
                str4 = "CERTIFICATE STATUS : YET TO BE COLLECTED"
            }
            else {
                if certielg[index] == "0" {
                    str4 = "CERTIFICATE STATUS : COLLECT YOUR CERTIFICATES"
                }
                else {
                    str4 = "CERTIFICATE STATUS : CERTIFICATES COLLECTED"
                }
            }
        }
        cell.status.text = str1 + str2 + str5 + str3 + str4
        
        return cell
    }
    
    let remotecall = "https://infoquest.in/api/infoquest18/prod/v1/getRegisteredEvents.php"
    let manager = Alamofire.SessionManager.default
    let defaults = UserDefaults.standard
    var AppKey = ""
    var SessionToken = ""
    var UserID = ""
    var names : [String] = []
    var paidstatus : [String] = []
    var attended : [String] = []
    var eventids : [String] = []
    var pricesstatus : [String] = []
    var certicount : [String] = []
    var teamcount : [String] = []
    var priceelg : [String] = []
    var certielg : [String] = []
    var pricegivenstatus : [String] = []
    var events : [String] = []
    var certif : [String] = []
    var pricetaken : [String] = []
    var amountgiven : [String] = []
    var eventpoints : [String] = []
    var price : [String] = []
    var dname : [String] = []
    var uid : [String] = []
    var shit = ""
    var str1 = ""
    var str2 = ""
    var str3 = ""
    var str4 = ""
    var str5 = ""
    var listinter : [String] = []
    var listfinal : [Any] = []
    var uidlistinter : [String] = []
    var uidlistfinal : [Any] = []
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        title = "Registered Events"
        tableview.dataSource = self
        tableview.delegate = self
        super.viewDidLoad()
        
        if let ak = defaults.value(forKey: "AppKey") {
            AppKey = ak as! String
        }
        if let sk = defaults.value(forKey: "SessionToken"){
            SessionToken = sk as! String
        }
        if let uid = defaults.value(forKey: "UserID"){
            UserID = uid as! String
        }
        
        let data : [String : Any] = ["AppKey" : AppKey , "SessionToken" : SessionToken , "UserID" : UserID]
        manager.request(remotecall, method: .post, parameters: data, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            
            response.result.ifSuccess {
                let json = JSON(response.result.value)
                let m = json.object as! [String : Any]
                if let ntng = m["NoEvent"] {
                    self.shit = ntng as! String
                }
                if self.shit == "NoEvents" {
                    let av = UIAlertController(title: "Registered Events.", message: "No Registered events yet.", preferredStyle: UIAlertControllerStyle.alert)
                    let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                        
                    }
                    av.addAction(no2Action)
                    self.present(av, animated: true, completion: nil)
                }
                else {
                    let n = m["Data"] as! [Any]
                    for ro in n  {
                        let x = ro as! [String : Any]
                        //print(x)
                        let mno = x["EventData"] as! [Any]
                        let xyz = x["Players"] as! [Any]
                        
                        let y = mno[0] as! [String : Any]
                        self.names.append(y["EventName"] as! String)
                        self.paidstatus.append(y["PaidStatus"] as! String)
                        self.attended.append(y["AttendedStatus"] as! String)
                        self.eventids.append(y["EventPlayID"] as! String)
                        self.pricesstatus.append(y["PriceToBeGiven"] as! String)
                        self.certicount.append(y["Certificate_Count"] as! String)
                        self.teamcount.append(y["TeamCount"] as! String)
                        let fk = (y["TeamCount"] as! NSString).integerValue
                        for i in 0...fk{
                            
                            let inter = xyz[i] as! [String : Any]
                            self.listinter.append(inter["DisplayName"] as! String)
                            self.uidlistinter.append(inter["UserID"] as! String)
                            self.dname.append(inter["DisplayName"] as! String)
                            self.uid.append(inter["UserID"] as! String)
                        }
                        self.listfinal.append(self.listinter)
                        self.uidlistfinal.append(self.uidlistinter)
                        self.listinter.removeAll()
                        self.uidlistinter.removeAll()
                        self.priceelg.append(y["PriceEligible"] as! String)
                        self.certielg.append(y["CertificateStatus"] as! String)
                        self.events.append(y["EventID"] as! String)
                        self.certif.append(y["CertificateEligible"] as! String)
                        self.pricegivenstatus.append(y["PriceAmountGiven"] as! String)
                        self.pricetaken.append(y["PriceTakenStatus"] as! String)
                        self.amountgiven.append(y["PaidStatus"] as! String)
                        self.eventpoints.append(y["EventPoints"] as! String)
                        self.price.append(y["EventPrice"] as! String)
                    }
                }
                
                self.tableview.reloadData()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

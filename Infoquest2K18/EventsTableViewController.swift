//
//  EventsTableViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 28/02/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventsTableViewController: UITableViewController {
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    var activityIndicatorView: UIActivityIndicatorView!
    var data : String = ""
    var urls : [String] = []
    var evnames : [String] = []
    var name = ""
    let manager = Alamofire.SessionManager.default
    let remotecall = "https://infoquest.in/api/infoquest18/prod/v1/getEventDescription.php"
    let defaults = UserDefaults.standard
    var AppKey : String = ""
    var SessionToken : String = ""
    var UserID : String = ""
    var x : String = ""
    var imgurl : String = ""
    var eventdesc : String = ""
    var totalpart: String = ""
    var entryprice : String = ""
    var m : [String : Any]! = nil
    var coord : [String] = []
    var coordphone : [String] = []
    var priceelg = ""
    var certielg = ""
    var playpoints = ""
    var externalurl = ""
    var concludedstatus = ""
    var str1 = ""
    var str2 = ""
    var str3 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
        title = name
        self.tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.activityIndicatorView.center = self.tableView.center
        activityIndicatorView.startAnimating()
        
        self.testing()
        
                
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    /*override func viewWillAppear(_ animated: Bool) {
        
        testing()
        
    } */
    
    func testing() {
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        if let ak = defaults.value(forKey: "AppKey") {
            AppKey = ak as! String
        }
        
        if let st = defaults.value(forKey: "SessionToken") {
            SessionToken = st as! String
        }
        
        if let uid = defaults.value(forKey: "UserID") {
            UserID = uid as! String
        }
        let data : [String : Any] = ["AppKey" : AppKey , "SessionToken" : SessionToken , "UserID" : UserID , "EventName" : name]
        
        manager.request(remotecall, method: .post, parameters: data, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            
            response.result.ifSuccess {
                let json = JSON(response.result.value)
                let y = json.dictionaryObject!["EventDetails"] as! [Any]
                self.m = y[0] as! [String : Any]
                self.x = self.m["EventRules"] as! String
                self.imgurl = self.m["ImageUrl"] as! String
                self.eventdesc = self.m["EventDescription"] as! String
                self.totalpart = self.m["TotalParticipants"] as! String
                self.entryprice = self.m["EntryPrice"] as! String
                self.priceelg = self.m["PriceEligibility"] as! String
                self.certielg = self.m["CertificateEligibility"] as! String
                self.playpoints = self.m["PlayPoints"] as! String
                self.concludedstatus = self.m["Concluded"] as! String
                self.externalurl = self.m["ExternalUrl"] as! String
                self.coord.append(contentsOf: [self.m["Coordinator1Name"] as! String , self.m["Coordinator2Name"] as! String , self.m["Coordinator3Name"] as! String , self.m["Coordinator4Name"] as! String])
                self.coordphone.append(contentsOf: [self.m["Coordinator1Phone"] as! String , self.m["Coordinator2Phone"] as! String , self.m["Coordinator3Phone"] as! String , self.m["Coordinator4Phone"] as! String])
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
                

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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if m == nil {
            return 0
        }
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(250)
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = Bundle.main.loadNibNamed("TestTableViewCell", owner: self, options: nil)?.first as! TestTableViewCell
            cell.img.sd_setImage(with: URL(string: self.imgurl))
            return cell
            
        case 1:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            
            cell.hd.text = "EVENT DESCRIPTION"
            cell.stuff.text = eventdesc
            
            return cell
        case 2:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            
            cell.hd.text = "EVENT RULES"
            cell.stuff.text = x
            
            return cell
        case 3:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            
            cell.hd.text = "PARTICIPATION DETAILS"
            cell.stuff.text = "Total Participants :  \(totalpart) \n Entry Price :   \(entryprice)"
            
            return cell
            
        case 4:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            
            cell.hd.text = "CO-ORDINATOR DETAILS"
            if coord[0] != "" {
                cell.stuff.text = "\(coord[0]) : \t \(coordphone[0]) \n \(coord[1]) : \t \(coordphone[1]) \n \(coord[2]) : \t \(coordphone[2]) \n \(coord[3]) : \t \(coordphone[3])"
            }
            else {
                cell.stuff.textAlignment = .center
                cell.stuff.text = "Will be updated soon"
            }
            return cell
            
        case 5:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            cell.hd.text = "ELIGIBILITY DETAILS."
            if priceelg == "0" {
                str1 = "\nEligibility for Prize Money : Not Eligible \n"
                
            }
            else {
                str1 = "\nEligibility for Prize Money : Eligible \n"
            }
            if certielg == "0" {
                str2 = "Eligibility for Certificate : Not Eligible \n"
            }
            else {
                str2 = "Eligibility for Certificate : Eligible \n"
            }
            cell.stuff.text = str1 + str2 + "PlayPoints : \(playpoints) \n"
            
            return cell
        default:
            let cell = Bundle.main.loadNibNamed("DescTableViewCell", owner: self, options: nil)?.first as! DescTableViewCell
            
            cell.hd.text = "REGISTRATION"
            
            if externalurl == "" {
                cell.stuff.text = "There's no need for additional registration. Press the Settings button and you can find a section named ID Card which will be used as your authentication for the whole event."
            }
            else {
                cell.stuff.textAlignment = .center
                cell.stuff.textColor = UIColor.blue
                cell.stuff.text = "Press this link to be redirected to external payment link."
            }
            
            return cell
        }
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            if externalurl != "" {
                let urls = URL(string: externalurl)
                guard let url = urls else {
                    return //be safe
                }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  HomeTableViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 10/03/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeTableViewController: UITableViewController {
    let images = ["featured-min-1" , "departmentevents-min-1" , "spotevents-min-1" , "sponsers-min-1" , "profile-min-1" , "teamiq-min-1", "leaderboard-min-1"]
    
    let remotecall = "https://infoquest.in/api/infoquest18/prod/v1/getEvents.php"
    
    let manager = Alamofire.SessionManager.default
    let defaults = UserDefaults.standard
    var index = 0
    var AppKey = ""
    var SessionKey = ""
    var UserID = ""
    var sponsor : [Any] = []
    var BranchEvents : [Any] = []
    var FlagEvents : [Any] = []
    var SpotEvents : [Any] = []
    var sep = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        title = "INFOQUEST2K18"
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        if let ak = defaults.value(forKey: "AppKey") {
            AppKey = ak as! String
        }
        
        if let sk = defaults.value(forKey: "SessionToken") {
            SessionKey = sk as! String
        }
        
        if let ud = defaults.value(forKey: "UserID") {
            UserID = ud as! String
        }
        
        let data : [String : Any] = ["AppKey" : AppKey , "SessionToken" : SessionKey , "UserID" : UserID]
        
        
        manager.request(remotecall, method: .post, parameters: data, encoding: URLEncoding.default, headers: nil).responseJSON{
            [unowned self] response in
            
            response.result.ifSuccess {
                let json = JSON(response.result.value)
                //let x = json.dictionaryObject!["Sponsors"]
                let y = json.object as! [String : Any]
                if y["SessionExpired"] == nil {
                    if y["Exception"] == nil{
                        if y["error"] == nil {
                            if y["AuthKeyError"] == nil {
                                self.sponsor = y["Sponsors"] as! [Any]
                                self.BranchEvents = y["BranchEvents"] as! [Any]
                                self.SpotEvents = y["SpotEvents"] as! [Any]
                                self.FlagEvents = y["FlagEvents"] as! [Any]
                            }
                            else{
                                let av = UIAlertController(title: "Some Problem!!", message: "Auth Key Error", preferredStyle: UIAlertControllerStyle.alert)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return images.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        if index == 4 {
            performSegue(withIdentifier: "profile", sender: self)
        }
        else if index == 6 {
            performSegue(withIdentifier: "leaderboard", sender: self)
        }
        else if index == 5 {
            performSegue(withIdentifier: "team", sender: self)
        }
        else {
            performSegue(withIdentifier: "sponsors", sender: self)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TestTableViewCell", owner: self, options: nil)?.first as! TestTableViewCell
        var res = ""
        /*if let path = Bundle.main.resourcePath {
            let im = "Assets.xcassets/teamiq-min"
            res = path + "/" + im
            //print(res)
        }*/
        //let path = Bundle.main.path(forResource: "teamiq-min", ofType: "jpg")
        cell.img.image = UIImage(named: images[indexPath.row])
        
        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            let vc = segue.destination as! SettingsViewController
            vc.str = "SETTINGS"
        }
        else {
            if index == 0{
                
                let vc = segue.destination as! SponsorTableViewController
                vc.seguedata = FlagEvents
                vc.str = "Flagship Events"
                
                
            }
            else if index == 1 {
                let vc = segue.destination as! SponsorTableViewController
                vc.seguedata = BranchEvents
                vc.str = "Branch Events"
            }
            else if index == 2 {
                let vc = segue.destination as! SponsorTableViewController
                vc.seguedata = SpotEvents
                vc.str = "Spot Events"
            }
            else if index == 3 {
                let vc = segue.destination as! SponsorTableViewController
                vc.seguedata = sponsor
                vc.str = "Sponsors"
            }
            else if index == 4 {
                let vcp = segue.destination as! ProfileViewController
                //vcp.i = 0
            }
            else {
                
            }
        }
    }
 

}

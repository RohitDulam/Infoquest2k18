//
//  NotificationsTableViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 10/03/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NotificationsTableViewController: UITableViewController {
    let remotecall = "https://infoquest.in/api/infoquest18/prod/v1/notifications.php"
    let manager = Alamofire.SessionManager.default
    let defaults = UserDefaults.standard
    var AppKey = ""
    var SessionToken = ""
    var UserID = ""
    var dat : [Any] = []
    var imgurls : [String] = []
    var body : [String] = []
    var notifhead : [String] = []
    var timestamp : [String] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
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
                print(json)
                let y = json.object as! [String : Any]
                if y["AuthKeyError"] == nil {
                    if y["SessionExpired"] == nil {
                        self.dat = y["Notifications"] as! [Any]
                        for i in self.dat {
                            let x = i as! [String : Any]
                            self.imgurls.append(x["NotificationImageUrl"] as! String)
                            self.body.append(x["NotificationBody"] as! String)
                            self.notifhead.append(x["NotificationHead"] as! String)
                            self.timestamp.append(x["TimeStamp"] as! String)
                        }
                        self.tableView.reloadData()
                    }
                    else {
                        let av = UIAlertController(title: "Registered Events.", message: "No Registered events yet.", preferredStyle: UIAlertControllerStyle.alert)
                        let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                            
                        }
                        av.addAction(no2Action)
                        self.present(av, animated: true, completion: nil)
                    }
                }
                else {
                    let av = UIAlertController(title: "Registered Events.", message: "No Registered events yet.", preferredStyle: UIAlertControllerStyle.alert)
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
        if dat.count == 0{
            return 0
        }
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dat.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("NotificationsTableViewCell", owner: self, options: nil)?.first as! NotificationsTableViewCell
        cell.head.text = notifhead[indexPath.row]
        cell.body.text = body[indexPath.row]
        cell.img.sd_setImage(with: URL(string: imgurls[indexPath.row]))
        cell.time.text = timestamp[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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

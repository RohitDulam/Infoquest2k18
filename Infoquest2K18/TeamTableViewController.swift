//
//  TeamTableViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 10/03/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TeamTableViewController: UITableViewController {
    
    let remotecall = "https://infoquest.in/api/infoquest18/prod/v1/getTeamInfoquest.php"
    
    let manager = Alamofire.SessionManager.default
    let defaults = UserDefaults.standard
    var index = 0
    var AppKey = ""
    var SessionKey = ""
    var UserID = ""
    var branch : [String] = []
    var names : [String] = []
    var imgurl : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TEAM INFOQUEST"
        tableView.separatorStyle = .none
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
        manager.request(remotecall, method: .post, parameters: data, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            
            response.result.ifSuccess {
                let json = JSON(response.result.value)
                let y = json.object as! [String : Any]
                if y["Empty"] == nil {
                    let z = y["TeamInfoquest"] as! [Any]
                    for m in z {
                        let x = m as! [String : Any]
                        self.branch.append(x["Branch"] as! String)
                        self.names.append(x["Name"] as! String)
                        self.imgurl.append(x["ImageUrl"] as! String)
                    }
                    self.tableView.reloadData()
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if names.count == 0{
            return 0
        }
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.imageView?.sd_setImage(with: URL(string: imgurl[indexPath.row]))
        cell.textLabel?.text = "\(names[indexPath.row]) \t \(branch[indexPath.row])"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

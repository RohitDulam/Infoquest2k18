//
//  BranchTableViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 02/03/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BranchTableViewController: UITableViewController {
    let defaults = UserDefaults.standard
    var AppKey : String = ""
    var SessionKey : String = ""
    var UserID : String = ""
    let remotecall = "https://infoquest.in/api/infoquest18/prod/v1/getBranchEvents.php"
    var branch : String = ""
    let manager = Alamofire.SessionManager.default
    var urls : [String] = [""]
    var eventname : [String] = [""]
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        title = branch
        if let ak = defaults.value(forKey: "AppKey") {
            AppKey = ak as! String
        }
        
        if let sk = defaults.value(forKey: "SessionToken") {
            SessionKey = sk as! String
        }
        
        if let ud = defaults.value(forKey: "UserID") {
            UserID = ud as! String
        }
        
        let data : [String : Any] = ["AppKey" : AppKey , "SessionToken" : SessionKey , "UserID" : UserID , "BranchName" : branch]
        
        
        manager.request(remotecall, method: .post, parameters: data, encoding: URLEncoding.default, headers: nil).responseJSON{
            response in
            
            response.result.ifSuccess {
                let json = JSON(response.result.value)
                
                
                let y = json.object as! [String : Any]
                if y["AuthKeyError"] == nil {
                    if y["SessionExpired"] == nil{
                        if y["error"] == nil {
                            if y["Exception"] == nil {
                                for x in y["Events"] as! [Any]{
                                    let m = x as! [String : Any]
                                    self.urls.append(m["ImageUrl"] as! String)
                                    self.eventname.append(m["EventName"] as! String)
                                    //print(self.urls)
                                    
                                }
                                self.tableView.reloadData()
                            }
                            else {
                                let av = UIAlertController(title: "Some problem!!", message: "Exception", preferredStyle: UIAlertControllerStyle.alert)
                                let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                                    
                                }
                                av.addAction(no2Action)
                                self.present(av, animated: true, completion: nil)
                            }
                        }
                        else {
                            let av = UIAlertController(title: "Some problem!!", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                            let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                                
                            }
                            av.addAction(no2Action)
                            self.present(av, animated: true, completion: nil)
                        }
                    }
                    else {
                        let av = UIAlertController(title: "Some problem!!", message: "SessionExpired", preferredStyle: UIAlertControllerStyle.alert)
                        let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                            
                        }
                        av.addAction(no2Action)
                        self.present(av, animated: true, completion: nil)
                    }
                }
                else {
                    let av = UIAlertController(title: "Some problem!!", message: "AuthKeyError", preferredStyle: UIAlertControllerStyle.alert)
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return eventname.count - 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(250)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "brancheventdetails", sender: nil)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = Bundle.main.loadNibNamed("TestTableViewCell", owner: self, options: nil)?.first as! TestTableViewCell
        // Configure the cell...
        cell.img.sd_setImage(with: URL(string: urls[indexPath.row + 1]))
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! EventsTableViewController
        vc.name = eventname[index + 1]
    }


}

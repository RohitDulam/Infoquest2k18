//
//  ProfessionalBodiesTableViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 04/03/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfessionalBodiesTableViewController: UITableViewController {
    let remotecall = "https://infoquest.in/api/infoquest18/prod/v1/getProfessionalBodies.php"
    let manager = Alamofire.SessionManager.default
    let defaults = UserDefaults.standard
    var AppKey = ""
    var SessionToken = ""
    var UserID = ""
    var url : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let re = CGRect(x: tableView.bounds.width / 2 - 15, y: 0.0, width: 30, height: 30)
        let activityIndicatorView = UIActivityIndicatorView(frame: re)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let headerView: UIView = UIView(frame: CGRect(x:0, y:0, width: tableView.bounds.width, height: tableView.bounds.height))
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.startAnimating()
        headerView.addSubview(activityIndicatorView)
        self.tableView.tableHeaderView = headerView
        self.tableView.isScrollEnabled = false
        title = "PROFESSIONAL BODIES"
        
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
                if m["AuthKeyError"] == nil {
                    if m["SessionExpired"] == nil{
                        if m["error"] == nil {
                            if m["Exception"] == nil {
                                let x = m["ProfessionalBodies"] as! [Any]
                                for i in x {
                                    let mp = i as! [String : Any]
                                    self.url.append(mp["ImageUrl"] as! String)
                                }
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    self.tableView.isScrollEnabled = true
                                    self.tableView.tableHeaderView = nil
                                    self.tableView.isHidden = false
                                }
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
        if url.isEmpty {
            return 0
        }
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return url.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(250)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TestTableViewCell", owner: self, options: nil)?.first as! TestTableViewCell
        cell.img.sd_setImage(with: URL(string: url[indexPath.row]))
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

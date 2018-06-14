//
//  LeaderViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 03/03/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class LeaderViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(self.names[indexPath.row]) \t Points - \(self.points[indexPath.row])"
        cell.imageView?.sd_setImage(with: URL(string: self.iurl[indexPath.row]))
        
    
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if names.count == 0 {
            return 0
        }
        else{
            return 1
        }
    }
    
    var AppKey = ""
    var SessionToken = ""
    var UserID = ""
    let remotecall = "https://infoquest.in/api/infoquest18/prod/v1/getLeaderBoard.php"
    let manager = Alamofire.SessionManager.default
    let defaults = UserDefaults.standard
    var uid : [String] = []
    var iurl : [String] = []
    var points : [String] = []
    var names : [String] = []

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leader Board"
        tableview.delegate = self
        tableview.dataSource = self
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
                let m = json.object as! [String : Any]
                if m["TeamInfoquest"] != nil {
                    let n = m["TeamInfoquest"] as! [Any]
                    
                    let mp = n.makeIterator()
                    for r in mp{
                        let np = r as! [String : Any]
                        self.uid.append(np["Branch"] as! String)
                        self.points.append(np["Points"] as! String)
                        self.iurl.append(np["ImageUrl"] as! String)
                        self.names.append(np["Name"] as! String)
                        
                    }
                    self.tableview.reloadData()
                }
                else {
                    let av = UIAlertController(title: "Leaderboard.", message: "Will be updated soon.", preferredStyle: UIAlertControllerStyle.alert)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

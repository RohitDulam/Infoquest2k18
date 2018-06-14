//
//  SponsorTableViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 27/02/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit

class SponsorTableViewController: UITableViewController {
    
    var seguedata : [Any] = []
    var str : String = ""
    var interstr : [String : Any] = [:]
    var urls : [String] = []
    var weburls : [String] = []
    var evnames : [String] = []
    var index = 0
    var branchnames : [String] = [""]

    override func viewDidLoad() {
        super.viewDidLoad()
       // print(seguedata)
        title = str
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        switch str {
        case "Sponsors":
            for spon in seguedata{
                interstr = spon as! [String : Any]
                urls.append(interstr["SponsorImg"] as! String)
                weburls.append(interstr["SponsorWebUrl"] as! String)
            }
        case "Branch Events":
            for event in seguedata {
                interstr = event as! [String : Any]
                urls.append(interstr["ImageUrl"] as! String)
                branchnames.append(interstr["BranchName"] as! String)
                //print(branchnames)
            }
      /*  case "Spot Events":
            for event in seguedata {
                interstr = event as! [String : Any]
                urls.append(interstr["ImageUrl"] as! String)
                branchnames.append(interstr["BranchName"] as! String)
            } */
        default:
            for event in seguedata {
                interstr = event as! [String : Any]
                urls.append(interstr["ImageUrl"] as! String)
                evnames.append(interstr["EventName"] as! String)
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
        /*if str == "Spot Events"{
            return 0
        }
        else {
            return 1
        }*/
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       /* if str == "Spot Events"{
            return 0
        }
        else {
            return seguedata.count
        } */
        return seguedata.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(250)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = Bundle.main.loadNibNamed("TestTableViewCell", owner: self, options: nil)?.first as! TestTableViewCell
        cell.img.sd_setImage(with: URL(string: urls[indexPath.row]))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if str == "Sponsors" {
            guard let url = URL(string: weburls[indexPath.row]) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            if str == "Flagship Events" {
                index = indexPath.row
                performSegue(withIdentifier: "flagship", sender: nil)
            }
            else if str == "Spot Events" {
                index = indexPath.row
                performSegue(withIdentifier: "flagship", sender: nil)
            }
            else {
                index = indexPath.row
                performSegue(withIdentifier: "branch", sender: nil)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if str == "Flagship Events" {
            let vc = segue.destination as! EventsTableViewController
            
            vc.name = evnames[index]
            vc.imgurl = urls[index]
        }
        else if str == "Branch Events" {
            let vc = segue.destination as! BranchTableViewController
            vc.branch = branchnames[index+1]
        }
        else if str == "Spot Events" {
            let vc = segue.destination as! EventsTableViewController
            vc.name = evnames[index]
        }
        else {
            
        }
        
    }
    

}

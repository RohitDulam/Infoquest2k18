//
//  SettingsViewController.swift
//  Infoquest2K18
//
//  Created by Rohit Dulam on 04/03/18.
//  Copyright © 2018 rohit. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingsViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    let defaults = UserDefaults.standard
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            performSegue(withIdentifier: "professionalbodies", sender: nil)
        }
        else if indexPath.row == 0 {
            performSegue(withIdentifier: "registeredevents", sender: nil)
        }
        else if indexPath.row == 1{
            let strinfo = "InfoQuest, A national level techincal symposium has been organized as the annual technical fest at J B Institute of Engineering and Technology since 14 years. InfoQuest, having established itself in the itinerary of techincal festivals, aims at bringing together and fostering a plethora of engineering and technical aspirants from across the country. The name synonymous with journey towards technical excellence and organizational profeciency, is the most prestigious technical event held by our institute. InfoQuest 2018 promises to enable students to pit their ideas against one another in a friendly, creative yet competitive atmosphere.  "
            let av = UIAlertController(title: "About Infoquest", message: strinfo, preferredStyle: UIAlertControllerStyle.alert)
            let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                
            }
            av.addAction(no2Action)
            self.present(av, animated: true, completion: nil)
        }
        else if indexPath.row == 4 {
            let av = UIAlertController(title: "Contact Us.", message: "Email us at infoquest@jbiet.edu.in \n For further queries, you can contact the below mentioned volunteers. \n Dinakar Meruga - 9032369684 \n Suchith - 9542071276 \n", preferredStyle: UIAlertControllerStyle.alert)
            let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                
            }
            av.addAction(no2Action)
            self.present(av, animated: true, completion: nil)
        }
        else if indexPath.row == 5 {
            performSegue(withIdentifier: "idcard", sender: self)
        }
        else if indexPath.row == 6 {
            performSegue(withIdentifier: "notifications", sender: self)
        }
        else if indexPath.row == 7{
            let av = UIAlertController(title: "Log Out.", message: "All your details and credentials would be removed from this device.", preferredStyle: UIAlertControllerStyle.alert)
            let no2Action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                self.defaults.removeObject(forKey: "UserID")
                self.defaults.removeObject(forKey: "SessionToken")
                self.defaults.removeObject(forKey: "ProfileStatus")
                try! FIRAuth.auth()?.signOut()
                GIDSignIn.sharedInstance().signOut()
                self.performSegue(withIdentifier: "firstpage", sender: nil)
            }
            let yes2Action = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
                
            }
            av.addAction(no2Action)
            av.addAction(yes2Action)
            self.present(av, animated: true, completion: nil)
        }
        else{
            let av = UIAlertController(title: "REPORT A BUG", message: "Incase of any bugs, feel free to drop us a mail. You can also get in touch with me regarding technical aspects of both the App and the Fest. \n Rohit Dulam - 7416837581", preferredStyle: UIAlertControllerStyle.alert)
            let no2Action = UIAlertAction(title: "Mail", style: .default) { (action) -> Void in
                let email = "dulam.rohit99@gmail.com"
                if let url = URL(string: "mailto:\(email)") {
                    UIApplication.shared.open(url)
                }
            }
            let yes2Action = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
                
            }

            av.addAction(no2Action)
            av.addAction(yes2Action)
            self.present(av, animated: true, completion: nil)
            
        }
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    var str = ""
    let items = ["Registered Events","About Infoquest","Professional Bodies","Report a Bug","Contact Us","ID Card","Notifications","Logout"]

    override func viewDidLoad() {
        tableview.separatorStyle = .none
        title = str
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        // Do any additional setup after loading the view.
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

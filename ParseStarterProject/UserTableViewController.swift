//
//  UserTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Minh Pham on 11/20/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    
    var username = [""]
    var userID = [""]
    var isFollowing = ["": false]
    
    var refresher: UIRefreshControl!
    

    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func refresh(){
        let query = PFUser.query()
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error)
            } else if let users = objects {
                self.username.removeAll()
                self.userID.removeAll()
                self.isFollowing.removeAll()
                
                for object in users {
                    if let user = object as? PFUser {
                        
                        if user.objectId != PFUser.current()?.objectId {
                            
                            
                            let usernameArray = user.username!.components(separatedBy: "@")
                            
                            self.username.append(usernameArray[0])
                            self.userID.append(user.objectId!)
                            
                            let query = PFQuery(className: "Followers")
                            query.whereKey("follower", equalTo: (PFUser.current()?.objectId)!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                if let objects = objects{
                                    if objects.count > 0 {
                                        self.isFollowing[user.objectId!] = true
                                    } else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                    
                                    if self.isFollowing.count == self.username.count {
                                        self.tableView.reloadData()
                                        self.refresher.endRefreshing()
                                    }
                                }
                            })
                        }
                    }
                }
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(UserTableViewController.refresh), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)
        
        print("viewDIIDLoad")
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
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
        return username.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = username[indexPath.row]
        
        if (isFollowing[userID[indexPath.row]]!) == true {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if isFollowing[userID[indexPath.row]]! {
            isFollowing[userID[indexPath.row]] = false
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            let query = PFQuery(className: "Followers")

            query.whereKey("follower", equalTo: PFUser.current()?.objectId!)
            query.whereKey("following", equalTo: userID[indexPath.row])
            
            query.findObjectsInBackground(block: { (objects, error) in
                if let objects = objects {
                    print(objects, "line 126")
                    for i in objects {
                        i.deleteInBackground()
                    }
                }
            })

        } else {
            isFollowing[userID[indexPath.row]] = true
            
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            
            let following = PFObject(className: "Followers")
            print(PFUser.current()?.objectId)
            
            following["follower"] = PFUser.current()?.objectId
            following["following"] = userID[indexPath.row]
            
            following.saveInBackground()

            
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

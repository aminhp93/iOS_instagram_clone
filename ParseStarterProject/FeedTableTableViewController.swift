//
//  FeedTableTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Minh Pham on 11/20/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableTableViewController: UITableViewController {

    var users = [String:String]()
    var messages = [String]()
    var username = [String]()
    var imageFile = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if let users = objects {
                
                self.users.removeAll()
                
                for i in users{
                    if let user = i as? PFUser{
                        self.users[user.objectId!] = user.username
                    }
                }
            }
            
            let getFollowerUserQuery = PFQuery(className: "Followers")
            
            getFollowerUserQuery.whereKey("follower", equalTo: (PFUser.current()?.objectId))
            
            getFollowerUserQuery.findObjectsInBackground(block: { (objects, error) in
                if let followers = objects {
                    for i in followers{
                        if let follower = i as? PFObject{
                            let followedUser = follower["following"] as! String
                            
                            let query = PFQuery(className: "Posts")
                            
                            query.whereKey("userID", equalTo: followedUser)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                if let posts = objects {
                                    for i in posts {
                                        if let post = i as? PFObject {
                                            self.messages.append(post["message"] as! String)
                                            print(post["imageFile"])
                                            self.imageFile.append(post["imageFile"] as! PFFile)
                                            
                                            self.username.append(self.users[post["userID"] as! String]!)
                                            
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                            })
                            
                            
                            
                        }
                    }
                }
            })
            
            
        })
        
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
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        // Configure the cell...
        print(imageFile)
        
        imageFile[indexPath.row].getDataInBackground { (data, error) in
            if let imageData = data {
            
            if let downloadedImage = UIImage(data: imageData){
                cell.postedImage.image = downloadedImage
            }
            }
        }
        
        
        cell.usernameLabel.text = username[indexPath.row]
        
        cell.messageLabel.text = messages[indexPath.row]
        
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

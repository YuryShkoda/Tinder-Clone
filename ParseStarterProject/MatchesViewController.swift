//
//  MatchesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 1/20/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableVIew: UITableView!

    var images   = [UIImage]()
    var userIds  = [String]()
    var messages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        query?.whereKey("accepted", contains: PFUser.current()?.objectId)
        
        query?.whereKey("objectId", containedIn: PFUser.current()?["accepted"] as! [String])
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
            
                for object in users {
                
                    if let user = object as? PFUser {
                    
                        let imageFile = user["photo"] as! PFFile
                        
                        imageFile.getDataInBackground(block: { (data, error) in
                                
                            if let imageData = data {
                                
                                let messagesQuery = PFQuery(className: "Message")
                                
                                messagesQuery.whereKey("recipient", equalTo: (PFUser.current()?.objectId!)!)
                                
                                messagesQuery.whereKey("sender", equalTo: user.objectId!)
                                
                                messagesQuery.findObjectsInBackground(block: { (objects, error) in
                                    
                                    var messageText = "No message from this user"
                                    
                                    if let objects = objects {
                                    
                                        for message in objects {
                                        
                                            if let messageContent = message["content"] as? String {
                                            
                                                messageText = messageContent
                                            
                                            }
                                        
                                        }
                                    
                                    }
                                    
                                    self.messages.append(messageText)
                                    
                                    self.images.append(UIImage(data: imageData)!)
                                    
                                    self.userIds.append(user.objectId!)
                                    
                                    self.tableVIew.reloadData()
                                    
                                })
                                    
                            }
                                
                        })
                    
                    }
                
                }
            
            }
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return images.count
    
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MatchesTableViewCell
        
        cell.userImageView.image = images[indexPath.row]
        
        cell.messageLabel.text   = "You haven't recieved a message yet"
        
        cell.userIdLabel.text    = userIds[indexPath.row]
        
        cell.messageLabel.text   = messages[indexPath.row]
        
        return cell
    
    }
    

}

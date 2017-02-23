//
//  UserDetailsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 1/18/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var interestSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func updateProfileImage(_ sender: Any) {
        
        let imagePicker           = UIImagePickerController()
        imagePicker.delegate      = self
        imagePicker.sourceType    = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            userImage.image = image
        
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func update(_ sender: Any) {
    
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        
        PFUser.current()?["isInterestedInWomen"] = interestSwitch.isOn
        
        let imageData = UIImagePNGRepresentation(userImage.image!)
        
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
            
                var errorMessage = "Update failed - please try again"
                
                let error = error as? NSError
                
                if let parseError = error?.userInfo["error"] as? String {
                
                    errorMessage = parseError
                
                }
                self.errorLabel.text = errorMessage
            
            } else {
            
                print("Updated")
                
                self.performSegue(withIdentifier: "showSwipingViewController", sender: self)
                
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("UserDetails loaded")
        print(PFUser.current())
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            
            genderSwitch.setOn(isFemale, animated: false)
            
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
        
            interestSwitch.setOn(isInterestedInWomen, animated: false)
        
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
        
            photo.getDataInBackground(block: { (data, error) in
                
                if let imageData = data {
                
                    if let downloadedImage = UIImage(data: imageData) {
                    
                        self.userImage.image = downloadedImage
                    
                    }
                
                }
                
            })
        
        }
        
        
     /*
        
        let urlArray = ["http://cdn.madamenoire.com/wp-content/uploads/2013/08/penny-proud.jpg", "http://static.makers.com/styles/mobile_gallery/s3/betty-boop-cartoon-576km071213_0.jpg?itok=9qNg6GUd", "http://file1.answcdn.com/answ-cld/image/upload/f_jpg,w_672,c_fill,g_faces:center,q_70/v1/tk/view/cew/e8eccfc7/e367e6b52c18acd08104627205bbaa4ae16ee2fd.jpeg", "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=1760886", "http://vignette3.wikia.nocookie.net/simpsons/images/0/0b/Marge_Simpson.png/revision/20140826010629", "http://static6.comicvine.com/uploads/square_small/0/2617/103863-63963-torongo-leela.JPG", "https://itfinspiringwomen.files.wordpress.com/2014/03/scooby-doo-tv-09.jpg", "https://s-media-cache-ak0.pinimg.com/236x/9c/5e/86/9c5e86be6bf91c9dea7bac0ab473baa4.jpg"]
        
        var counter = 0
        
        for urlString in urlArray {
        
            counter += 1
    
            let url = URL(string: urlString)!
            
            do {
            
                let data = try Data(contentsOf: url)
                
                let imageFile = PFFile(name: "photo.png", data: data)
                
                let user = PFUser()
                
                user["photo"] = imageFile
                
                user.username = String(counter)
                
                user.password = "password"
                
                user["isInterestedInWomen"] = true
                
                user["isFemale"] = false
                
                let acl = PFACL()
                
                acl.getPublicWriteAccess = true
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if success {
                    
                        print("user signrd up")
                    
                    }
                    
                })
            
            } catch {
            
                print("Could not get data")
            
            }
            
        }
 
        
    */
 
        
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

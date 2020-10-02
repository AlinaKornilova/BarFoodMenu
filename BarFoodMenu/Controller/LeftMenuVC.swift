//
//  LeftMenuVC.swift
//  FAPanels
//
//  Created by Fahid Attique on 17/06/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//

import UIKit
import FAPanels
import Firebase
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage

class LeftMenuVC: UIViewController {
    
    
    var ref: DatabaseReference!
    var storageRef = Storage.storage().reference()
    var currentPhoto: String!
    var updatePhoto: String!
    var toUpImage: UIImage!
    var flag : Bool = false

    @IBOutlet weak var UpdateImage: UIImageView!
    @IBOutlet weak var UpdatePhotoBtn: UIButton!

    
    @IBOutlet var tableView: UITableView!
    
     override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.ref = Database.database().reference()
        self.ref.child("USERS/\(userID)").observeSingleEvent(of: DataEventType.value , with: { snapshot in
        let value = snapshot.value as? NSDictionary
            
        self.currentPhoto = value?["userProfile"] as? String
            
            let url = URL(string: self.currentPhoto!)
            self.UpdateImage.sd_setImage(with: url, placeholderImage: UIImage(named: "userAvatar"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                if( error != nil)
                {
                    print("Error while displaying image" , (error?.localizedDescription)! as String)
                }
            })
            self.UpdateImage.layer.masksToBounds = true
            self.UpdateImage.layer.cornerRadius = self.UpdateImage.bounds.width / 2
        })
    }
        @IBAction func SelectPhoto(_ sender: Any) {
            CameraHandler.shared.showActionSheet(vc: self)
            CameraHandler.shared.imagePickedBlock = { (image) in
            self.UpdateImage.image = image
                self.toUpImage = image
                self.flag = true
                self.UpdateInfo()
            }
        }
        func UpdateInfo() {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            self.ref = Database.database().reference()
                        
            if flag == true {
                let imageData = self.toUpImage.jpegData(compressionQuality: 0.1)
                let riversRef = self.storageRef.child("profiles").child("\(userID)")
                let metaDataConfig = StorageMetadata()
                metaDataConfig.contentType = "image/jpg"
                // Upload the file to the path "images/rivers.jpg"
                _ = riversRef.putData(imageData!, metadata: metaDataConfig) { (metadata, error) in
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    // Metadata contains file metadata such as size, content-type.
                    _ = metadata.size
                    // You can also access to download URL after upload.
                    riversRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        self.updatePhoto = downloadURL.absoluteString
                        self.ref.child("USERS/\(userID)/userProfile").setValue("\(self.updatePhoto!)")
                        self.flag = false
                    }
                }
            }
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func viewConfigurations() {
        
        tableView.register(UINib.init(nibName: "LeftMenuCell", bundle: nil), forCellReuseIdentifier: "LeftMenuCell")
    }
}

extension LeftMenuVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SharedManager.shared.AllProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell") as! LeftMenuCell
        
        if indexPath.row == 0 {
            
            cell.menuOption.text = "All Menu"
        }
        else if indexPath.row == 1 {
            cell.menuOption.text = "Favorite"
        }
        else {
            cell.menuOption.text = (Array(SharedManager.shared.AllProducts.keys).sorted(by: <))[indexPath.row ]
        }

        cell.menuImage.image = UIImage(named: "icons" + String( indexPath.row ))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "CenterVC")
        let centerNavVC = UINavigationController(rootViewController: centerVC)
        
        if indexPath.row == 1 {
            
            var favoriteProducts : [EachProduct] = []
            for key in (UserDefaults.standard.dictionaryRepresentation().keys) {
                if let allProducts = SharedManager.shared.AllProducts["AAAAAAAAAA"] {
                    for item in allProducts {
                        if( item.productID == key ) {
                            favoriteProducts.append(item)
                        }
                    }
                }
            }
            SharedManager.shared.AllProducts["AAAAAAAAAAa"] = favoriteProducts
            
        }
        
        SharedManager.shared.selectKey = (Array(SharedManager.shared.AllProducts.keys).sorted(by: <))[indexPath.row]
        
        panel!.configs.bounceOnCenterPanelChange = true
        panel!.center(centerNavVC, afterThat: {
            print("Executing block after changing center panelVC From Left Menu")
        })
    }
}

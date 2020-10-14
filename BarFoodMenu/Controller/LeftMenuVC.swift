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
import RSLoadingView

class LeftMenuVC: UIViewController {
    
    
    var ref: DatabaseReference!
    var storageRef = Storage.storage().reference()
    var currentPhoto: String!
    var currentName: String!
    var updatePhoto: String!
    var toUpImage: UIImage!
    var flag : Bool = false

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var UpdateImage: UIImageView!
    @IBOutlet weak var UpdatePhotoBtn: UIButton!
    @IBOutlet weak var signoutBtn: UIButton!
    
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
        self.currentName = value?["userName"] as? String
        self.userName.text = self.currentName
            
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
        readEachProductData1()
    }
    
    func readEachProductData1() {
        
        let loadingView = RSLoadingView()
        loadingView.showOnKeyWindow()
        
            self.ref = Database.database().reference()
            let ProductsCategory = self.ref.child("Products")
            ProductsCategory.observe(DataEventType.value , with: { snapshot in
                
                let categoryCount = snapshot.childrenCount
                var categoryCounter = 0
                var allProductsForAllMenu: [EachProduct] = []
                
                for item in snapshot.children {
                        
                    var EachCategoryProducts: [EachProduct] = []
                    let eachCategoryAllData = item as! DataSnapshot
                    let eachCategoryName = eachCategoryAllData.key as String?
                    let ProductsID = self.ref.child("Products").child(eachCategoryName!)
                    
                    ProductsID.observeSingleEvent(of: DataEventType.value , with: { snapshot in
                        
                        categoryCounter = categoryCounter + 1
                        
                        for item1 in snapshot.children {
                                    
                            let eachProductAllData = item1 as! DataSnapshot
                            let eachProductID = eachProductAllData.key as String?
                            let eachProductData = eachProductAllData.value as! NSDictionary
                            let eachProductName = eachProductData["productName"] as! String
                            
                            var eachProductImage: String?
                            if let eachProductImageTemp = eachProductData["productImage"] as? String {
                                eachProductImage = eachProductImageTemp
                            }
                            
                            let eachProductDetail = eachProductData["productDetail"] as! String

                            EachCategoryProducts.append(EachProduct(productID: eachProductID!, productName: eachProductName, productImgUrl: eachProductImage!,productDetail: eachProductDetail, productCategory: eachCategoryName!))
                                    
                            allProductsForAllMenu.append(EachProduct(productID: eachProductID!, productName: eachProductName, productImgUrl: eachProductImage!, productDetail: eachProductDetail, productCategory: eachCategoryName!))
                        }
                        
                        SharedManager.shared.AllProducts[eachCategoryName!] = EachCategoryProducts
                                
                        if categoryCounter == categoryCount {
                            SharedManager.shared.AllProducts["AAAAAAAAAA"] = allProductsForAllMenu
                            self.tableView.reloadData()
                             RSLoadingView.hideFromKeyWindow()
                        }
                })
            }
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

    @IBAction func changeName(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.ref = Database.database().reference()
        // 1.
        var usernameTextField: UITextField?
        // 2.
        let alertController = UIAlertController(
            title: "Change your name!",
            message: "Enter your new name.",
            preferredStyle: .alert)
        // 3.
        let loginAction = UIAlertAction(
        title: "OK", style: .default) {
            (action) -> Void in

            if let username = usernameTextField?.text {
                print(" Username = \(username)")
                if username == "" {
                    Utils.shared.showAlertWith(title: "Username is empty!", content: "Please enter your username!", viewController: self)
                    return
                }
                else {
                    self.userName.text = username
                    self.ref.child("USERS/\(userID)/userName").setValue(username)
                }
                
            } else {
                print("No Username entered")
            }
        }

        // 4.
        alertController.addTextField {
            (txtUsername) -> Void in
            usernameTextField = txtUsername
            usernameTextField!.placeholder = "Your username here!"
        }
        // 5.
        alertController.addAction(loginAction)
        present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func SignoutBtnAction(_ sender: Any) {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        let toSignin = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        SharedManager.shared.admin = false
        UIApplication.shared.windows.first?.rootViewController = toSignin
        UIApplication.shared.windows.first?.makeKeyAndVisible()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func viewConfigurations() {
        
        tableView.register(UINib.init(nibName: "LeftMenuCell", bundle: nil), forCellReuseIdentifier: "LeftMenuCell")
    }
}

extension LeftMenuVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SharedManager.shared.AllProducts.keys.contains("AAAAAAAAAAa") {
            return SharedManager.shared.AllProducts.count
        }
        else {
            return  SharedManager.shared.AllProducts.count + 1
        }
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
            if SharedManager.shared.AllProducts.keys.contains("AAAAAAAAAAa") {
                cell.menuOption.text = (Array(SharedManager.shared.AllProducts.keys).sorted(by: <))[indexPath.row ]
            }
            else {
                cell.menuOption.text = (Array(SharedManager.shared.AllProducts.keys).sorted(by: <))[indexPath.row - 1 ]
            }
        }
        cell.menuImage.image = UIImage(named: "icon")
        print(Array(SharedManager.shared.AllProducts.keys))

//        cell.menuImage.image = UIImage(named: "icons" + String( indexPath.row ))

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
        if indexPath.row == 0 {
            
            SharedManager.shared.selectKey = "AAAAAAAAAA"
        }
        else if indexPath.row == 1 {
            SharedManager.shared.selectKey = "AAAAAAAAAAa"
        }
        else {
            if SharedManager.shared.AllProducts.keys.contains("AAAAAAAAAAa") {
                SharedManager.shared.selectKey = (Array(SharedManager.shared.AllProducts.keys).sorted(by: <))[indexPath.row ]
            }
            else {
                SharedManager.shared.selectKey = (Array(SharedManager.shared.AllProducts.keys).sorted(by: <))[indexPath.row - 1 ]
            }
        }
     
        panel!.configs.bounceOnCenterPanelChange = true
        panel!.center(centerNavVC, afterThat: {
            print("Executing block after changing center panelVC From Left Menu")
        })
    }
}

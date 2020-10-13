//
//  AddMenuViewController.swift
//  BarFoodMenu
//
//  Created by Baby on 02.10.2020.
//  Copyright © 2020 bar. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage
import RSLoadingView

class AddMenuViewController: UIViewController {
    
    var ref: DatabaseReference!
    var storageRef = Storage.storage().reference()
    var updatePhoto: String!
    var toUpImage: UIImage!
    var flag : Bool = false

    @IBOutlet weak var addmenuBtn: UIButton!
    @IBOutlet weak var selectPhotoBtn: UIButton!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productCategory: SBMessageInputView!
    @IBOutlet weak var productName: SBMessageInputView!
    @IBOutlet weak var productDetail: SBMessageInputView!
    
    var tapGesture: UITapGestureRecognizer!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        productImg.layer.cornerRadius = 8
        self.addmenuBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x2B95CE).cgColor,Utils.shared.UIColorFromRGB(0x2ECAD5).cgColor])
        
        //Mark  --- textfield refuse begin---
                self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.ViewEndEditing))
                self.tapGesture.numberOfTapsRequired = 1
                self.view.addGestureRecognizer(self.tapGesture)
        //Mark  --- textfield refuse end---
        // Do any additional setup after loading the view.
    }
    @objc func ViewEndEditing() {
        self.view.endEditing(true)
    }
    
    @IBAction func SelectPhoto(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
        self.productImg.image = image
            self.toUpImage = image
            self.flag = true
        }
    }
    
    @IBAction func addMenuBtnAction(_ sender: Any) {
        let loadingView = RSLoadingView()
        loadingView.showOnKeyWindow()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.ref = Database.database().reference()
                    
        if flag == true {
            SharedManager.shared.addmenuFlag = true
            let imageData = self.toUpImage.jpegData(compressionQuality: 0.1)
            let riversRef = self.storageRef.child("ProductImage").child("\(UUID().uuidString)")
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
                    let productID = UUID().uuidString
                    
                    if (self.productCategory.textView?.text)! == "Enter product Category" {
                        
                        RSLoadingView.hideFromKeyWindow()

                        
                        Utils.shared.showAlertWith(title: "Product category is empty!", content: "Please enter product category!", viewController: self)
                        RSLoadingView.hideFromKeyWindow()
                        return
                    }
                    else if (self.productCategory.textView?.text)!.count <= 5 {
                        RSLoadingView.hideFromKeyWindow()

                        Utils.shared.showAlertWith(title: "Product category'content is too weak!", content: "Please enter more characters than 5 !", viewController: self)
                        return
                    }
                    else if (self.productName.textView?.text)! == "Enter product name" {
                        RSLoadingView.hideFromKeyWindow()

                        Utils.shared.showAlertWith(title: "Product name is empty!", content: "Please enter product name!", viewController: self)
                        return
                    }
                    else if (self.productName.textView?.text)!.count <= 5 {
                        RSLoadingView.hideFromKeyWindow()

                        Utils.shared.showAlertWith(title: "Product name'content is too weak!", content: "Please enter more characters than 5 !", viewController: self)
                        return
                    }
                    else if (self.productDetail.textView?.text)! == "Enter product detail" {
                        RSLoadingView.hideFromKeyWindow()

                        Utils.shared.showAlertWith(title: "Product detail is empty!", content: "Please enter product detail!", viewController: self)
                        return
                    }
                    else if (self.productDetail.textView?.text)!.count <= 5 {
                        RSLoadingView.hideFromKeyWindow()

                        Utils.shared.showAlertWith(title: "Product detail'content is too weak!", content: "Please enter more characters than 5 !", viewController: self)
                        return
                    }
                    else {
                        RSLoadingView.hideFromKeyWindow()
                        let alert = UIAlertController(title: "Will you add really this Menu?", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                            self.ref.child("Products/\((self.productCategory.textView?.text)!)/\(productID)").child("productName").setValue((self.productName.textView?.text)!)
                            self.ref.child("Products/\((self.productCategory.textView?.text)!)/\(productID)").child("productDetail").setValue((self.productDetail.textView?.text)!)
                            print((self.productDetail.textView?.text)!)
                            self.ref.child("Products/\((self.productCategory.textView?.text)!)/\(productID)").child("productImage").setValue((self.updatePhoto)!)
                            self.flag = false
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        else {
            RSLoadingView.hideFromKeyWindow()
            Utils.shared.showAlertWith(title: "Product image is empty!", content: "Please enter product image!", viewController: self)
            return
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

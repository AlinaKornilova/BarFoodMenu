//
//  CenterVC.swift
//  FAPanels
//
//  Created by Fahid Attique on 17/06/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//

import UIKit
import FAPanels
import Firebase
import NVActivityIndicatorView
import FirebaseStorage
import FirebaseCore
import FirebaseDatabase
import RSLoadingView

class CenterVC: UIViewController {
    
    var ref: DatabaseReference!
    var selectcount = 0
    var selectedItemNumber = 0
    var selectProducts:[EachProduct] = []
    var wentTodetailFlag : Bool = false

    //  MARK:- Class Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuTitle: UINavigationItem!
    @IBOutlet weak var loadingViewBig: NVActivityIndicatorView!
    @IBOutlet weak var addmenuBtn: UIBarButtonItem!
    
    //  MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadingViewBig.stopAnimating()
        if SharedManager.shared.AllProducts.count == 0 {

            self.readEachProductData()
        }
        else {
            guard let products = SharedManager.shared.AllProducts[SharedManager.shared.selectKey] else { return }
            self.selectProducts = products
            self.selectProducts.sort {
               $0.productName < $1.productName
            }
            self.collectionView.reloadData()
            if SharedManager.shared.selectKey == "AAAAAAAAAA" {
                self.menuTitle.title = "All Menu"
            }
            else if SharedManager.shared.selectKey == "AAAAAAAAAAa" {
                self.menuTitle.title = "Favorite"
            }
            else {
                self.menuTitle.title = SharedManager.shared.selectKey
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if SharedManager.shared.addmenuFlag == false {

            if wentTodetailFlag == true {
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
                guard let products = SharedManager.shared.AllProducts[SharedManager.shared.selectKey] else { return }
                self.selectProducts = products
                self.selectProducts.sort {
                   $0.productName < $1.productName
                }
                self.collectionView.reloadData()
                if SharedManager.shared.selectKey == "AAAAAAAAAA" {
                    self.menuTitle.title = "All Menu"
                }
                else if SharedManager.shared.selectKey == "AAAAAAAAAAa" {
                    self.menuTitle.title = "Favorite"
                }
                else {
                    self.menuTitle.title = SharedManager.shared.selectKey
                }
                wentTodetailFlag = false
            }
        }
        else {
            self.readEachProductData()
            SharedManager.shared.addmenuFlag = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func showLeftVC(_ sender: Any) {
        panel?.openLeft(animated: true)
    }
    
    @IBAction func showRightVC(_ sender: Any) {
           let toAddmenu = self.storyboard?.instantiateViewController(withIdentifier: "AddMenuViewController") as! AddMenuViewController
           self.navigationController?.pushViewController(toAddmenu, animated: true)
    }
    
    func readEachProductData() {
        
        let loadingView = RSLoadingView()
        loadingView.showOnKeyWindow()

            self.ref = Database.database().reference()
            let ProductsCategory = self.ref.child("Products")
            ProductsCategory.observeSingleEvent(of: DataEventType.value , with: { snapshot in
                
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
                            
                            let eachProductDetail = eachProductData["productDetail"] as? String

                            EachCategoryProducts.append(EachProduct(productID: eachProductID!, productName: eachProductName, productImgUrl: eachProductImage!, productDetail: eachProductDetail!, productCategory: eachCategoryName!))
                                    
                            allProductsForAllMenu.append(EachProduct(productID: eachProductID!, productName: eachProductName, productImgUrl: eachProductImage!, productDetail: eachProductDetail!, productCategory: eachCategoryName!))
                        }
                        
                        SharedManager.shared.AllProducts[eachCategoryName!] = EachCategoryProducts
                                
                        if categoryCounter == categoryCount {
                            if SharedManager.shared.didcellflag == false {
                                SharedManager.shared.AllProducts["AAAAAAAAAA"] = allProductsForAllMenu
                                SharedManager.shared.selectKey = "AAAAAAAAAA"
                                guard let products = SharedManager.shared.AllProducts[SharedManager.shared.selectKey] else { return }
                                self.menuTitle.title = "All Menu"
                                self.selectProducts = products
                                self.selectProducts.sort {
                                   $0.productName < $1.productName
                                }
                            }
                            else {
                                print(SharedManager.shared.selectKey)
                                print(SharedManager.shared.AllProducts)
                                SharedManager.shared.AllProducts["AAAAAAAAAA"] = allProductsForAllMenu
                                guard let products = SharedManager.shared.AllProducts[SharedManager.shared.selectKey] else {
                                    
                                    SharedManager.shared.selectKey = "AAAAAAAAAA"
                                    self.menuTitle.title = "All Menu"
                                    guard let productss = SharedManager.shared.AllProducts[SharedManager.shared.selectKey] else {
                                        self.selectProducts.removeAll()
                                        self.collectionView.reloadData()
                                        RSLoadingView.hideFromKeyWindow()
                                        return
                                    }
                                    self.selectProducts = productss
                                    self.collectionView.reloadData()
                                    RSLoadingView.hideFromKeyWindow()
                                    return
                                }
                                
                                if SharedManager.shared.selectKey == "AAAAAAAAAA" {
                                    self.menuTitle.title = "All Menu"
                                }
                                else if SharedManager.shared.selectKey == "AAAAAAAAAAa" {
                                    self.menuTitle.title = "Favorite"
                                }
                                else {
                                    self.menuTitle.title = SharedManager.shared.selectKey
                                }
                                self.selectProducts = products
                                self.selectProducts.sort {
                                   $0.productName < $1.productName
                                }
                                if ( ( self.selectProducts.count == 0 ) && (SharedManager.shared.selectKey != "AAAAAAAAAA")  && (SharedManager.shared.selectKey != "AAAAAAAAAAa") ) {
                                    SharedManager.shared.AllProducts.removeValue(forKey: SharedManager.shared.selectKey)
                                    if let allProducts = SharedManager.shared.AllProducts["AAAAAAAAAA"] {
                                        var count1 = 0
                                        for item in allProducts {
                                            if( item.productCategory == SharedManager.shared.selectKey ) {
                                                SharedManager.shared.AllProducts["AAAAAAAAAA"]?.remove(at: count1)
                                            }
                                            count1 = count1 + 1
                                        }
                                    }
                                    if let allProducts = SharedManager.shared.AllProducts["AAAAAAAAAAa"] {
                                        var count2 = 0
                                        for item in allProducts {
                                            if( item.productCategory == SharedManager.shared.selectKey ) {
                                                SharedManager.shared.AllProducts["AAAAAAAAAAa"]?.remove(at: count2)
                                            }
                                            count2 = count2 + 1
                                        }
                                    }
                                }
                                SharedManager.shared.didcellflag = false
                            }
                            
                            self.collectionView.reloadData()
                            RSLoadingView.hideFromKeyWindow()
                        }
                })
            }
        })
    }
    
}
extension CenterVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.selectProducts.count
     }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath as IndexPath) as! AnnotatedPhotoCell
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.view.addGestureRecognizer(longPressRecognizer)
        cell.eachproduct = self.selectProducts[indexPath.item]

        return cell
        
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
        
     }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("selected item at \(indexPath.row)")
        wentTodetailFlag = true
        selectedItemNumber = indexPath.row
        self.performSegue(withIdentifier: "MenuToDetail", sender: self)
        
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "MenuToDetail" {
            SharedManager.shared.editProductData = selectProducts[selectedItemNumber]
        }

    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .ended {

            let point = sender.location(in: self.collectionView)
            let indexPath = self.collectionView?.indexPathForItem(at: point)
            if indexPath != nil
            {
                let alertActionCell = UIAlertController(title: "Will you really delete this product?", message: "Choose an action for deleting.", preferredStyle: .actionSheet)

                // Configure Remove Item Action
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in                
                    let removeproduct = self.selectProducts[indexPath!.row]
                    self.ref = Database.database().reference()
                    self.ref.child("Products/\(removeproduct.productCategory)/\(removeproduct.productID)").removeValue()
                    SharedManager.shared.didcellflag = true
                    SharedManager.shared.selectKey = removeproduct.productCategory
                    print(SharedManager.shared.selectKey)
                    self.selectProducts.removeAll()
                    print(SharedManager.shared.AllProducts)
                    SharedManager.shared.AllProducts.removeValue(forKey: removeproduct.productCategory)
                    print(SharedManager.shared.AllProducts)
                    self.readEachProductData()
                })

                // Configure Cancel Action Sheet
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { acion in
                    print("Cancel actionsheet")
                })
                
                if let popoverController = alertActionCell.popoverPresentationController {
                    popoverController.sourceView = self.view
                  popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 50, height: 0)
                  popoverController.permittedArrowDirections = []
                }

                alertActionCell.addAction(deleteAction)
                alertActionCell.addAction(cancelAction)
                self.present(alertActionCell, animated: true, completion: nil)

            }
        }
    }
}

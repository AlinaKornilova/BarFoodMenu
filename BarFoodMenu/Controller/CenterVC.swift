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
        //panel?.openRight(animated: true)
    }
    
    func readEachProductData() {
        
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
                            
                            let eachProductDetail = eachProductData["productDetail"] as? String

                            EachCategoryProducts.append(EachProduct(productID: eachProductID!, productName: eachProductName, productImgUrl: eachProductImage!, productDetail: eachProductDetail!, productCategory: eachCategoryName!))
                                    
                            allProductsForAllMenu.append(EachProduct(productID: eachProductID!, productName: eachProductName, productImgUrl: eachProductImage!, productDetail: eachProductDetail!, productCategory: eachCategoryName!))
                        }
                        
                        SharedManager.shared.AllProducts[eachCategoryName!] = EachCategoryProducts
                                
                        if categoryCounter == categoryCount {
                            SharedManager.shared.AllProducts["AAAAAAAAAA"] = allProductsForAllMenu
                            SharedManager.shared.selectKey = "AAAAAAAAAA"
                            guard let products = SharedManager.shared.AllProducts[SharedManager.shared.selectKey] else { return }
                            self.menuTitle.title = "All Menu"
                            self.selectProducts = products
                            self.selectProducts.sort {
                               $0.productName < $1.productName
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
            let DetailView = segue.destination as! ProductDetailViewController
            DetailView.productData = self.selectProducts[selectedItemNumber]
        }
        
    }
    
}

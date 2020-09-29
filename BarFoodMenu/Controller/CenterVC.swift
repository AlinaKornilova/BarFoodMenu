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

class CenterVC: UIViewController {
    
    var ref: DatabaseReference!
    var selectcount = 0
    var selectedItemNumber = 0
    var selectProducts:[EachProduct] = []

    //  MARK:- Class Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuTitle: UINavigationItem!
    @IBOutlet weak var loadingViewBig: NVActivityIndicatorView!

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
            self.collectionView.reloadData()
            if SharedManager.shared.selectKey == "AAAAAAAAAA" {
                self.menuTitle.title = "All Menu"
            }
            else {
                self.menuTitle.title = SharedManager.shared.selectKey
            }
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
        panel?.openRight(animated: true)
    }
    
    func readEachProductData() {
        
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
                            
                            let eachProductPrice = eachProductData["productPrice"] as! String
                            let eachProductRating = eachProductData["productRating"] as! NSNumber
                            let eachProductDetail = eachProductData["productDetail"] as! String
                            let eachProductViewer = eachProductData["productViewer"] as! NSNumber

                            EachCategoryProducts.append(EachProduct(productID: eachProductID!, productName: eachProductName, productImgUrl: eachProductImage!,  productPrice: eachProductPrice, productRating: Double(eachProductRating), productDetail: eachProductDetail, productViewer: Int( eachProductViewer ), productCategory: eachCategoryName!))
                                    
                            allProductsForAllMenu.append(EachProduct(productID: eachProductID!, productName: eachProductName, productImgUrl: eachProductImage!,  productPrice: eachProductPrice, productRating: Double(eachProductRating), productDetail: eachProductDetail, productViewer: Int( eachProductViewer ), productCategory: eachCategoryName!))
                        }
                        
                        SharedManager.shared.AllProducts[eachCategoryName!] = EachCategoryProducts
                                
                        if categoryCounter == categoryCount {
                            SharedManager.shared.AllProducts["AAAAAAAAAA"] = allProductsForAllMenu
                            SharedManager.shared.selectKey = "AAAAAAAAAA"
                            guard let products = SharedManager.shared.AllProducts[SharedManager.shared.selectKey] else { return }
                            self.menuTitle.title = "All Menu"
                            self.selectProducts = products
                            self.collectionView.reloadData()
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

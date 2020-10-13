//
//  EachProduct.swift
//  e-search
//
//  Created by Baby on 13.08.2020.
//  Copyright © 2020 Baby. All rights reserved.
//


import Foundation


class EachProduct {
    var productID: String
    var productName: String
    var productImgUrl: String
//    var productRating: Double
    var productDetail: String
//    var productViewer: Int
    var productCategory: String
    
    init(productID: String, productName: String, productImgUrl: String,  productDetail: String, productCategory: String) {
        self.productID = productID
        self.productName = productName
        self.productImgUrl = productImgUrl
//        self.productRating = productRating
        self.productDetail =  productDetail
//        self.productViewer = productViewer
        self.productCategory = productCategory
    }
}

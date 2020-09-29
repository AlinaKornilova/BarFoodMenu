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
    var productPrice: String
    var productRating: Double
    var productDetail: String
    var productViewer: Int
    
    init(productID: String, productName: String, productImgUrl: String, productPrice: String, productRating: Double, productDetail: String, productViewer: Int) {
        self.productID = productID
        self.productName = productName
        self.productImgUrl = productImgUrl
        self.productPrice = productPrice
        self.productRating = productRating
        self.productDetail =  productDetail
        self.productViewer = productViewer
    }
}

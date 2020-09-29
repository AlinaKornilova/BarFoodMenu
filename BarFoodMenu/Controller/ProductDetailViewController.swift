//
//  ProductDetailViewController.swift
//  BarFoodMenu
//
//  Created by Baby on 20.09.2020.
//  Copyright © 2020 bar. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class ProductDetailViewController: UIViewController {
    
    var productData : EachProduct!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDetail: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var popularStar: CosmosView!
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productRating: UILabel!
    @IBOutlet weak var prodcutViewers: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productImg.layer.cornerRadius = 10
        productName.text = productData.productName
        productPrice.text = productData.productPrice
        productDetail.text = productData.productDetail
        productRating.text = String(productData.productRating)
        prodcutViewers.text = String(productData.productViewer)
        
        let url = URL(string: productData.productImgUrl)!
        self.productImg.sd_setImage(with: url, placeholderImage: UIImage(named: "noImg"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            if( error != nil)
            {
                print("Error while displaying image" , (error?.localizedDescription)! as String)
            }
        })
        
        self.feedbackBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x2B95CE).cgColor,Utils.shared.UIColorFromRGB(0x2ECAD5).cgColor])
        self.favoriteBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x2B95CE).cgColor,Utils.shared.UIColorFromRGB(0x2ECAD5).cgColor])
        
        popularStar.rating = productData.productRating
        popularStar.settings.fillMode = .precise
        popularStar.settings.starSize = 25
        
        // Set the color of a filled star
        popularStar.settings.filledColor = UIColor.orange

        // Set the border color of an empty star
        popularStar.settings.emptyBorderColor = UIColor.orange

        // Set the border color of a filled star
        popularStar.settings.filledBorderColor = UIColor.orange
        // Do any additional setup after loading the view.
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
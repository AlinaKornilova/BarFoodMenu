//
//  Utils.swift
//  theMath
//
//  Created by Talent on 18.05.2020.
//  Copyright © 2020 Atlanta. All rights reserved.
//
import Foundation
import UIKit

class Utils {
    static let shared = Utils()
    
    func showAlertWith(title: String, content: String, viewController: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
        alertController.addAction(defaultAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF)))/255.0, alpha: 1.0)
    }
}

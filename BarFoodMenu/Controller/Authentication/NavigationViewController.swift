//
//  NavigationViewController.swift
//  theMath
//
//  Created by Talent on 18.05.2020.
//  Copyright © 2020 Atlanta. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let toLogin = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! NavigationViewController
        self.navigationController?.pushViewController(toLogin, animated: true)
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

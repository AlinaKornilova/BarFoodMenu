//
//  LeftMenuVC.swift
//  FAPanels
//
//  Created by Fahid Attique on 17/06/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//

import UIKit
import FAPanels

class LeftMenuVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
     override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func viewConfigurations() {
        
        tableView.register(UINib.init(nibName: "LeftMenuCell", bundle: nil), forCellReuseIdentifier: "LeftMenuCell")
    }
}

extension LeftMenuVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SharedManager.shared.AllProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell") as! LeftMenuCell
        
        if indexPath.row == 0 {
            
            cell.menuOption.text = "All Menu"
        }
        else {
            cell.menuOption.text = (Array(SharedManager.shared.AllProducts.keys).sorted(by: <))[indexPath.row ]
        }

        cell.menuImage.image = UIImage(named: "icons" + String( indexPath.row ))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "CenterVC")
        let centerNavVC = UINavigationController(rootViewController: centerVC)
        SharedManager.shared.selectKey = (Array(SharedManager.shared.AllProducts.keys).sorted(by: <))[indexPath.row]
        
        panel!.configs.bounceOnCenterPanelChange = true
        panel!.center(centerNavVC, afterThat: {
            print("Executing block after changing center panelVC From Left Menu")
        })
    }
}

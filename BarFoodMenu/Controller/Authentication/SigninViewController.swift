//
//  SigninViewController.swift
//  theMath
//
//  Created by Talent on 13.05.2020.
//  Copyright © 2020 Atlanta. All rights reserved.
//

import UIKit
import FirebaseAuth
import RSLoadingView
import FAPanels

class SigninViewController: UIViewController {

    @IBOutlet weak var userEmail_SI: UITextField!
    @IBOutlet weak var userPassword_SI: UITextField!
    @IBOutlet weak var SigninBtn: UIButton!
    @IBOutlet weak var toSignupBtn: UIButton!
    @IBOutlet weak var ForgotBtn: UIButton!
    
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//Mark  --- toSignup button begin---
        if UIDevice.current.userInterfaceIdiom == .pad {
            
             print("iPad")
             let attributedString_toSignupBtn = NSAttributedString(string: NSLocalizedString("Create a new account?", comment: ""), attributes:[
                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23),
                 NSAttributedString.Key.foregroundColor : UIColor.cyan,
                 NSAttributedString.Key.underlineStyle:1.0
             ])
             toSignupBtn.setAttributedTitle(attributedString_toSignupBtn, for: .normal)
             self.view.addSubview(toSignupBtn)
            
         }
        else {
            
            print("not iPad")
            let attributedString_toSignupBtn = NSAttributedString(string: NSLocalizedString("Create a new account?", comment: ""), attributes:[
                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor : UIColor.cyan,
                 NSAttributedString.Key.underlineStyle:1.0
             ])
             toSignupBtn.setAttributedTitle(attributedString_toSignupBtn, for: .normal)
             self.view.addSubview(toSignupBtn)
        }
//Mark  --- toSignup button end---
//Mark  --- Forgot button begin---
        if UIDevice.current.userInterfaceIdiom == .pad {
             print("iPad")
             let attributedString_ForgotBtn = NSAttributedString(string: NSLocalizedString("Forgot password?", comment: ""), attributes:[
                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: 21),
                 NSAttributedString.Key.underlineStyle:1.0
             ])
             ForgotBtn.setAttributedTitle(attributedString_ForgotBtn, for: .normal)
             self.view.addSubview(ForgotBtn)
         }
        else {
            print("not iPad")
            let attributedString_ForgotBtn = NSAttributedString(string: NSLocalizedString("Forgot password?", comment: ""), attributes:[
                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
                 NSAttributedString.Key.underlineStyle:1.0
             ])
             ForgotBtn.setAttributedTitle(attributedString_ForgotBtn, for: .normal)
             self.view.addSubview(ForgotBtn)
        }
//Mark  --- Forgot button begin---
//Mark  --- Sign button round begin---
        self.SigninBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x2B95CE).cgColor,Utils.shared.UIColorFromRGB(0x2ECAD5).cgColor])
//Mark  --- Sign button round end---
//Mark  --- textfield refuse begin---
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.ViewEndEditing))
        self.tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(self.tapGesture)
//Mark  --- textfield refuse end---
    }
    
    @objc func ViewEndEditing() {
        self.view.endEditing(true)
    }
    
    @IBAction func SigninAction(_ sender: Any) {
        let loadingView = RSLoadingView()
        loadingView.showOnKeyWindow()
        guard let email = userEmail_SI.text else {
            // alert
            return
        }
        guard let password = userPassword_SI.text else {
            // alert
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
           if error == nil {
                RSLoadingView.hideFromKeyWindow()
                if password == "111111" && email == "test1@test.com" {
                    SharedManager.shared.admin = true
                }
                self.createFAPanels()
           }
           else {
                RSLoadingView.hideFromKeyWindow()
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)

                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func toSignupAction(_ sender: Any) {
        let toSignup = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        UIApplication.shared.windows.first?.rootViewController = toSignup
        UIApplication.shared.windows.first?.makeKeyAndVisible()
//        self.navigationController?.pushViewController(toSignup, animated: true)

    }
    
    @IBAction func resetPassFunc(_ sender : Any) {
        
        if userEmail_SI.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please Enter Email", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(alertAction)
            present(alertController , animated: true, completion:  nil)
        }
        else {
            Auth.auth().sendPasswordReset(withEmail: userEmail_SI.text!) {
                error in
                if  error != nil {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(alertAction)
                    self.present(alertController , animated: true, completion:  nil)
                }
                else {
                    let alertController = UIAlertController(title: "Please check your email!", message: "We have sent you email the link into your inbox to recover your password.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(alertAction)
                    self.present(alertController , animated: true, completion:  nil)
                }
            }
        }
    }
    
    func createFAPanels() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let leftMenuVC: LeftMenuVC = mainStoryboard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
        let righttMenuVC: RightMenuVC = mainStoryboard.instantiateViewController(withIdentifier: "RightMenuVC") as! RightMenuVC
        let centerVC: CenterVC = mainStoryboard.instantiateViewController(withIdentifier: "CenterVC") as! CenterVC
        let centerNavVC = UINavigationController(rootViewController: centerVC)

        //  Case 2: With Xtoryboards, Xibs And NSCoder
        let rootController: FAPanelController = FAPanelController()
        rootController.configs.rightPanelWidth = 150
        rootController.configs.bounceOnRightPanelOpen = false

        _ = rootController.center(centerNavVC).left(leftMenuVC).right(righttMenuVC)
        UIApplication.shared.windows.first?.rootViewController = rootController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }    
}

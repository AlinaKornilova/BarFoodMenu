//
//  SignupViewController.swift
//  theMath
//
//  Created by Talent on 13.05.2020.
//  Copyright © 2020 Atlanta. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import RSLoadingView
import FAPanels

class SignupViewController: UIViewController {
    
    //Mark swift - storyboard start
   
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userConfirmPassword: UITextField!
    @IBOutlet weak var toSigninBtn: UIButton!
    @IBOutlet weak var SignupBtn: UIButton!
    
    var userGroup_value : String! = ""
    let firebaseUpload = FirebaseUpload()
    var tapGesture: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

//Mark  SignupBtn Style start
        self.SignupBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x2B95CE).cgColor,Utils.shared.UIColorFromRGB(0x2ECAD5).cgColor])
//Mark  SignupBtn Style end
//Mark  --- toSignin button begin---
        if UIDevice.current.userInterfaceIdiom == .pad {
             print("iPad")
             let attributedString = NSAttributedString(string: NSLocalizedString("Already have an account?", comment: ""), attributes:[
                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23),
                 NSAttributedString.Key.foregroundColor : UIColor.cyan,
                 NSAttributedString.Key.underlineStyle:1.0
             ])
            toSigninBtn.setAttributedTitle(attributedString, for: .normal)
            self.view.addSubview(toSigninBtn)
         }
        else {
             print("not iPad")
             let attributedString = NSAttributedString(string: NSLocalizedString("Already have an account?", comment: ""), attributes:[
                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor : UIColor.cyan,
                 NSAttributedString.Key.underlineStyle:1.0
             ])
            toSigninBtn.setAttributedTitle(attributedString, for: .normal)
            self.view.addSubview(toSigninBtn)
         }
        //Mark  --- textfield refuse begin---
                self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.ViewEndEditing))
                self.tapGesture.numberOfTapsRequired = 1
                self.view.addGestureRecognizer(self.tapGesture)
        //Mark  --- textfield refuse end---
    }
    
    @objc func ViewEndEditing() {
        self.view.endEditing(true)
    }
    
    @IBAction func signupAction(_ sender: Any) {
        
        if userName.text == "" {
            Utils.shared.showAlertWith(title: "Name is empty!", content: "Please enter your name!", viewController: self)
            return
        }
        
        if userEmail.text == "" {
            Utils.shared.showAlertWith(title: "Email is empty!", content: "Please enter your email!", viewController: self)
            return
        }
        
        if userPassword.text == "" {
            Utils.shared.showAlertWith(title: "Password is empty!", content: "Please enter your password!", viewController: self)
            return
        }
        
        if userConfirmPassword.text == "" {
            Utils.shared.showAlertWith(title: "ConfirmPassword is empty!", content: "Please confirm your password!", viewController: self)
            return
        }
        
        if userPassword.text != userConfirmPassword.text {
            Utils.shared.showAlertWith(title: "Password incorrect!", content: "Please re-type password", viewController: self)
            return
        }

        let loadingView = RSLoadingView()
        loadingView.showOnKeyWindow()
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!) { authResult, error in
            
            if(error != nil) {
                print(error as Any)
                RSLoadingView.hideFromKeyWindow()
                Utils.shared.showAlertWith(title: "Error occured!", content: error?.localizedDescription ?? "error!!!!", viewController: self)
                return
            }
            print("created")
            
            let userInformation: NSDictionary = ["userName": self.userName.text!, "userEmail": self.userEmail.text!, "userPassword": self.userPassword.text!, "userProfile" : "https://firebasestorage.googleapis.com/v0/b/bar-menu-74786.appspot.com/o/ProductImage%2FdefaultAvatar.png?alt=media&token=e5cafb82-2e1c-427f-a250-2d77664c4375"]
            self.firebaseUpload.UpdateUserInfo(with: userInformation) { (error) in
                if let error = error {
                    RSLoadingView.hideFromKeyWindow()
                    Utils.shared.showAlertWith(title: "Error occured!", content: error.localizedDescription, viewController: self)
                    return
                }
                RSLoadingView.hideFromKeyWindow()
                if self.userPassword.text! == "111111" && self.userEmail.text! == "admin@test.com" {
                    SharedManager.shared.admin = true
                }
                self.createFAPanels()
            }
        }
    }
    
    @IBAction func toSigninAction(_ sender: Any) {
        let toSignin = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        UIApplication.shared.windows.first?.rootViewController = toSignin
        UIApplication.shared.windows.first?.makeKeyAndVisible()
//        self.navigationController?.popViewController(animated: true)
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
//extension SignupViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        if textField == self.userConfirmPassword {
//            self.view.endEditing(true)
//        }
//
//    }
//
//}

//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
//      tap.cancelsTouchesInView = false
//      view.addGestureRecognizer(tap)
//    }
//    @objc func dismissKeyboard() {
//       view.endEditing(true)
//    }
//}

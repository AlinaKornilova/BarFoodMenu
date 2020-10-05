//
//  WriteFeedbackViewController.swift
//  BarFoodMenu
//
//  Created by Baby on 02.10.2020.
//  Copyright © 2020 bar. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import FirebaseStorage
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class WriteFeedbackViewController: UIViewController {
    
    var giveProductCategory :  String!
    var giveProductID :  String!
    var giveUserName : String!
    var giveUserPhoto : String!
    var giveCount : Int!
    var giveAverageRate : Double!
    
    var ref: DatabaseReference!


    @IBOutlet weak var giveStar: CosmosView!
    @IBOutlet weak var giveTitle: SBMessageInputView!
    @IBOutlet weak var giveContent: SBMessageInputView!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        giveStar.settings.fillMode = .precise
        giveStar.settings.starSize = 35
        giveStar.settings.filledColor = UIColor.orange
        giveStar.settings.emptyBorderColor = UIColor.orange
        giveStar.settings.filledBorderColor = UIColor.orange
        
        submitBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x2B95CE).cgColor,Utils.shared.UIColorFromRGB(0x2ECAD5).cgColor])
        
        self.ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.ref.child("USERS/\(userID)").observeSingleEvent(of: DataEventType.value , with: { snapshot in
            let value = snapshot.value as? NSDictionary
            self.giveUserName = value?["userName"] as? String ?? ""
                self.giveUserPhoto = value?["userProfile"] as? String ?? ""
          })
        
        // Do any additional setup after loading the view.
    }
    @IBAction func toFeedbsksAction(_ sender: Any) {

        if (giveTitle.textView?.text)! == "Enter feedback title" {
            Utils.shared.showAlertWith(title: "Feedback's title is empty!", content: "Please enter your feedback's title!", viewController: self)
            return
        }
        else if (giveTitle.textView?.text)!.count < 10 {
            Utils.shared.showAlertWith(title: "Feedback's title is too weak", content: "Please enter more characters than 10 !", viewController: self)
                return
        }
        else if (giveContent.textView?.text)! == "Enter feedback content" {
            Utils.shared.showAlertWith(title: "Feedback's content is empty!", content: "Please enter your feedback's content!", viewController: self)
            return
        }
        else if (giveContent.textView?.text)!.count < 10 {
            Utils.shared.showAlertWith(title: "Feedback's content is too weak", content: "Please enter more characters than 10 !", viewController: self)
                return
            }
        else {
            giveCount = SharedManager.shared.selectedProductViewers
            giveAverageRate = SharedManager.shared.selectedProdcutRating
            let givestarrate = giveStar.rating
            let giveTime = Date().millisecondsSince1970
            self.ref = Database.database().reference()
            self.ref.child("Products/\(giveProductCategory!)/\(giveProductID!)/productFeedback/\(giveTime)/feedbackContent").setValue(NSString(string: (giveContent.textView?.text)!))
            self.ref.child("Products/\(giveProductCategory!)/\(giveProductID!)/productFeedback/\(giveTime)/feedbackTitle").setValue(NSString(string: (giveTitle.textView?.text)!))
            self.ref.child("Products/\(giveProductCategory!)/\(giveProductID!)/productFeedback/\(giveTime)/feedbackUserName").setValue(NSString(utf8String: giveUserName))
            self.ref.child("Products/\(giveProductCategory!)/\(giveProductID!)/productFeedback/\(giveTime)/feedbackUserPhoto").setValue(NSString(utf8String: giveUserPhoto))
            self.ref.child("Products/\(giveProductCategory!)/\(giveProductID!)/productFeedback/\(giveTime)/feedbackRate").setValue(NSNumber(value: givestarrate))
            self.ref.child("Products/\(giveProductCategory!)/\(giveProductID!)/productViewer").setValue(giveCount + 1)
            let updateTotalRate = Double(giveCount) * giveAverageRate + givestarrate
            let updateRate = updateTotalRate / Double(giveCount + 1)
            SharedManager.shared.selectedProdcutRating = updateRate
            SharedManager.shared.selectedProductViewers = giveCount + 1
            self.ref.child("Products/\(giveProductCategory!)/\(giveProductID!)/productRating").setValue(NSNumber(value: updateRate))
            self.navigationController?.popViewController(animated: true)        }
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

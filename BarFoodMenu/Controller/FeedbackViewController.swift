//
//  FavoriteViewController.swift
//  BarFoodMenu
//
//  Created by Baby on 29.09.2020.
//  Copyright © 2020 bar. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage

class FeedbackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference!
    var feedbackProductName : String!
    var feedbackProductID : String!
    var feedbackProductCategory : String!
    var feedbacksCount : Int!
    var feedbackAverateRate : Double!
    var EachProductFeedbacks: [EachFeedback] = []
    
    @IBOutlet weak var feedbackProductLbl: UILabel!
    @IBOutlet weak var feedbackAddBtn: UIButton!
    @IBOutlet weak var feedbacksTV: UITableView!
    @IBOutlet weak var noResult: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedbacksTV.delegate = self
        self.feedbacksTV.dataSource = self
        // Do any additional setup after loading the view.
        feedbackProductLbl.text = feedbackProductName
        
        feedbackAddBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x2B95CE).cgColor,Utils.shared.UIColorFromRGB(0x2ECAD5).cgColor])
        
        feedbacksTV.backgroundColor = .red
    }
    override func viewWillAppear(_ animated: Bool) {
        readEachFeedbackData()

    }
    func readEachFeedbackData() {
        
        self.ref = Database.database().reference()
        let EachProductFeedbacks = self.ref.child("Products/\(feedbackProductCategory!)/\(feedbackProductID!)/productFeedback/")
            EachProductFeedbacks.observeSingleEvent(of: DataEventType.value , with: { snapshot in
                let feedbackCount =  snapshot.childrenCount
                var feedbackCounter = 0
                self.EachProductFeedbacks.removeAll()
                
                for item in snapshot.children {
                    feedbackCounter = feedbackCounter + 1
                    
                    let eachProducteachFeedbackAllData = item as! DataSnapshot
                    let eachProducteachFeedbackID = eachProducteachFeedbackAllData.key as String?
                    let eachProducteachFeedbackData = eachProducteachFeedbackAllData.value as! NSDictionary
                    let eachProducteachFeedbackUserName = eachProducteachFeedbackData["feedbackUserName"] as! String
                    var eachProducteachFeedbackUserPhoto: String?
                    if let eachProducteachFeedbackUserPhoto1 = eachProducteachFeedbackData["feedbackUserPhoto"] as? String { eachProducteachFeedbackUserPhoto = eachProducteachFeedbackUserPhoto1
                    }
                    let eachProducteachFeedbackTitle = eachProducteachFeedbackData["feedbackTitle"] as! String
                    let eachProducteachFeedbackContent = eachProducteachFeedbackData["feedbackContent"] as! String
                    let eachProducteachFeedbackRate = eachProducteachFeedbackData["feedbackRate"] as! NSNumber
                    
                    self.EachProductFeedbacks.append(EachFeedback(FeedbackDate: eachProducteachFeedbackID!, FeedbackUserName: eachProducteachFeedbackUserName, FeedbackUserPhoto: eachProducteachFeedbackUserPhoto!, FeedbackRate: Double(eachProducteachFeedbackRate), FeedbackTitle: eachProducteachFeedbackTitle, FeedbackContent: eachProducteachFeedbackContent))
                }
                if feedbackCounter == feedbackCount {
                    self.EachProductFeedbacks.sort {
                       $0.FeedbackDate > $1.FeedbackDate
                    }
                    self.animateTable()
                }
        })
    }
    func animateTable() {

        self.feedbacksTV.reloadData()
            
        let cells = feedbacksTV.visibleCells
        let tableHeight: CGFloat = feedbacksTV.bounds.size.height
            
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
            
        var index = 0
            
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 2.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions.transitionFlipFromRight, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
                
            index += 1
        }
    }
    @IBAction func toWriteAction(_ sender: Any) {
        let toWrite = self.storyboard?.instantiateViewController(withIdentifier: "WriteFeedbackViewController") as! WriteFeedbackViewController
        toWrite.giveProductCategory = feedbackProductCategory
        toWrite.giveProductID = feedbackProductID
     
        self.navigationController?.pushViewController(toWrite, animated: true)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = UIColor.lightGray
        return EachProductFeedbacks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackTableViewCell", for: indexPath) as! FeedbackTableViewCell
        
        let url = URL(string: EachProductFeedbacks[indexPath.row].FeedbackUserPhoto)!
        print(url)
        cell.feedbackUserPhoto.sd_setImage(with: url, placeholderImage: UIImage(named: "noImg"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            if( error != nil)
            {
                print("Error while displaying image" , (error?.localizedDescription)! as String)
            }
        })
        cell.feedbackUserPhoto.layer.masksToBounds = true
        cell.feedbackUserPhoto.layer.cornerRadius = cell.feedbackUserPhoto.bounds.width / 2
        
        cell.feedbackUserName.text = EachProductFeedbacks[indexPath.row].FeedbackUserName
        let originDateTime = Date(milliseconds: Int64(EachProductFeedbacks[indexPath.row].FeedbackDate) ?? 0 )
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy"
        let feedbackDateChar = formatter.string(from: originDateTime)
        cell.feedbackDate.text = feedbackDateChar
        
        cell.feedbackStar.rating = EachProductFeedbacks[indexPath.row].FeedbackRate
        cell.feedbackStar.settings.fillMode = .precise
        cell.feedbackStar.settings.starSize = 25
        cell.feedbackStar.settings.filledColor = UIColor.orange
        cell.feedbackStar.settings.emptyBorderColor = UIColor.orange
        cell.feedbackStar.settings.filledBorderColor = UIColor.orange
        
        
        let titleAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20.0) as Any]
        let contentAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Avenir-Light", size: 18.0) as Any]
        let titleString = NSMutableAttributedString(string: " \(EachProductFeedbacks[indexPath.row].FeedbackTitle)", attributes: titleAttributes)
        let contentString = NSAttributedString(string: "\n\(EachProductFeedbacks[indexPath.row].FeedbackContent)", attributes: contentAttributes)
        titleString.append(contentString)
        cell.feedbackContent.attributedText = titleString
        
        cell.cellGroup.layer.cornerRadius = 8
        cell.layer.backgroundColor = UIColor.clear.cgColor
        feedbacksTV.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        feedbacksTV.separatorColor = UIColor.clear
        return cell
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

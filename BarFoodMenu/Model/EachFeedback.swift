//
//  EachFeedback.swift
//  BarFoodMenu
//
//  Created by Baby on 30.09.2020.
//  Copyright © 2020 bar. All rights reserved.
//

import Foundation

class EachFeedback {
    var FeedbackDate: String
    var FeedbackUserName: String
    var FeedbackUserPhoto: String
//    var FeedbackRate: Double
    var FeedbackTitle: String
    var FeedbackContent: String
    
    init(FeedbackDate: String, FeedbackUserName: String, FeedbackUserPhoto: String, FeedbackTitle: String, FeedbackContent: String) {
        self.FeedbackDate = FeedbackDate
        self.FeedbackUserName = FeedbackUserName
        self.FeedbackUserPhoto = FeedbackUserPhoto
//        self.FeedbackRate = FeedbackRate
        self.FeedbackTitle = FeedbackTitle
        self.FeedbackContent = FeedbackContent
    }
}

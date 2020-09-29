//
//  File.swift
//  theMath
//
//  Created by Talent on 23.05.2020.
//  Copyright © 2020 Ron. All rights reserved.
//

import Foundation
class EachUser {
    var userID: String
    var userName: String
    var userProfile: String?
    
    init(userID: String, userName: String, userProfile: String?) {
        self.userID = userID
        self.userName = userName
        self.userProfile = userProfile
    }
}

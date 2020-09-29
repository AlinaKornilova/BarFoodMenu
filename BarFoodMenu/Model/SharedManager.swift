//
//  SharedManager.swift
//  WLIDrawer-IOS
//
//  Created by Baby on 20.09.2020.
//  Copyright © 2020 Webline india. All rights reserved.
//

import Foundation
import UIKit

class SharedManager {
    static let shared = SharedManager()
    
    var AllProducts:[String:[EachProduct]] = [String:[EachProduct]]()
    var selectKey: String = ""
    var selectcount: Int = 0
}

//
//  SInce1970.swift
//  Mental
//
//  Created by Talent on 22.04.2020.
//  Copyright © 2020 Renata. All rights reserved.
//

import UIKit
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970)*1000)
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds)/1000 )
    }
}

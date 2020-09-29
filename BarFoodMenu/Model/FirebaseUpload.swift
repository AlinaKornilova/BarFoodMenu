//
//  FirebaseUpload.swift
//  Gusto
//
//  Copyright 2018, Spark Anvil LLC. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseCore

class FirebaseUpload {
    
    var ref: DatabaseReference!
    
    func UpdateUserInfo(with resArray: NSDictionary, results: @escaping (_ error: Error?) -> ()) {
        self.ref = Database.database().reference()       
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let child = ["USERS/\(userID)/": resArray]
        self.ref.updateChildValues(child, withCompletionBlock: { (error, ref) in
            guard let error = error else {
                results(nil)
                return
            }
            results(error)
        })
    }
}

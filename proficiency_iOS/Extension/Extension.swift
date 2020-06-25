//
//  Extension.swift
//  proficiency_iOS
//
//  Created by Mahesh Miriyam on 25/06/20.
//  Copyright © 2020 Mahesh Miriyam. All rights reserved.
//

import UIKit
extension UIDevice{
    func isIPAD() -> Bool{
        if UIDevice.current.userInterfaceIdiom == .pad {
           return true
        }
        return false
    }
    
}

extension UICollectionViewCell{
    class var reuseIdentifier:String{
        return "\(self)"
    }
}

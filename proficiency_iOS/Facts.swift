//
//  Facts.swift
//  proficiency_iOS
//
//  Created by Mahesh Miriyam on 25/06/20.
//  Copyright © 2020 Mahesh Miriyam. All rights reserved.
//

import UIKit

struct Facts:Decodable {
    var title:String
    var rows:[Rows]
}

struct Rows:Decodable {
    var title:String?
    var description:String?
    var imageHref:String?
}

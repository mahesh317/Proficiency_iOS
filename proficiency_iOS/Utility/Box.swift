//
//  Box.swift
//  proficiency_iOS
//
//  Created by Mahesh Miriyam on 25/06/20.
//  Copyright © 2020 Mahesh Miriyam. All rights reserved.
//

import Foundation

class Box<T> {
    
    private var bindHandler:((T) -> ())?
    var value:T{
        didSet{
            bindHandler?(value)
        }
    }
    
    init(_ value:T) {
        self.value = value
    }
    
    func bind(_ listener:((T) -> ())?)  {
        self.bindHandler = listener
        listener?(value)
    }
    
}

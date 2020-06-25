//
//  FactsViewModel.swift
//  proficiency_iOS
//
//  Created by Mahesh Miriyam on 25/06/20.
//  Copyright © 2020 Mahesh Miriyam. All rights reserved.
//

import UIKit

class FactsViewModel {
    var title :Box<String?> = Box(nil)
    var datasourceRows:Box<[RowViewModel]> = Box([])
    var error : Box<Error?> = Box(nil)
    var rows:[Rows] = []
    
    
    init() {
        self.getFactsDataSource()
    }
    
    // get image url
    func getImageUrl(_ indexPath:IndexPath) -> URL?{
        if indexPath.row < self.datasourceRows.value.count {
            if let imageHref = self.rows[indexPath.row].imageHref{
                return URL(string: imageHref)
            }
            return nil
        }
        return nil
    }
    
    
    // fetch Phots from API
    func getFactsDataSource() {
        ServiceManager.sharedInstance.getFacts { (result) in
            switch result {
            case .success(let facts):
                self.title.value = facts.title
                self.rows = facts.rows
                self.datasourceRows.value = self.rows.map({ RowViewModel($0)})
            case .failure(let error): self.error.value = error
            }
        }
    }
}

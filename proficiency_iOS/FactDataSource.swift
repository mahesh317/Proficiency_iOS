//
//  FactDataSource.swift
//  proficiency_iOS
//
//  Created by Mahesh Miriyam on 25/06/20.
//  Copyright © 2020 Mahesh Miriyam. All rights reserved.
//

import UIKit

class FactDataSource: NSObject, UICollectionViewDataSource {
    
    private var rows:[RowViewModel] = []
    
    func updateRows(_ rows:[RowViewModel]){
        self.rows = rows
    }
    
    func updateRowImage(_ image:UIImage?, forRow row:Int) -> Bool{
        let item = self.rows[row]
        if item.image == UIImage(named: "placeholder"){
            item.updateImage(image)
            return true
        }
        return false
                
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FactsCollectionViewCell.reuseIdentifier, for: indexPath) as! FactsCollectionViewCell
        cell.configure(rows[indexPath.row])
        return cell
    }
}

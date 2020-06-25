//
//  FactDataSource.swift
//  proficiency_iOS
//
//  Created by Mahesh Miriyam on 25/06/20.
//  Copyright © 2020 Mahesh Miriyam. All rights reserved.
//

import UIKit

class FactDataSource: NSObject, UICollectionViewDataSource {
    
    private var rows:[Rows] = []
    
    func updateRows(_ rows:[Rows]){
        self.rows = rows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FactsCollectionViewCell.reuseIdentifier, for: indexPath) as! FactsCollectionViewCell
        
        return cell
    }

}

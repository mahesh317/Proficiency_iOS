//
//  ViewController.swift
//  proficiency_iOS
//
//  Created by Mahesh Miriyam on 24/06/20.
//  Copyright © 2020 Mahesh Miriyam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionViewDatasource = FactDataSource()
    var collectionView:UICollectionView!
    var factViewModel = FactsViewModel()
    
    override func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = .white
        self.createCollectionView()
    }
    
    func bindUI()  {
        factViewModel.title.bind { [weak self](name) in
            if let titlename = name{
                DispatchQueue.main.async {
                    self?.title = titlename
                }
            }
        }
        
        factViewModel.error.bind { [weak self] (error) in
            if let error = error{
                DispatchQueue.main.async {
                    self?.showAlert(forError: error)
                }
            }
        }
        
        factViewModel.datasourceRows.bind { [weak self](rows) in
            self?.collectionViewDatasource.updateRows(rows)
            if rows.count > 0 {
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    func retryClicked(){
        factViewModel.getFactsDataSource()
    }
    func showAlert(forError error:Error){
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .destructive, handler: { (action) in
            self.retryClicked()
            alert.dismiss(animated: true, completion: nil)
        }))
        
            present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func createCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()

        // Now setup the flowLayout required for drawing the cells
        let space = 5.0 as CGFloat

        // Set view cell size
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)

        // Set left and right margins
        flowLayout.minimumInteritemSpacing = space

        // Set top and bottom margins
        flowLayout.minimumLineSpacing = space

        // Finally create the CollectionView
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)

        // Then setup delegates, background color etc.
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.insetsLayoutMarginsFromSafeArea = true
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        collectionView.backgroundColor = .red
        collectionView.dataSource = collectionViewDatasource
        
        
        view.layoutIfNeeded()
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


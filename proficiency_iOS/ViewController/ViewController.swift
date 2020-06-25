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
    var imageDownloaders = Set<ImageDownloader>()
    let flowLayout = UICollectionViewFlowLayout()
    var refreshControl:UIRefreshControl!

    override func loadView() {
        super.loadView()
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = .white
        refreshControl = UIRefreshControl()
        self.createCollectionView()
        

    }
    
    func createCollectionView() {
        

        // Now setup the flowLayout required for drawing the cells
        let space = 5.0 as CGFloat

        // Set view cell size
//        flowLayout.itemSize = FactsCollectionViewCell.CellSize

        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        // Set left and right margins
        flowLayout.minimumInteritemSpacing = space

        // Set top and bottom margins
        flowLayout.minimumLineSpacing = space
        

        // Finally create the CollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        // Then setup delegates, background color etc.
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.insetsLayoutMarginsFromSafeArea = true
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        collectionView.dataSource = collectionViewDatasource
        collectionView.delegate = self
        collectionView.register(FactsCollectionViewCell.self, forCellWithReuseIdentifier: FactsCollectionViewCell.reuseIdentifier)
        
        refreshControl.addTarget(self, action: #selector(retryClicked), for: .valueChanged)
        
        collectionView.addSubview(refreshControl)
        
        view.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindUI()
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
                    self?.refreshControl.endRefreshing()
                    self?.showAlert(forError: error)
                }
            }
        }
        
        factViewModel.datasourceRows.bind { [weak self](rows) in
            self?.collectionViewDatasource.updateRows(rows)
            if rows.count > 0 {
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc func retryClicked(){
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           super.traitCollectionDidChange(previousTraitCollection)

        
       }

}

extension ViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let url = factViewModel.getImageUrl(indexPath){
            // fetch from already cache image
            if let imageDownloader = imageDownloaders.filter({ $0.imageUrl == url && $0.imageCache != nil}).first{
                if self.collectionViewDatasource.updateRowImage(imageDownloader.imageCache, forRow: indexPath.row){
                    DispatchQueue.main.async{
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                }
            }else{
                // fetch new imageim
                let downloader = ImageDownloader.init(url) { (image) in
                    if self.collectionViewDatasource.updateRowImage(image, forRow: indexPath.row){
                        DispatchQueue.main.async {
                            self.collectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
                imageDownloaders.insert(downloader)
            }
        }
    }
        
    
    
}


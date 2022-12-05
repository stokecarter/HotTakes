//
//  HorizontalCollectionViewTVCell.swift
//  Stoke
//
//  Created by Admin on 17/03/21.
//

import UIKit

protocol HorizontalCollectionViewDelegate:AnyObject {
    func getSelectedCategory(_ category:Categories)
}

class HorizontalCollectionViewTVCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate:HorizontalCollectionViewDelegate?
    
    
    
    var dataSource:[Categories] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        
    }
    
    private func initialSetup(){
        collectionView.registerCell(with: HorizontalGridCVCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }


    
}

extension HorizontalCollectionViewTVCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count > 5 ? 5 : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: HorizontalGridCVCell.self, indexPath: indexPath)
        cell.populateCell(dataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = collectionView.bounds.width/2.3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.getSelectedCategory(dataSource[indexPath.item])
    }
}

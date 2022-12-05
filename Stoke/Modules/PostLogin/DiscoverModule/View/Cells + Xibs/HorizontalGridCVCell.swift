//
//  HorizontalGridCVCell.swift
//  Stoke
//
//  Created by Admin on 17/03/21.
//

import UIKit

class HorizontalGridCVCell: UICollectionViewCell {

    @IBOutlet weak var imView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        DispatchQueue.main.async { [unowned self] in
            self.imView.roundCorner([.allCorners], radius: 10)
        }
        
    }
    
    func populateCell(_ cat:Categories){
        imView.setImageWithIndicator(with: URL(string: cat.image), placeholderImage: UIImage())
        titleLabel.text = cat.name
    }

    private func initialSetup(){
        imView.image = #imageLiteral(resourceName: "INDIA-vs-ENGLAND")
        imView.clipsToBounds = true
        titleLabel.font = AppFonts.Semibold.withSize(14)
        titleLabel.textColor = .white
        titleLabel.text = "Sports"
    }
}

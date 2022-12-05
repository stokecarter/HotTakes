//
//  TagsCVCell.swift
//  Stoke
//
//  Created by Admin on 21/03/21.
//

import UIKit

class TagCVCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tagImView: UIImageView!
    @IBOutlet weak var bookMarkIMView: UIImageView!
    @IBOutlet weak var tagName: UILabel!
    
    var isSaved:Bool = false{
        didSet{
            if isSaved{
                bgView.setBorderCurve(width: 1.5, color: AppColors.themeColor)
                bookMarkIMView.image = #imageLiteral(resourceName: "ic_bookmark_active")
            }else{
                bgView.setBorderCurve(width: 1.5, color: AppColors.labelColor)
                bookMarkIMView.image = #imageLiteral(resourceName: "ic-inactive-bookmark")
            }
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        bgView.roundCorner([.allCorners], radius: 15)
        tagImView.setBorderCurve(width: 1, color: AppColors.labelColor)
        tagImView.clipsToBounds = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        tagName.font = AppFonts.Bold.withSize(13)
        tagName.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)

    }
    
    func populateCell(_ tag:Tags){
        tagImView.setImageWithIndicator(with: URL(string: tag.image), placeholderImage: UIImage())
        tagName.text = tag.name
        isSaved = tag.isSaved
    }
    

}

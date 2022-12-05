//
//  ChatRoomDetailTVCell.swift
//  Stoke
//
//  Created by Admin on 21/03/21.
//

import UIKit

class ChatRoomDetailTVCell: UITableViewCell {
    
    
    @IBOutlet weak var tagsHeadingLabel: UILabel!
    @IBOutlet weak var roomDateTimeLabel: UILabel!
    @IBOutlet weak var eventname: UILabel!
    @IBOutlet weak var noOfPeoples: UILabel!
    @IBOutlet weak var noOfFollowers: UILabel!
    @IBOutlet weak var paidRoomHeight: NSLayoutConstraint!
    @IBOutlet weak var joinRoomBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var joinBtn: AppButton!
    @IBOutlet weak var tagsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dateTimeViewHeightConstant: NSLayoutConstraint!
    var joinTapped:(()->())?
    
    var tags:[Tags] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var showTime:Date? = nil{
        didSet{
            if let d = showTime{
                let dt = d.toString(dateFormat: "MMM d")
                let time = d.toString(dateFormat: "h:mm a")
                let str = "This room opens \(dt) at \(time)"
                let attributedString = NSMutableAttributedString(string: str,
                                                                 attributes: [NSAttributedString.Key.font: AppFonts.Medium.withSize(14),NSAttributedString.Key.foregroundColor:AppColors.labelColor])
                let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: AppFonts.Bold.withSize(14),NSAttributedString.Key.foregroundColor:UIColor.black]
                let range1 = (str as NSString).range(of: dt)
                let range2 = (str as NSString).range(of: time)
                attributedString.addAttributes(boldFontAttribute, range: range1)
                attributedString.addAttributes(boldFontAttribute, range: range2)
                roomDateTimeLabel.attributedText = attributedString
            }
        }
    }
    
    var isFree:Bool = false{
        didSet{
            paidRoomHeight.constant = isFree ? CGFloat.leastNormalMagnitude : 20
            layoutIfNeeded()
        }
    }
    
    var isMyChatRoom:Bool = false{
        didSet{
            joinRoomBtnHeight.constant = isMyChatRoom ? CGFloat.leastNormalMagnitude : 48
            layoutIfNeeded()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        eventname.font = AppFonts.Bold.withSize(16)
        eventname.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(with: TagCVCell.self)
    }
    
    func populateCell(_ chat:ChatRoom){
        tagsViewHeight.constant = chat.tags.isEmpty ? CGFloat.leastNormalMagnitude : 65
        eventname.text = chat.event.name
        noOfPeoples.text = chat.noOfUsers
        noOfFollowers.text = chat.noOfFollowings
        isFree = chat.isFree
        showTime = chat.startDateObject
        isMyChatRoom = chat.isCreatedByMe
        dateTimeViewHeightConstant.constant = chat.isLive ? CGFloat.leastNormalMagnitude : 62
        tags = chat.tags
        var title = ""
        if chat.roomType == ._public{
            if chat.isLive{
                title = "Join Room"
            }else{
                if chat.isSaved{
                    title = "Remove from My Rooms"
                }else{
                    title = "Save to My Rooms"
                }
            }
            joinBtn.setTitle(title, for: .normal)
        }else{
            if chat.isLive{
                title = "Request to join"
            }else{
                if chat.isSaved{
                    title = "Remove from My Rooms"
                }else{
                    title = "Save to My Rooms"
                }
            }
            joinBtn.setTitle(title, for: .normal)
        }
        layoutIfNeeded()
    }
    
    @IBAction func joinBtnTapped(_ sender: Any) {
        if let tap = joinTapped { tap()}
    }
}

extension ChatRoomDetailTVCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: TagCVCell.self, indexPath: indexPath)
        cell.populateCell(tags[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.height
        let wd = tags[indexPath.item].name.widthOfText(25, font: AppFonts.Bold.withSize(14))
        let w:CGFloat = wd + 75
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CommonFunctions.actionOnTags(tags[indexPath.item].id, action: !tags[indexPath.item].isSaved) { [weak self] in
            self?.tags[indexPath.item].isSaved.toggle()
            self?.collectionView.reloadData()
        }
    }
}


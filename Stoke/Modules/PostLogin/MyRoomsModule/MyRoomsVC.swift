//
//  MyRoomsVC.swift
//  Stoke
//
//  Created by Admin on 05/04/21.
//

import UIKit

class MyRoomsVC: BaseVC {
    
    @IBOutlet weak var savedBtn: UIButton!
    @IBOutlet weak var createdBtn: UIButton!
    @IBOutlet weak var sliderContainerView: UIView!
    @IBOutlet weak var slidderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var savedCollectionView: UICollectionView!
    @IBOutlet weak var ccreatedCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
setNavigationBar(title: "My Rooms", backButton: false)
        applyTransparentBackgroundToTheNavigationBar(0)
        addRightButtonToNavigation(image: #imageLiteral(resourceName: "ic_add_room"))
    }
    
    override func initalSetup() {
        
    }
    
    override func setupFounts() {
        savedBtn.isSelected = true
        [savedBtn,createdBtn].forEach {
            $0?.setTitleColor(AppColors.themeColor, for: .selected)
            $0?.setTitleColor(#colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), for: .normal)
            $0?.titleLabel?.font = AppFonts.Medium.withSize(16)
        }
    }
    
    override func rightBarButtonTapped(_ sender: UIButton) {
        CommonFunctions.showToastWithMessage("Under Development")
    }
    
    private func setSelectedButton(_ sender:UIButton){
        savedBtn.isSelected   = sender === savedBtn ? true:false
        createdBtn.isSelected   = sender === createdBtn ? true:false
        
    }
    
    // Mark:- IBActions
    
    @IBAction func savedTapped(_ sender: UIButton) {
        setSelectedButton(sender)
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func createdTapped(_ sender: UIButton) {
        self.setSelectedButton(sender)
        self.scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
    }

}

extension MyRoomsVC : UIScrollViewDelegate{
    public func scrollViewDidScroll(_ scrollView: UIScrollView)    {
        guard scrollView != savedCollectionView else { return }
        guard scrollView != ccreatedCollectionView else { return }
        let width = scrollView.width/slidderView.width
        let scroll = scrollView.contentOffset.x
        slidderView.transform = CGAffineTransform(translationX: scroll/width, y: 0)
        switch scroll {
        case  0:
            setSelectedButton(savedBtn)
        case  UIDevice.width :
            setSelectedButton(createdBtn)
        default :
            break
        }
    }
}

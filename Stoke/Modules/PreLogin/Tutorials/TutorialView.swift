//
//  TutorialView.swift
//  Stoke
//
//  Created by Admin on 23/02/21.
//

import UIKit
import CHIPageControl

class TutorialView:BaseVC {
    
    //    MARK:- IBOutlets
    
    
    @IBOutlet weak var pageControll: CHIPageControlJaloro!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skipBtn: AppButton!
    @IBOutlet weak var nextBtn: AppButton!
    
    var currentIndex = 0{
        didSet{
            if currentIndex == 3{
                goToLogin()
            }
                skipBtn.isHidden = currentIndex >= 2
            
        }
    }
    
    //    MARK:- Lifecycle Me
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func initalSetup() {
        skipBtn.btnType = .whiteRound
        nextBtn.btnType = .themeRound
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControll.numberOfPages = 3
        pageControll.radius = 1.5
        pageControll.tintColor = .lightGray
        pageControll.currentPageTintColor = AppColors.themeColor
        pageControll.padding = 6
        pageControll.set(progress: 0, animated: true)
        
        
    }
    
    override func setupFounts() {
        skipBtn.setTitle("Skip", for: .normal)
        nextBtn.setTitle("Next", for: .normal)
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        currentIndex = 3
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        currentIndex += 1
        if currentIndex <= 2 {
        pageControll.set(progress: currentIndex, animated: true)
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.scrollToItem(at: IndexPath(item: self?.currentIndex ?? 0, section: 0), at: .centeredHorizontally, animated: true)
            }
        
        }
    }
    
    private func goToLogin(){
        AppUserDefaults.save(value: true, forKey: .tutorialDisplayed)
        let vc = WelcomeVC.instantiate(fromAppStoryboard: .Main)
        AppRouter.pushViewController(self, vc)
    }
    
    
}



extension TutorialView : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: TutorialCollectionViewCell.self, indexPath: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }

        print(indexPath.item)
        currentIndex = indexPath.item
        pageControll.set(progress: indexPath.item, animated: true)
    }
    
    
}


class TutorialCollectionViewCell:UICollectionViewCell{
    
    
    @IBOutlet weak var heading:UILabel!
    @IBOutlet weak var desc:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heading.font = AppFonts.Medium.withSize(18)
        desc.font = AppFonts.Regular.withSize(16)
        desc.textColor = AppColors.labelColor
        
        
    }
    
    
}

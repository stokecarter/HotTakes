//
//  TabbarVCViewController.swift
//  Stoke
//
//  Created by Admin on 25/02/21.
//

import UIKit

class TabbarVC: UITabBarController {
    
    
    private lazy var navigationTitleImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = AppColors.themeColor
        delegate = self
        applyTransparentBackgroundToTheNavigationBar(100)
        manageNavigationBarTitle()
        addNavBarImage()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var isTitleImageViewHiden:Bool = false{
        didSet{
            navigationTitleImageView.isHidden = isTitleImageViewHiden
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    func addNavBarImage() {
        self.navigationTitleImageView.image = #imageLiteral(resourceName: "ic-stoke-red-small")
        self.navigationTitleImageView.contentMode = .scaleAspectFit
        self.navigationTitleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let navC = self.navigationController{
            navC.navigationBar.addSubview(self.navigationTitleImageView)
            self.navigationTitleImageView.centerXAnchor.constraint(equalTo: navC.navigationBar.centerXAnchor).isActive = true
            self.navigationTitleImageView.centerYAnchor.constraint(equalTo: navC.navigationBar.centerYAnchor, constant: 0).isActive = true
            self.navigationTitleImageView.widthAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.3).isActive = true
            self.navigationTitleImageView.heightAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.1).isActive = true
        }
    }
    
    final func applyTransparentBackgroundToTheNavigationBar(_ opacity: CGFloat) {
        guard let navController = self.navigationController else {return}
        var transparentBackground: UIImage
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1),
                                               false,
                                               navController.navigationBar.layer.contentsScale)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(red: 1, green: 1, blue: 1, alpha: opacity)
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        transparentBackground = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let navigationBarAppearance = self.navigationController!.navigationBar
        navigationBarAppearance.setBackgroundImage(transparentBackground, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .white
    }
    
    private func manageNavigationBarTitle(index:Int = 0){
        switch index {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name.scrollTotop, object: nil)
        default:
            print("Do nothing")
        }
//        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,
//                              NSAttributedString.Key.font:AppFonts.Semibold.withSize(18)]
//        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
}


extension TabbarVC : UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item){
            manageNavigationBarTitle(index: index)
        }
    }
}


extension NSNotification.Name{
    static let scrollTotop = NSNotification.Name("scrollToTop")
}

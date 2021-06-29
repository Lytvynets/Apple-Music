//
//  MainTabBarController .swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 13.06.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        
        viewControllers = [
            generateViewController(rootVC: searchVC, title: "Search"),
            generateViewController(rootVC: LibraryViewController(), title: "Library")
        ]
        
        
    }
    

    private func generateViewController(rootVC: UIViewController, title: String) -> UIViewController{
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.tabBarItem.title = title
        rootVC.navigationItem.title = title
        return navigationVC
    }
    
    
    
    
}

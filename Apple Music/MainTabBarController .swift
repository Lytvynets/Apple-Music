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
        tabBar.tintColor = .red
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        
        viewControllers = [
            generateViewController(rootVC: searchVC, title: "Search", image: #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon")),
            generateViewController(rootVC: LibraryViewController(), title: "Library", image: #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon"))
        ]
        
        
    }
    

    private func generateViewController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController{
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        
        rootVC.navigationItem.title = title
        return navigationVC
    }
    
    
    
    
}

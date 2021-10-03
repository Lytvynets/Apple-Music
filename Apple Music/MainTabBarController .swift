//
//  MainTabBarController .swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 13.06.2021.
//

import UIKit

protocol MainTabBarControllerDelegate: class  {
    func minimizedTrackDetailController()
    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    
    private var minimizedTopAnchor: NSLayoutConstraint!
    private var maximizedTopAnchor: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .red
        searchVC.tabBarDelegate = self
        viewControllers = [
            generateViewController(rootVC: searchVC, title: "Search", image: #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon")),
            generateViewController(rootVC: LibraryViewController(), title: "Library", image: #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon"))
        ]
        setupTrackDetailView()
    }
    
    
    private func generateViewController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController{
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootVC.navigationItem.title = title
        return navigationVC
    }
    
    
    private func setupTrackDetailView(){
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchor = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchor = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        maximizedTopAnchor.isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
}



extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?) {
       
        minimizedTopAnchor.isActive = false
        maximizedTopAnchor.isActive = true
        maximizedTopAnchor.constant = 0
        bottomAnchorConstraint.constant = 0
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 0
                        self.trackDetailView.miniTrackDetilView.alpha = 0
                        self.trackDetailView.maximizedStackView.alpha = 1
                        
                       },
                       completion: nil)
        
        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
        
    }
    
    
    func minimizedTrackDetailController() {
        maximizedTopAnchor.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchor.isActive = true
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 1
                        self.trackDetailView.miniTrackDetilView.alpha = 1
                        self.trackDetailView.maximizedStackView.alpha = 0
                       },
                       completion: nil)
    }
    
    
}

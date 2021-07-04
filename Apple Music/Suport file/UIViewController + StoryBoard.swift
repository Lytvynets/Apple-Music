//
//  UIViewController + StoryBoard.swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 19.06.2021.
//

import Foundation
import UIKit

extension UIViewController {
   
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewContriller = storyboard.instantiateInitialViewController() as? T {
            return viewContriller
        }else{
            fatalError("Error: No initial viewController \(name)")
        }
    }
    
}

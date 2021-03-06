//
//  SearchRouter.swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 18.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol SearchRoutingLogic{
}

protocol SearchDataPassing {
  var dataStore: SearchDataStore? { get }
}

class SearchRouter: NSObject, SearchRoutingLogic, SearchDataPassing{
  weak var viewController: SearchViewController?
  var dataStore: SearchDataStore?
  
}

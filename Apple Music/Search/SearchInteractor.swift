//
//  SearchInteractor.swift
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

protocol SearchBusinessLogic{
    func makeRequest(request: Search.Something.Request.RequestType)
}

protocol SearchDataStore{
}


class SearchInteractor: SearchBusinessLogic, SearchDataStore{
    
    var presenter: SearchPresentationLogic?
    var worker: SearchWorker?
    var networkmanager = NetworkManager()
    
    func makeRequest(request: Search.Something.Request.RequestType) {
        if worker == nil{
            worker = SearchWorker()
        }
        
        switch request {
        case .some:
            presenter?.presentSomething(response: Search.Something.Response.ResponseType.some)
        case .getTracks(let searchText):
            presenter?.presentSomething(response: Search.Something.Response.ResponseType.presentFooterView)
            networkmanager.fetchTracks(searchText: searchText) { [weak self](SearchResponse) in
                self?.presenter?.presentSomething(response: Search.Something.Response.ResponseType.presentTrack(searchResponse: SearchResponse))
            }
        case .getVideo:
            presenter?.presentSomething(response: Search.Something.Response.ResponseType.presentVideo)
        }
    }
}

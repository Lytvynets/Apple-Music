//
//  SearchPresenter.swift
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

protocol SearchPresentationLogic{
    func presentSomething(response: Search.Something.Response.ResponseType)
}


class SearchPresenter: SearchPresentationLogic{
    
    weak var viewController: SearchDisplayLogic?
    
    func presentSomething(response: Search.Something.Response.ResponseType){
        
        switch response {
        case .some:
            viewController?.displaySomething(viewModel: Search.Something.ViewModel.ViewModelData.some)
        case .presentTrack(let searchResults):
            let cells = searchResults?.results.map({ (track) in
                cellViewModel(from: track)
            }) ?? []
            let searchViewModel = SearchViewModel.init(cells: cells)
            viewController?.displaySomething(viewModel: Search.Something.ViewModel.ViewModelData.displayTrack(searchViewModel: searchViewModel))
        case .presentVideo:
            viewController?.displaySomething(viewModel: Search.Something.ViewModel.ViewModelData.viewVideo)
        case .presentFooterView:
            viewController?.displaySomething(viewModel: Search.Something.ViewModel.ViewModelData.displayFooterView)
        }
    }
    
    
    private func cellViewModel(from track: Track) -> SearchViewModel.Cell{
        return SearchViewModel.Cell.init(iconUrlString: track.artworkUrl100,
                                         trackName: track.trackName,
                                         collectionName: track.collectionName ?? "",
                                         artistName: track.artistName,
                                         previewUrl: track.previewUrl
        )
    }
}

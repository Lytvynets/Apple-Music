//
//  UserDefaults.swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 04.10.2021.
//

import Foundation

extension UserDefaults {
    static let favouriteTrackKey = "favouriteTrackKey"
    
    func saveDataTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        
        guard let savedData = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else { return [] }
        
        guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [SearchViewModel.Cell] else { return [] }
        return decodedTracks
        
    }
}

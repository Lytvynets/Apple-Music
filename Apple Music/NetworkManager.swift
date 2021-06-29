//
//  NetworkManager.swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 17.06.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    func fetchTracks(searchText: String, complition: @escaping (SearchResponse?) -> Void ){
        let url = "https://itunes.apple.com/search"
        let parameters = ["term":"\(searchText)",
                          "limit":"10",
                          "media":"music"
        ]
        
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (dataResponse) in
            if let error = dataResponse.error {
                print("Error data: \(error.localizedDescription)")
                complition(nil)
                return
            }
            
            guard let data = dataResponse.data else { return }
            let jsonDecod = JSONDecoder()
            
            do{
                let object = try jsonDecod.decode(SearchResponse.self, from: data)
                print("object:", object)
                complition(object)
                
            } catch let jsonError{
                print(jsonError)
                complition(nil)
            }
            
            //                let someString = String(data: data, encoding: .utf8)
            //                print(someString ?? "")
        }
        
    }
}

//
//  Service.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 10.12.2022.
//

import Foundation
class Service {
    
    static let shared = Service() //Singleton
    
    func fetchApps(searchTerm: String,completion: @escaping ([Result], Error?) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, resp, err in

            if let err = err {
                print("Failed to fetch the data ", err)
                completion([], nil)
                return
            }

            //Success
            guard let data = data else { return }

            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            }
            catch let jsonErr{
                print("Failed to decode JSON", jsonErr)
                completion([],jsonErr)
            }
        }.resume()// Fires of the request
    }
}

//
//  Service.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 10.12.2022.
//

import Foundation
class Service {
    
    static let shared = Service() //Singleton
    
    func fetchApps(searchTerm: String,completion: @escaping (SearchResult?, Error?) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        

      fetchGenericJSONData(urlString: urlString, completion: completion)
    }
//    
//    func fetchBooks(completion: @escaping(AppGroup?,Error?) -> ()) {
//         let urlBook = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/50/albums.json"
//        fetchGroupData(urlString: urlBook, completion: completion)
//    }
    
    func fetchApps(completion: @escaping(AppGroup?,Error?) -> ()) {
         let urlBook = "https://rss.applemarketingtools.com/api/v2/tr/apps/top-free/50/apps.json"
        fetchGroupData(urlString: urlBook, completion: completion)
    }
    
    func fetchAppsPaid(completion: @escaping(AppGroup?,Error?) -> ()) {
         let urlBook = "https://rss.applemarketingtools.com/api/v2/tr/apps/top-paid/50/apps.json"
        fetchGroupData(urlString: urlBook, completion: completion)
    }
    
    
    //Helpers
    func fetchGroupData(urlString:String, completion: @escaping (AppGroup?,Error?) -> Void) {
        
       fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchSocialApp(completion: @escaping ([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        
      fetchGenericJSONData(urlString: urlString, completion: completion)
        
    }
    
    //Declare my generic json function here
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?,Error?) -> ()) {
    
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, resp, err in
            if let err = err {
                completion(nil,err)
            }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data!)
                //Success
                completion(objects,nil)
            }catch {
                completion(nil,err)
            }
            
        }.resume()
        
        
    }
    
    
}

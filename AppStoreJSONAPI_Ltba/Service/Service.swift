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
    
    func fetchBooks(completion: @escaping(AppGroup?,Error?) -> ()) {
         let urlBook = "https://rss.applemarketingtools.com/api/v2/tr/books/top-free/50/books.json"
        fetchGroupData(urlString: urlBook, completion: completion)
    }
    
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
       
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, resp, err in
            
            if err != nil {
                completion(nil,err)
                return
            }
            
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data!)
                
                
                completion(appGroup,nil)
            }catch{
                completion(nil,err)
                print("Error while decoding data",error)
            }
            
        }.resume()
    }
    
    func fetchSocialApp(completion: @escaping ([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil,err)
                return
            }
            
            do {
                let objects = try JSONDecoder().decode([SocialApp].self, from: data!)
                completion(objects,nil)
            }catch{
                completion(nil, err)
            }
        }.resume()
        
    }
    
}

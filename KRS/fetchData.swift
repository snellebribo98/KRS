//
//  fetchData.swift
//  KRS
//
//  Created by Wessel Mel on 26/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit

class fetchDatas {
    static var klantgegevens2: [Klant2]?
    static var onderhoudgegevens2: [onderhoud2]?
    static var toestelgegevens2: [toestel2]?
    
    let urlPathKlantenGegevens = "http://127.0.0.1/~wesselmel/klantengegevens.php"
    let urlPathOnderhouden = "http://127.0.0.1/~wesselmel/onderhouden.php"
    let urlPathToestellen = "http://127.0.0.1/~wesselmel/toestellen.php"
    
    func klantData() -> [Klant2]? {
        fetchDatas.klantgegevens2 = nil
        fetchKlantenGegevens()
        while fetchDatas.klantgegevens2 == nil {
        
        }
        return fetchDatas.klantgegevens2

    }
    
    func onderhoudData() -> [onderhoud2]? {
        fetchDatas.onderhoudgegevens2 = nil
        fetchOnderhouden()
        while fetchDatas.onderhoudgegevens2 == nil {
            
        }
        return fetchDatas.onderhoudgegevens2
        
    }
    
    func toestelData() -> [toestel2]? {
        fetchDatas.toestelgegevens2 = nil
        fetchToestellen()
        while fetchDatas.toestelgegevens2 == nil {
            
        }
        return fetchDatas.toestelgegevens2
    }
    
    func fetchKlantenGegevens() {
        let url: URL = URL(string: urlPathKlantenGegevens)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            } else {
                print("Data downloaded")
                print(data!)
                let jsonDecoder = JSONDecoder()
                if let data = data, let klantgegevens = try? jsonDecoder.decode([Klant2].self, from: data)
                {
//                    print("hier")
//                    print(klantgegevens)
                    fetchDatas.klantgegevens2 = klantgegevens
                    
                }
            }
            
        }
        
        task.resume()
        print("Eind")
    }
    
    func fetchOnderhouden() {
        let url: URL = URL(string: urlPathOnderhouden)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                print(data!)
                let jsonDecoder = JSONDecoder()
                if let data = data, let onderhoudgegevens = try? jsonDecoder.decode([onderhoud2].self, from: data)
                {
//                    print("hier2")
//                    print(onderhoudgegevens)
                    fetchDatas.onderhoudgegevens2 = onderhoudgegevens
                    
                }
            }
            
        }
        
        task.resume()
        print("Eind")
    }
    
    func fetchToestellen() {
        let url: URL = URL(string: urlPathToestellen)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                print(data!)
                let jsonDecoder = JSONDecoder()
                if let data = data, let toestelgegevens = try? jsonDecoder.decode([toestel2].self, from: data)
                {
//                    print("hier")
//                    print(toestelgegevens)
                    fetchDatas.toestelgegevens2 = toestelgegevens
                }
            }
            
        }
        
        task.resume()
        print("Eind")
    }
    
}

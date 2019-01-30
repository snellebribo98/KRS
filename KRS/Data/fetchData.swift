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

    let urlPathKlantenGegevens = "http://orsmel.com/klantengegevens.php"
    let urlPathOnderhouden = "http://orsmel.com/onderhouden.php"
    let urlPathToestellen = "http://orsmel.com/toestellen.php"
    
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
    
    // fetch klantengegevens from online database
    func fetchKlantenGegevens() {
        let url: URL = URL(string: urlPathKlantenGegevens)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            } else {
                print("Data downloaded")
                let jsonDecoder = JSONDecoder()
                if let data = data, let klantgegevens = try? jsonDecoder.decode([Klant2].self, from: data)
                {
                    fetchDatas.klantgegevens2 = klantgegevens
                }
            }
        }
        task.resume()
    }
    
    // fetch onderhoud from online database
    func fetchOnderhouden() {
        let url: URL = URL(string: urlPathOnderhouden)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.ephemeral)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                let jsonDecoder = JSONDecoder()
                if let data = data, let onderhoudgegevens = try? jsonDecoder.decode([onderhoud2].self, from: data)
                {
                    fetchDatas.onderhoudgegevens2 = onderhoudgegevens
                }
            }
        }
        
        task.resume()
    }
    
    // fetch toestellen from online database
    func fetchToestellen() {
        let url: URL = URL(string: urlPathToestellen)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.ephemeral)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                let jsonDecoder = JSONDecoder()
                if let data = data, let toestelgegevens = try? jsonDecoder.decode([toestel2].self, from: data)
                {
                    fetchDatas.toestelgegevens2 = toestelgegevens
                }
            }
        }
        task.resume()
    }
    
}

//
//  createData.swift
//  KRS
//
//  Created by Wessel Mel on 29/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit

class createData {
    
    // creating NSMutableURLRequest
    let request = NSMutableURLRequest(url: NSURL(string: "http://orsmel.com/api/datafunctions.php")! as URL)
    
    // create new klantgegevens in online database
    func createKlantgegevens(naam: String, debnr: String, tel: String, mobiel: String, mail: String, straat: String, nr: String, postcode: String, woonplaats: String, notities: String, klant_id: String) {
        
        request.httpMethod = "POST"
        let postParameters = "naam=\(naam)&debnr=\(debnr)&tel=\(tel)&mobiel=\(mobiel)&mail=\(mail)&straat=\(straat)&nr=\(nr)&postcode=\(postcode)&woonplaats=\(woonplaats)&notities=\(notities)&klant_id=\(klant_id)&klant=True"
        
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            do {
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = myJSON {
                    
                    var msg : String!
                    
                    msg = parseJSON["message"] as! String?
                    
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    // creating new toestelgegevens in online database
    func createToestel(klant_id: String, toestel_id: String, merk: String, type: String, bouwjaar: String, freq: String, garantie: String, datum: String, serienr: String, OGP: String) {
        
        request.httpMethod = "POST"
        let postParameters = "klant_id_toestel=\(klant_id)&toestel_id_toestel=\(toestel_id)&merk_toestel=\(merk)&type_toestel=\(type)&bouwjaar_toestel=\(bouwjaar)&freq_toestel=\(freq)&garantie_toestel=\(garantie)&datum_toestel=\(datum)&serienr_toestel=\(serienr)&OGP_toestel=\(OGP)&toestel=True"
        print(postParameters)
        
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            do {
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = myJSON {
                    
                    var msg : String!
                    
                    msg = parseJSON["message"] as! String?
                    
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    // creating new onderhoudgegevens in online database
    func createOnderhoud(klant_id: String, toestel_id: String, onderhoudsdatum: String, monteur: String, werkzaamheden: String, opmerkingen: String, onderhoud_id: String) {
        request.httpMethod = "POST"
        let postParameters = "klant_id_onderhoud=\(klant_id)&toestel_id_onderhoud=\(toestel_id)&onderhoudsdatum_onderhoud=\(onderhoudsdatum)&monteur_onderhoud=\(monteur)&werkzaamheden_onderhoud=\(werkzaamheden)&opmerkingen_onderhoud=\(opmerkingen)&onderhoud_id_onderhoud=\(onderhoud_id)&onderhoud=True"
        
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            do {
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = myJSON {
                    
                    var msg : String!
                    
                    msg = parseJSON["message"] as! String?
                    
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
}

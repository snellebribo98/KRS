//
//  createData.swift
//  KRS
//
//  Created by Wessel Mel on 29/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit

class createData {
    
    //creating NSMutableURLRequest
    let request = NSMutableURLRequest(url: NSURL(string: "http://localhost/~wesselmel/api/datafunctions.php")! as URL)
    
    func createKlantgegevens(naam: String, debnr: String, tel: String, mobiel: String, mail: String, straat: String, nr: String, postcode: String, woonplaats: String, notities: String, klant_id: String) {
        
        request.httpMethod = "POST"
        let postParameters = "naam=\(naam)&debnr=\(debnr)&tel=\(tel)&mobiel=\(mobiel)&mail=\(mail)&straat=\(straat)&nr=\(nr)&postcode=\(postcode)&woonplaats=\(woonplaats)&notities=\(notities)&klant_id=\(klant_id)&klant=True"
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(error)")
                return;
            }
            
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
    }
    
    func createToestel(klant_id: String, toestel_id: String, merk: String, type: String, bouwjaar: String, freq: String, garantie: String, datum: String, serienr: String, OGP: String) {
        
        request.httpMethod = "POST"
        let postParameters = "klant_id_toestel=\(klant_id)&toestel_id_toestel=\(toestel_id)&merk_toestel=\(merk)&type_toestel=\(type)&bouwjaar_toestel=\(bouwjaar)&freq_toestel=\(freq)&garantie_toestel=\(garantie)&datum_toestel=\(datum)&serienr_toestel=\(serienr)&OGP_toestel=\(OGP)&toestel=True"
        print(postParameters)
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(error)")
                return;
            }
            
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
    }
    
    func createOnderhoud(klant_id: String, toestel_id: String, onderhoudsdatum: String, monteur: String, werkzaamheden: String, opmerkingen: String) {
        request.httpMethod = "POST"
        let postParameters = "klant_id_onderhoud=\(klant_id)&toestel_id_onderhoud=\(toestel_id)&onderhoudsdatum_onderhoud=\(onderhoudsdatum)&monteur_onderhoud=\(monteur)&werkzaamheden_onderhoud=\(werkzaamheden)&opmerkingen_onderhoud=\(opmerkingen)&onderhoud=True"
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(error)")
                return;
            }
            
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
    }
}

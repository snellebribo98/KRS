//
//  ZoekKlantViewController.swift
//  KRS
//
//  Created by Wessel Mel on 23/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit



class ZoekKlantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var klantDataTable: UITableView!
    @IBOutlet weak var naamTextField: UITextField!
    @IBOutlet weak var straatTextField: UITextField!
    @IBOutlet weak var woonplaatsTextField: UITextField!
    
    var filtered = 0
    var klantgegevens = [Klant3]()
    var klantgegevens2 = [Klant3?]()
    var filteredklantgegevens = [Klant3]()
    
    var testklantgegevens: [Klant2]?
    var testonderhoudgegevens: [onderhoud2]?
    var testtoestelgegevens: [toestel2]?
    
    var klantamount: Int?
    var toestelamount: Int?
    var onderhoudamount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createData()
        fetchIets()
        klantDataTable.delegate = self
        klantDataTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func fetchIets() {
        let fetch = fetchDatas()
        testklantgegevens = fetch.klantData()
        testonderhoudgegevens = fetch.onderhoudData()
        testtoestelgegevens = fetch.toestelData()
        klantamount = testklantgegevens?.count
        print(testklantgegevens!)
        onderhoudamount = testonderhoudgegevens?.count
        print(testonderhoudgegevens!)
        toestelamount = testtoestelgegevens?.count
        print(testtoestelgegevens!)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        var stoppen = 0
        while stoppen != 1 {
            if testklantgegevens != nil && testonderhoudgegevens != nil && testtoestelgegevens != nil {
                for klant in testklantgegevens! {
                    var klantinfo = Klant3(naam: "", debnr: "", tel: "", mobiel: "", mail: "", straat: "", nr: "", postcode: "", woonplaats: "", notities: "", klant_id: "", toestellen: [], onderhouden: [])
                    klantinfo.naam = klant.naam
                    klantinfo.debnr = klant.debnr
                    klantinfo.tel = klant.tel
                    klantinfo.mobiel = klant.mobiel
                    klantinfo.mail = klant.mail
                    klantinfo.straat = klant.straat
                    klantinfo.nr = klant.nr
                    klantinfo.postcode = klant.postcode
                    klantinfo.woonplaats = klant.woonplaats
                    klantinfo.notities = klant.notities
                    klantinfo.klant_id = klant.klant_id
                    for toestel in testtoestelgegevens! {
                        if toestel.klant_id == klantinfo.klant_id {
                            var toestelinfo = toestel3(klant_id: "", toestel_id: "", merk: "", type: "", bouwjaar: "", freq: "", garantie: "", datum: Date(), serienr: "", OGP: "")
                            toestelinfo.klant_id = toestel.klant_id
                            toestelinfo.toestel_id = toestel.toestel_id
                            toestelinfo.merk = toestel.merk
                            toestelinfo.type = toestel.type
                            toestelinfo.bouwjaar = toestel.bouwjaar
                            toestelinfo.freq = toestel.freq
                            toestelinfo.garantie = toestel.garantie
                            toestelinfo.datum = dateFormatterGet.date(from: toestel.datum)!
                            toestelinfo.serienr = toestel.serienr
                            toestelinfo.OGP = toestel.OGP
                            klantinfo.toestellen.append(toestelinfo)
                            for onderhoud in testonderhoudgegevens! {
                                if onderhoud.toestel_id == toestelinfo.toestel_id {
                                    var onderhoudinfo = onderhoud3(klant_id: "", toestel_id: "", onderhoudsdatum: Date(), monteur: "", werkzaamheden: "", opmerkingen: "", onderhoud_id: "")
                                    onderhoudinfo.klant_id = onderhoud.klant_id
                                    onderhoudinfo.toestel_id = onderhoud.toestel_id
                                    onderhoudinfo.onderhoudsdatum = dateFormatterGet.date(from: onderhoud.onderhoudsdatum)!
                                    onderhoudinfo.monteur = onderhoud.monteur
                                    onderhoudinfo.werkzaamheden = onderhoud.werkzaamheden
                                    onderhoudinfo.opmerkingen = onderhoud.opmerkingen
                                    onderhoudinfo.onderhoud_id = onderhoud.onderhoud_id
                                    klantinfo.onderhouden.append(onderhoudinfo)
                                }
                            }
                        }
                    }
                    klantgegevens2.append(klantinfo)
                }
                klantgegevens = klantgegevens2 as! [Klant3]
                stoppen = 1
            }
        }
        klantamount = klantgegevens.count
        
    }
    
//    func createData() {
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "dd-MM-yyyy"
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filtered == 0 {
            return klantgegevens.count + 1
        } else {
            return filteredklantgegevens.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("HIRE")
        if indexPath.row == 0 {
            let cell = klantDataTable.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath)
            return cell
        } else {
            if filtered == 0 {
                var cell = dataCell()
                cell = klantDataTable.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! dataCell
                cell.achternaam?.text = klantgegevens[indexPath.row - 1].naam
                cell.Straat?.text = klantgegevens[indexPath.row - 1].straat
                cell.woonplaats?.text = klantgegevens[indexPath.row - 1].woonplaats
                if klantgegevens[indexPath.row - 1].tel.isEmpty {
                    cell.telNr?.text = klantgegevens[indexPath.row - 1].mobiel
                } else {
                    cell.telNr?.text = klantgegevens[indexPath.row - 1].tel
                }
                let toestellen = klantgegevens[indexPath.row - 1].toestellen
                if toestellen.count > 1 {
                    var types = ""
                    var ogps = ""
                    for toestel in toestellen {
                        types += "\(toestel.merk) \(toestel.type)\n"
                        ogps += "\(toestel.OGP)\n"
                    }
                    cell.type?.text = types
                    cell.OGP?.text = ogps
                } else if toestellen.count == 1 {
                    cell.type?.text = "\(toestellen[0].merk) \(toestellen[0].type)"
                    cell.OGP?.text = "\(toestellen[0].OGP)"
                } else {
                    cell.type?.text = "Geen"
                    cell.OGP?.text = "Onbekend"
                }
                return cell
            } else {
                var cell = dataCell()
                cell = klantDataTable.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! dataCell
                cell.achternaam?.text = filteredklantgegevens[indexPath.row - 1].naam
                cell.Straat?.text = filteredklantgegevens[indexPath.row - 1].straat
                cell.woonplaats?.text = filteredklantgegevens[indexPath.row - 1].woonplaats
                if filteredklantgegevens[indexPath.row - 1].tel.isEmpty {
                    cell.telNr?.text = filteredklantgegevens[indexPath.row - 1].mobiel
                } else {
                    cell.telNr?.text = filteredklantgegevens[indexPath.row - 1].tel
                }
                let toestellen = filteredklantgegevens[indexPath.row - 1].toestellen
                if toestellen.count > 1 {
                    var types = ""
                    var ogps = ""
                    for toestel in toestellen {
                        types += "\(toestel.merk) \(toestel.type)\n"
                        ogps += "\(toestel.OGP)\n"
                    }
                    cell.type?.text = types
                    cell.OGP?.text = ogps
                } else if toestellen.count == 1 {
                    cell.type?.text = "\(toestellen[0].merk) \(toestellen[0].type)"
                    cell.OGP?.text = "\(toestellen[0].OGP)"
                } else {
                    cell.type?.text = "Geen"
                    cell.OGP?.text = "Onbekend"
                }
                return cell
            }
            
        }
    }
    
    @IBAction func zoeken(_ sender: Any) {
        if naamTextField.text!.isEmpty && straatTextField.text!.isEmpty &&
            woonplaatsTextField.text!.isEmpty {
            filtered = 0
            filteredklantgegevens.removeAll()
            klantDataTable.reloadData()
            let alert = UIAlertController(title: "Error", message: "Voer een naam, straat en/of woonplaats in!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)

        } else {
            filteredklantgegevens.removeAll()
            filtered = 1
            for data in klantgegevens {
                var totaal = 0
                var overeen = 0
                if naamTextField.text!.isEmpty == false {
                    totaal += 1
                    // alternative: not case sensitive
                    if data.naam.lowercased().range(of:naamTextField.text!.lowercased()) != nil {
                        overeen += 1
                    }
                }
                if straatTextField.text!.isEmpty == false {
                    totaal += 1
                    if data.straat.lowercased().range(of:straatTextField.text!.lowercased()) != nil {
                        overeen += 1
                    }
                }
                if woonplaatsTextField.text!.isEmpty == false {
                    totaal += 1
                    print(woonplaatsTextField.text!)
                    print(data.woonplaats)
                    if data.woonplaats.lowercased().range(of:woonplaatsTextField.text!.lowercased()) != nil {
                        overeen += 1
                    }
                }
                print(totaal)
                print(overeen)
                if totaal == overeen {
                    filteredklantgegevens.append(data)
                }
            }
            print(filteredklantgegevens)
            klantDataTable.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailInfoSegue" {
            let DVC = segue.destination as! DetailViewController
            let index = klantDataTable.indexPathForSelectedRow!.row
            DVC.klantamount = klantamount
            DVC.toestelamount = toestelamount
            DVC.onderhoudamount = onderhoudamount
            if filtered == 1 {
                DVC.data = filteredklantgegevens[index - 1]
                
            } else {
                DVC.data = klantgegevens[index - 1]
            }
        }
        else if segue.identifier == "nieuwSegue" {
            let DVC = segue.destination as! DetailViewController
            DVC.klantamount = klantamount
            DVC.toestelamount = toestelamount
            DVC.onderhoudamount = onderhoudamount
            DVC.nieuw = 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            performSegue(withIdentifier: "DetailInfoSegue", sender: self)
        }
        
    }
    
    @IBAction func unwindToZoekKlant(segue: UIStoryboardSegue) {
        klantgegevens.removeAll()
        klantgegevens2.removeAll()
        testklantgegevens?.removeAll()
        testonderhoudgegevens?.removeAll()
        testtoestelgegevens?.removeAll()
        fetchIets()
        while klantgegevens.isEmpty {
            
        }
        print("huidige klantgegevens")
        print(klantgegevens)
        klantDataTable.reloadData()
    }
    
}

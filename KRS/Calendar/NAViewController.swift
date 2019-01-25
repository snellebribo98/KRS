//
//  NAViewController.swift
//  KRS
//
//  Created by Wessel Mel on 22/01/2019.
//  Copyright © 2019 Wessel Mel. All rights reserved.
//

import UIKit

class NAViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var overzicht: Int?
    var date: Date?
    var nieuw: Int?
    
    var klant_id: String = "Unknown"
    var toestel_id: String = "Unknown"
    var onderhoud_id: String = "Unknown"
    var onderhoudsdatum: Date = Date()
    var monteur: String = "Albert Mel"
    var werkzaamheden1: String = ""
    var opmerkingen: String = ""
    
    @IBOutlet weak var searchViewOutlet: UIView!
    @IBOutlet weak var inputViewOutlet: UIView!
    
    @IBOutlet weak var searchInputField: UITextField!
    @IBOutlet weak var klantDataTable: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var naamLabel: UILabel!
    
    @IBOutlet weak var datumPicker: UIDatePicker!
    @IBOutlet weak var monteurPicker: UIPickerView!
    @IBOutlet weak var werkzaamheden: UITextView!
    @IBOutlet weak var Opmerkingen: UITextView!
    
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
    
    let monteurs = ["Albert Mel", "Mike Visser", "Bart Dekker"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(date)
        print(nieuw)
        
        fetchIets()
        
        klantDataTable.delegate = self
        klantDataTable.dataSource = self
        monteurPicker.delegate = self
        monteurPicker.dataSource = self
        
        werkzaamheden.text = ""
        Opmerkingen.text = ""
        
        if nieuw == 0
        {
            searchView()
        }
        else
        {
            inputView()
        }
        // Do any additional setup after loading the view.
    }
    
    func searchView()
    {
        searchViewOutlet.isHidden = false
        inputViewOutlet.isHidden = true
    }
    
    func inputView()
    {
        searchViewOutlet.isHidden = true
        inputViewOutlet.isHidden = false
    }
    
    func fetchIets() {
        let fetch = fetchDatas()
        testklantgegevens = fetch.klantData()
        testonderhoudgegevens = fetch.onderhoudData()
        testtoestelgegevens = fetch.toestelData()
        
        klantamount = testklantgegevens?.count
        onderhoudamount = testonderhoudgegevens?.count
        toestelamount = testtoestelgegevens?.count
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredklantgegevens.count != 0
        {
            return filteredklantgegevens.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = klantDataTable.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath)
            return cell
        }
        else if filteredklantgegevens.count != 0
        {
            let cell = klantDataTable.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! dataCell
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
        else
        {
            let cell = klantDataTable.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        klant_id = filteredklantgegevens[indexPath.row - 1].klant_id
        let alert = UIAlertController(title: "Bericht", message: "Kies een toestel", preferredStyle: .alert)
        if filteredklantgegevens[indexPath.row - 1].toestellen.count > 1
        {
            print(filteredklantgegevens[indexPath.row - 1])
            for toestel in filteredklantgegevens[indexPath.row - 1].toestellen
            {
                let naam = "\(toestel.merk) \(toestel.type)"
                let id = toestel.toestel_id
                alert.addAction(UIAlertAction(title: naam, style: .default, handler: {action in self.kies(id: id)}))
            }
            self.present(alert, animated: true)
        }
        else if filteredklantgegevens[indexPath.row - 1].toestellen.count == 1
        {
            toestel_id = filteredklantgegevens[indexPath.row - 1].toestellen[0].toestel_id
            inputView()
        }
        else
        {
            toestel_id = "Unknown"
            inputView()
        }
        
        
        datumPicker.date = Date()
        datumPicker.locale = Locale(identifier: "nl_NL")
        datumPicker.datePickerMode = .date
        
    }
    
    func kies(id: String)
    {
        toestel_id = id
        inputView()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return monteurs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return monteurs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        monteur = monteurs[row]
    }
    
    @IBAction func search(_ sender: Any) {
        if searchInputField.text!.isEmpty
        {
            filtered = 0
            filteredklantgegevens.removeAll()
            klantDataTable.reloadData()
            let alert = UIAlertController(title: "Error", message: "Voer een naam in!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        else
        {
            filteredklantgegevens.removeAll()
            filtered = 1
            for data in klantgegevens {
                var totaal = 0
                var overeen = 0
                if searchInputField.text!.isEmpty == false {
                    totaal += 1
                    // alternative: not case sensitive
                    if data.naam.lowercased().range(of:searchInputField.text!.lowercased()) != nil {
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
    
    @IBAction func save(_ sender: Any) {
        if werkzaamheden.text.isEmpty
        {
            let alert = UIAlertController(title: "Error", message: "Voer de werkzaamheden in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if Opmerkingen.text.isEmpty
        {
            let alert = UIAlertController(title: nil, message: "Weet u zeker dat u geen opmerkingen wilt toevoegen?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: {action in self.save1()}))
            alert.addAction(UIAlertAction(title: "Nee", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            save1()
        }
    }
    
    func save1()
    {
        werkzaamheden1 = werkzaamheden.text
        opmerkingen = Opmerkingen.text
        onderhoudsdatum = datumPicker.date
        onderhoud_id = String(Int(onderhoudamount!))
        onderhoudamount! += 1
        print(klant_id)
        print(toestel_id)
        print(onderhoudsdatum)
        print(monteur)
        print(werkzaamheden1)
        print(opmerkingen)
        print(onderhoud_id)
        print(onderhoudamount)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        var datum = dateFormatterGet.string(from: onderhoudsdatum) as String?
        datum = datum!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        let create = createData()
        create.createOnderhoud(
            klant_id: klant_id,
            toestel_id: toestel_id,
            onderhoudsdatum: datum ?? "",
            monteur: monteur,
            werkzaamheden: werkzaamheden1,
            opmerkingen: opmerkingen,
            onderhoud_id: onderhoud_id)
        let alert = UIAlertController(title: "Doorgaan?", message: "Wilt u nog een afspraak maken?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: {action in self.ja()}))
        alert.addAction(UIAlertAction(title: "Nee", style: .default, handler: {action in self.nee()}))
        self.present(alert, animated: true)
    }
    
    func ja()
    {
        fetchIets()
        
        klant_id = "Unknown"
        toestel_id = "Unknown"
        onderhoud_id = "Unknown"
        onderhoudsdatum = Date()
        monteur = "Albert Mel"
        werkzaamheden1 = ""
        opmerkingen = ""
        
        klantDataTable.reloadData()
        
        datumPicker.date = Date()
        monteurPicker.selectRow(0, inComponent: 0, animated: true)
        werkzaamheden.text = ""
        Opmerkingen.text = ""
    }
    
    func nee()
    {
        if overzicht == 1
        {
            performSegue(withIdentifier: "goBackToOverzicht", sender: self)
        }
        else
        {
            performSegue(withIdentifier: "GoBackSegue", sender: self)
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        if overzicht == 1
        {
            performSegue(withIdentifier: "unwindToOverzichtSegue", sender: self)
        }
        else
        {
            performSegue(withIdentifier: "unwindToCalendarSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBackToOverzicht"
        {
            let OVC = segue.destination as! AfsprakenOverzichtViewController
            OVC.date = date
        }
    }
}

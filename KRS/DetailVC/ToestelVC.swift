//
//  ToestelVC.swift
//  KRS
//
//  Created by Wessel Mel on 25/01/2019.
//  Copyright © 2019 Wessel Mel. All rights reserved.
//

import UIKit

class ToestelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // incoming data
    var data: Klant3?
    var nieuw: Int?
    var klantamount: Int?
    var toestelamount: Int?
    var onderhoudamount: Int?
    
    // needed variables
    var backupdata: Klant3?
    var backupToestelAmount: Int?
    var nta: Int?
    var selectedRow: Int = 0
    var edit_on: Int = 0
    var dateFormat = DateFormatter()
    
    // outlets
    @IBOutlet weak var toestelDataTable: DesignableTableView!
    @IBOutlet weak var merk: UITextField!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var bouwjaar: UITextField!
    @IBOutlet weak var freq: UITextField!
    @IBOutlet weak var garantie: UITextField!
    @IBOutlet weak var ogp: UITextField!
    @IBOutlet weak var plaatsingdatum: UIDatePicker!
    @IBOutlet weak var serienr: UITextField!
    @IBOutlet weak var datum: UIStackView!
    @IBOutlet weak var plaatingDatumLabel: UILabel!
    @IBOutlet weak var addToestel: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create backup
        backupdata = data
        backupToestelAmount = toestelamount
        
        dateFormat.dateStyle = .full
        dateFormat.timeStyle = .none
        dateFormat.locale = Locale(identifier: "nl_NL")
        
        toestelDataTable.delegate = self
        toestelDataTable.dataSource = self
        toestelDataTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        
        if data?.toestellen.count != 0
        {
            // send the needed toestel id to ovViewController
            let neededData = Notification.Name("Data")
            NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id as Any])
        }
        
        if nieuw == 1
        {
            newKlant()
        }
        else if data?.toestellen.count != 0
        {
            updateOverview(index: 0)
        }
        else
        {
            emptyKlant()
        }
        
        // create observers for notifications
        let edited = Notification.Name("edit")
        let edited2 = Notification.Name("edit2")
        let edited3 = Notification.Name("edit3")
        NotificationCenter.default.addObserver(self, selector: #selector(toestelViewController.editOn), name:
            edited, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toestelViewController.editOff), name:
            edited2, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toestelViewController.save), name:
            edited3, object: nil)
    }
    
    // functions
    func newKlant()
    {
        edit_on = 1
        merk?.text = ""
        type?.text = ""
        bouwjaar?.text = ""
        freq?.text = ""
        garantie?.text = ""
        ogp?.text = ""
        serienr?.text = ""
        plaatsingdatum.isHidden = false
        plaatingDatumLabel.isHidden = true
        
        merk?.isEnabled = true
        type?.isEnabled = true
        bouwjaar?.isEnabled = true
        freq?.isEnabled = true
        garantie?.isEnabled = true
        ogp?.isEnabled = true
        serienr?.isEnabled = true
        addToestel.isHidden = false
    }
    
    func emptyKlant()
    {
        merk?.text = ""
        type?.text = ""
        bouwjaar?.text = ""
        freq?.text = ""
        garantie?.text = ""
        ogp?.text = ""
        serienr?.text = ""
        plaatsingdatum.isHidden = true
        plaatingDatumLabel.isHidden = false
        plaatingDatumLabel.text = "Onbekend"
        
        merk?.isEnabled = false
        type?.isEnabled = false
        bouwjaar?.isEnabled = false
        freq?.isEnabled = false
        garantie?.isEnabled = false
        ogp?.isEnabled = false
        serienr?.isEnabled = false
        addToestel.isHidden = true
    }
    
    // update the data variable if the user changed the text in the input fields
    func updata(row: Int)
    {
        if merk?.text != data?.toestellen[row].merk {
            data?.toestellen[row].merk = merk?.text ?? ""
        }
        if type?.text != data?.toestellen[row].type {
            data?.toestellen[row].type = type?.text ?? ""
        }
        if bouwjaar?.text != data?.toestellen[row].bouwjaar {
            data?.toestellen[row].bouwjaar = bouwjaar?.text ?? ""
        }
        if freq?.text != data?.toestellen[row].freq {
            data?.toestellen[row].freq = freq?.text ?? ""
        }
        if garantie?.text != data?.toestellen[row].garantie {
            data?.toestellen[row].garantie = garantie?.text ?? ""
        }
        if ogp?.text != data?.toestellen[row].OGP {
            data?.toestellen[row].OGP = ogp?.text ?? ""
        }
        if serienr?.text != data?.toestellen[row].serienr {
            data?.toestellen[row].serienr = serienr?.text ?? ""
        }
        let date = data?.toestellen[row].datum
        let date2 = plaatsingdatum?.date
        if date != nil {
            if date != date2 {
                data?.toestellen[row].datum = date2!
            }
        }
    }
    
    func updateOverview(index: Int)
    {
        if edit_on == 0
        {
            merk?.text = data?.toestellen[index].merk
            type?.text = data?.toestellen[index].type
            bouwjaar?.text = data?.toestellen[index].bouwjaar
            freq?.text = data?.toestellen[index].freq
            garantie?.text = data?.toestellen[index].garantie
            ogp?.text = data?.toestellen[index].OGP
            let date = data?.toestellen[index].datum
            plaatingDatumLabel?.text = dateFormat.string(from: date!)
            plaatsingdatum?.date = date!
            serienr?.text = data?.toestellen[index].serienr
            
            merk?.isEnabled = false
            type?.isEnabled = false
            bouwjaar?.isEnabled = false
            freq?.isEnabled = false
            garantie?.isEnabled = false
            ogp?.isEnabled = false
            serienr?.isEnabled = false
            plaatsingdatum.isHidden = true
            plaatingDatumLabel.isHidden = false
            addToestel.isHidden = true
        }
        else if edit_on == 1
        {
            merk?.text = data?.toestellen[index].merk
            type?.text = data?.toestellen[index].type
            bouwjaar?.text = data?.toestellen[index].bouwjaar
            freq?.text = data?.toestellen[index].freq
            garantie?.text = data?.toestellen[index].garantie
            ogp?.text = data?.toestellen[index].OGP
            let date = data?.toestellen[index].datum
            plaatingDatumLabel?.text = dateFormat.string(from: date!)
            plaatsingdatum?.date = date!
            serienr?.text = data?.toestellen[index].serienr
            
            merk?.isEnabled = true
            type?.isEnabled = true
            bouwjaar?.isEnabled = true
            freq?.isEnabled = true
            garantie?.isEnabled = true
            ogp?.isEnabled = true
            serienr?.isEnabled = true
            plaatsingdatum.isHidden = false
            plaatingDatumLabel.isHidden = true
            addToestel.isHidden = false
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nieuw != 1
        {
            if data?.toestellen.count != 0
            {
                return (data?.toestellen.count)!
            }
            else
            {
                return 1
            }
            
        }
        else
        {
            if data?.toestellen.count != 0
            {
                return (data?.toestellen.count)!
            }
            else
            {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toestelDataTable.dequeueReusableCell(withIdentifier: "toestelCell", for: indexPath)
        nta = 0
        if data?.toestellen.count != 0 && nieuw != 1
        {
            cell.textLabel?.text = data?.toestellen[indexPath.row].type
            if data?.toestellen[indexPath.row].merk == ""
            {
                nta = 2
            }
            return cell
        }
        else
        {
            if nieuw == 1 && data?.toestellen.count != 0
            {
                cell.textLabel?.text = data?.toestellen[indexPath.row].type
                if data?.toestellen[indexPath.row].merk == ""
                {
                    nta = 2
                }
                return cell
            }
            else
            {
                cell.textLabel?.text = "Nieuw Toestel"
                nta = 1
                return cell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data?.toestellen.count != 0
        {
            updata(row: selectedRow)
        }
        selectedRow = indexPath.row
        if nieuw == 1
        {
            if data?.toestellen.count != 0
            {
                updateOverview(index: selectedRow)
                let neededData = Notification.Name("Data")
                NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id as Any])
            }
            else
            {
                newKlant()
            }
        }
        else if nta == 1
        {
            if edit_on == 1
            {
                newKlant()
            }
            else
            {
                emptyKlant()
            }
        }
        else
        {
            let index = toestelDataTable.indexPathForSelectedRow?.row
            updateOverview(index: index!)
            toestelDataTable.reloadData()
            toestelDataTable.selectRow(at: IndexPath(row: index!, section: 0), animated: true, scrollPosition: .bottom)
            selectedRow = index!
            let neededData = Notification.Name("Data")
            NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id as Any])
        }
        
    }
    
    @IBAction func addToestel(_ sender: Any) {
        if nta == 1
        {
            if merk.text == ""
            {
                let alert = UIAlertController(title: "Vul in", message: "Vul een merk in!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else
            {
                toestelamount! += 1
                var id = String(toestelamount!)
                var newRow = toestel3(klant_id: data?.klant_id ?? "", toestel_id: id, merk: "", type: "Nieuw Toestel", bouwjaar: "", freq: "", garantie: "", datum: Date(), serienr: "", OGP: "")
                data?.toestellen.append(newRow)
                updata(row: toestelDataTable.indexPathForSelectedRow!.row)
                
                toestelamount! += 1
                id = String(toestelamount!)
                newRow = toestel3(klant_id: data?.klant_id ?? "", toestel_id: id, merk: "", type: "Nieuw Toestel", bouwjaar: "", freq: "", garantie: "", datum: Date(), serienr: "", OGP: "")
                data?.toestellen.append(newRow)
                let neededData = Notification.Name("Data")
                NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id as Any])
                
                toestelDataTable.reloadData()
                let endIndex = (data?.toestellen.count)! - 1
                toestelDataTable.selectRow(at: IndexPath(row: endIndex, section: 0), animated: true, scrollPosition: .bottom)
                selectedRow = endIndex
                updateOverview(index: endIndex)
                nta = 0
                NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id as Any])
                
            }
        }
        else if nta == 2
        {
            updata(row: selectedRow)
            toestelamount! += 1
            let id = String(toestelamount! - 1)
            let newRow = toestel3(klant_id: data?.klant_id ?? "", toestel_id: id, merk: "", type: "Nieuw Toestel", bouwjaar: "", freq: "", garantie: "", datum: Date(), serienr: "", OGP: "")
            data?.toestellen.append(newRow)
            toestelDataTable.reloadData()
            let endIndex = (data?.toestellen.count)! - 1
            toestelDataTable.selectRow(at: IndexPath(row: endIndex, section: 0), animated: true, scrollPosition: .bottom)
            selectedRow = endIndex
            updateOverview(index: endIndex)
            let neededData = Notification.Name("Data")
            NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id as Any])
        }
        else
        {
            updata(row: selectedRow)
            toestelamount! += 1
            let id = String(toestelamount! - 1)
            let newRow = toestel3(klant_id: data?.klant_id ?? "", toestel_id: id, merk: "", type: "Nieuw Toestel", bouwjaar: "", freq: "", garantie: "", datum: Date(), serienr: "", OGP: "")
            data?.toestellen.append(newRow)
            toestelDataTable.reloadData()
            let endIndex = (data?.toestellen.count)! - 1
            toestelDataTable.selectRow(at: IndexPath(row: endIndex, section: 0), animated: true, scrollPosition: .bottom)
            selectedRow = endIndex
            updateOverview(index: endIndex)
            nta = 2
            let neededData = Notification.Name("Data")
            NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id as Any])
        }
    }
    
    @objc func editOn()
    {
        edit_on = 1
        addToestel.isHidden = false
        merk?.isEnabled = true
        type?.isEnabled = true
        bouwjaar?.isEnabled = true
        freq?.isEnabled = true
        garantie?.isEnabled = true
        ogp?.isEnabled = true
        serienr?.isEnabled = true
        plaatsingdatum.isHidden = false
        plaatingDatumLabel.isHidden = true
        if data?.toestellen.count != 0 {
            if let index = toestelDataTable.indexPathForSelectedRow {
                let date = data?.toestellen[index.row].datum
                if date != nil {
                    plaatingDatumLabel?.text = dateFormat.string(from: date!)
                    plaatsingdatum.date = date!
                }
            }
        }
    }
    
    @objc func editOff()
    {
        edit_on = 0
        data = backupdata
        toestelamount = backupToestelAmount
        
        addToestel.isHidden = true
        merk?.isEnabled = false
        type?.isEnabled = false
        bouwjaar?.isEnabled = false
        freq?.isEnabled = false
        garantie?.isEnabled = false
        ogp?.isEnabled = false
        serienr?.isEnabled = false
        plaatsingdatum.isHidden = true
        plaatingDatumLabel.isHidden = false
        
        toestelDataTable.reloadData()
        toestelDataTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        selectedRow = 0
        if nieuw == 1
        {
            newKlant()
        }
        else if data?.toestellen.count == 0
        {
            emptyKlant()
        }
        else
        {
            updateOverview(index: 0)
        }
        if data?.toestellen.count != 0
        {
            let neededData = Notification.Name("Data")
            NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id as Any])
        }
        
    }
    
    // save the data to the online database
    @objc func save()
    {
        edit_on = 0
        if merk?.text != ""
        {
            if data?.toestellen.count == 0 && nieuw == 1
            {
                toestelamount! += 1
                let id = String(toestelamount!)
                let newRow = toestel3(klant_id: data?.klant_id ?? "", toestel_id: id, merk: "", type: "Nieuw Toestel", bouwjaar: "", freq: "", garantie: "", datum: Date(), serienr: "", OGP: "")
                data?.toestellen.append(newRow)
                updata(row: toestelDataTable.indexPathForSelectedRow!.row)
            }
            else
            {
                updata(row: toestelDataTable.indexPathForSelectedRow!.row)
            }
        }
        
        backupdata = data
        
        let verschil = toestelamount! - backupToestelAmount!
        if verschil != 0
        {
            for i in 1...verschil
            {
                let ni = (data?.toestellen.count)! - i
                if data?.toestellen[ni].merk != ""
                {
                    let create = createData()
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "dd-MM-yyyy"
                    let date = data?.toestellen[ni].datum
                    var datum = dateFormatterGet.string(from: date!) as String?
                    datum = datum!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
                    create.createToestel(
                        klant_id: (data?.toestellen[ni].klant_id) ?? "",
                        toestel_id: data?.toestellen[ni].toestel_id ?? "",
                        merk: data?.toestellen[ni].merk ?? "",
                        type: data?.toestellen[ni].type ?? "",
                        bouwjaar: data?.toestellen[ni].bouwjaar ?? "",
                        freq: data?.toestellen[ni].freq ?? "",
                        garantie: data?.toestellen[ni].garantie ?? "",
                        datum: datum ?? "",
                        serienr: data?.toestellen[ni].serienr ?? "",
                        OGP: data?.toestellen[ni].OGP ?? "")
                }
            }
        }
        
        backupToestelAmount = toestelamount
        nieuw = 0
        
        if nieuw != 1 && data?.onderhouden.count != 0
        {
            for current_toestel in (data?.toestellen)!
            {
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "dd-MM-yyyy"
                let date = current_toestel.datum
                var datum = dateFormatterGet.string(from: date) as String?
                datum = datum!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
                
                let update = updateData()
                update.updateToestel(
                    klant_id: current_toestel.klant_id,
                    toestel_id: current_toestel.toestel_id,
                    merk: current_toestel.merk,
                    type: current_toestel.type,
                    bouwjaar: current_toestel.bouwjaar,
                    freq: current_toestel.freq,
                    garantie: current_toestel.garantie,
                    datum: datum ?? "",
                    serienr: current_toestel.serienr,
                    OGP: current_toestel.OGP)
            }
        }
        let neededData = Notification.Name("Data")
        NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id as Any])
        
        toestelDataTable.reloadData()
        toestelDataTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        selectedRow = 0
        if nieuw == 1
        {
            newKlant()
        }
        else if data?.toestellen.count == 0
        {
            emptyKlant()
        }
        else
        {
            updateOverview(index: 0)
        }
    }
}

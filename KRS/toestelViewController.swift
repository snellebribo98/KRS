//
//  toestelViewController.swift
//  KRS
//
//  Created by Wessel Mel on 24/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit

class toestelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nieuw: Int?
    var data: Klant3?
    let dateFormat = DateFormatter()
    var nt: Int?
    var addtoestel: Int?
    
    
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
        
        dateFormat.dateStyle = .full
        dateFormat.timeStyle = .none
        dateFormat.locale = Locale(identifier: "nl_NL")

        toestelDataTable.delegate = self
        toestelDataTable.dataSource = self
        toestelDataTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        
        let neededData = Notification.Name("Data")
        print(toestelDataTable.indexPathForSelectedRow!.row)
        if data?.toestellen.count != 0 {
            NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id])
        }
        
        if nieuw == 1 {
            newKlant()
            addToestel.isHidden = false
        } else if data != nil {
            existingKlant()
            print("TOESTELLEN")
            print(data?.toestellen)
            addToestel.isHidden = true
        }
        let edited = Notification.Name("edit")
        let edited2 = Notification.Name("edit2")
        let edited3 = Notification.Name("edit3")
        NotificationCenter.default.addObserver(self, selector: #selector(toestelViewController.editOn), name:
            edited, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toestelViewController.editOff), name:
            edited2, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toestelViewController.save), name:
            edited3, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func editOn() {
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
//            else {
//                let date = data?.toestellen[0].datum
//                if date != nil {
//                    plaatingDatumLabel?.text = dateFormat.string(from: date!)
//                    plaatsingdatum.date = date!
//                }
//            }
        }
        
        
        
    }
    
    @objc func editOff() {
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
        if data?.toestellen.count != 0 {
            let endIndex = (data?.toestellen.count)! - 1
            if data?.toestellen[endIndex].type == "Nieuw Toestel" {
                data?.toestellen.remove(at: endIndex)
            }
        }
        
        toestelDataTable.reloadData()
        toestelDataTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        if data?.toestellen.count != 0 {
            merk?.text = data?.toestellen[0].merk
            type?.text = data?.toestellen[0].type
            bouwjaar?.text = data?.toestellen[0].bouwjaar
            freq?.text = data?.toestellen[0].freq
            garantie?.text = data?.toestellen[0].garantie
            ogp?.text = data?.toestellen[0].OGP
            let date = data?.toestellen[0].datum
            plaatingDatumLabel?.text = dateFormat.string(from: date!)
            plaatsingdatum?.date = date!
            serienr?.text = data?.toestellen[0].serienr
        }
        let neededData = Notification.Name("Data")
        NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id])
    }
    
    @objc func save() {
        if addtoestel == 1 {
            let create = createData()
            let endIndex = (data?.toestellen.count)! - 1
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd-MM-yyyy"
            let date = data?.toestellen[endIndex].datum
            var datum = dateFormatterGet.string(from: date!) as String?
            datum = datum!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
            create.createToestel(
            klant_id: data?.toestellen[endIndex].klant_id ?? "",
            toestel_id: data?.toestellen[endIndex].toestel_id ?? "",
            merk: data?.toestellen[endIndex].merk ?? "",
            type: data?.toestellen[endIndex].type ?? "",
            bouwjaar: data?.toestellen[endIndex].bouwjaar ?? "",
            freq: data?.toestellen[endIndex].freq ?? "",
            garantie: data?.toestellen[endIndex].garantie ?? "",
            datum: datum ?? "",
            serienr: data?.toestellen[endIndex].serienr ?? "",
            OGP: data?.toestellen[endIndex].serienr ?? "")
        }
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
        plaatingDatumLabel.text = dateFormat.string(from: plaatsingdatum.date)
        if nieuw != 1 {
            let len = data?.toestellen.count
            let ip = toestelDataTable.indexPathForSelectedRow
            updata(indexPath: ip!)
            if len! > 1 {
                for index in 0..<len! {
                    updatetoestel(index: index)
                }
            } else if len == 1 {
                let index = 0
                updatetoestel(index: index)
            }
        }
        toestelDataTable.reloadData()
        toestelDataTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        merk?.text = data?.toestellen[0].merk
        type?.text = data?.toestellen[0].type
        bouwjaar?.text = data?.toestellen[0].bouwjaar
        freq?.text = data?.toestellen[0].freq
        garantie?.text = data?.toestellen[0].garantie
        ogp?.text = data?.toestellen[0].OGP
        let date = data?.toestellen[0].datum
        plaatingDatumLabel?.text = dateFormat.string(from: date!)
        plaatsingdatum?.date = date!
        serienr?.text = data?.toestellen[0].serienr
        
        let neededData = Notification.Name("Data")
        NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id])
    }
    
    func updatetoestel(index: Int) {
        let klant_id = data?.klant_id
        let toestel_id: String?
        toestel_id = data?.toestellen[index].toestel_id
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        let date = data?.toestellen[index].datum
        var datum = dateFormatterGet.string(from: date!) as String?
        datum = datum!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        let update = updateData()
        update.updateToestel(klant_id: klant_id ?? "", toestel_id: toestel_id ?? "", merk: data?.toestellen[index].merk ?? "", type: data?.toestellen[index].type ?? "", bouwjaar: data?.toestellen[index].bouwjaar ?? "", freq: data?.toestellen[index].freq ?? "", garantie: data?.toestellen[index].garantie ?? "", datum: datum ?? "", serienr: data?.toestellen[index].serienr ?? "", OGP: data?.toestellen[index].OGP ?? "")
    }
    
    func updata(indexPath: IndexPath) {
        if merk?.text != data?.toestellen[indexPath.row].merk {
            data?.toestellen[indexPath.row].merk = merk?.text ?? ""
        }
        if type?.text != data?.toestellen[indexPath.row].type {
            data?.toestellen[indexPath.row].type = type?.text ?? ""
        }
        if bouwjaar?.text != data?.toestellen[indexPath.row].bouwjaar {
            data?.toestellen[indexPath.row].bouwjaar = bouwjaar?.text ?? ""
        }
        if freq?.text != data?.toestellen[indexPath.row].freq {
            data?.toestellen[indexPath.row].freq = freq?.text ?? ""
        }
        if garantie?.text != data?.toestellen[indexPath.row].garantie {
            data?.toestellen[indexPath.row].garantie = garantie?.text ?? ""
        }
        if ogp?.text != data?.toestellen[indexPath.row].OGP {
            data?.toestellen[indexPath.row].OGP = ogp?.text ?? ""
        }
        if serienr?.text != data?.toestellen[indexPath.row].serienr {
            data?.toestellen[indexPath.row].serienr = serienr?.text ?? ""
        }
        let date = data?.toestellen[indexPath.row].datum
        print(date)
        let date2 = plaatsingdatum?.date
        print(date2)
        if date != nil {
            if date != date2 {
                data?.toestellen[indexPath.row].datum = date2!
            }
        }
    }
    
    func newKlant() {
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
        
        
    }
    
    func existingKlant() {
        if data?.toestellen.count == 0 {
            newKlant()
            plaatingDatumLabel?.text = "Onbekend"
        } else {
            merk?.text = data?.toestellen[0].merk
            type?.text = data?.toestellen[0].type
            bouwjaar?.text = data?.toestellen[0].bouwjaar
            freq?.text = data?.toestellen[0].freq
            garantie?.text = data?.toestellen[0].garantie
            ogp?.text = data?.toestellen[0].OGP
            let date = data?.toestellen[0].datum
            plaatingDatumLabel?.text = dateFormat.string(from: date!)
            plaatsingdatum?.date = date!
            serienr?.text = data?.toestellen[0].serienr
        }
        merk?.isEnabled = false
        type?.isEnabled = false
        bouwjaar?.isEnabled = false
        freq?.isEnabled = false
        garantie?.isEnabled = false
        ogp?.isEnabled = false
        serienr?.isEnabled = false
        plaatsingdatum.isHidden = true
        plaatingDatumLabel.isHidden = false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data != nil && data?.toestellen.count != 0 {
            return data!.toestellen.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toestelDataTable.dequeueReusableCell(withIdentifier: "toestelCell", for: indexPath)
        if data != nil && data?.toestellen.count != 0{
            cell.textLabel?.text = data?.toestellen[indexPath.row].type
            return cell
        } else {
            cell.textLabel?.text = "Nieuw Toestel"
            nt = 1
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("test")
        updata(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TES")
        if data?.toestellen.count != 0 {
            merk?.text = data?.toestellen[indexPath.row].merk
            type?.text = data?.toestellen[indexPath.row].type
            bouwjaar?.text = data?.toestellen[indexPath.row].bouwjaar
            freq?.text = data?.toestellen[indexPath.row].freq
            garantie?.text = data?.toestellen[indexPath.row].garantie
            ogp?.text = data?.toestellen[indexPath.row].OGP
            let date = data?.toestellen[indexPath.row].datum
            print(date)
            if date != nil {
                plaatingDatumLabel?.text = dateFormat.string(from: date!)
                plaatsingdatum.date = date!
            }
            serienr?.text = data?.toestellen[indexPath.row].serienr
            let neededData = Notification.Name("Data")
            NotificationCenter.default.post(name: neededData, object: nil, userInfo: ["Toestel": data?.toestellen[toestelDataTable.indexPathForSelectedRow!.row].toestel_id])
            
        }
        
    }
    
    @IBAction func addToestel(_ sender: Any) {
        
        if nt == 1 {
            
        } else {
            addtoestel = 1
            let id = String((data?.toestellen.count)! + 1)
            let newRow = toestel3(klant_id: data?.klant_id ?? "", toestel_id: id, merk: "", type: "Nieuw Toestel", bouwjaar: "", freq: "", garantie: "", datum: Date(), serienr: "", OGP: "")
            data?.toestellen.append(newRow)
            toestelDataTable.reloadData()
            let endIndex = (data?.toestellen.count)! - 1
            toestelDataTable.selectRow(at: IndexPath(row: endIndex, section: 0), animated: true, scrollPosition: .top)
            merk?.text = data?.toestellen[endIndex].merk
            type?.text = data?.toestellen[endIndex].type
            bouwjaar?.text = data?.toestellen[endIndex].bouwjaar
            freq?.text = data?.toestellen[endIndex].freq
            garantie?.text = data?.toestellen[endIndex].garantie
            ogp?.text = data?.toestellen[endIndex].OGP
            let date = data?.toestellen[endIndex].datum
            plaatingDatumLabel?.text = dateFormat.string(from: date!)
            plaatsingdatum?.date = date!
            serienr?.text = data?.toestellen[endIndex].serienr
        }
    }
    

}

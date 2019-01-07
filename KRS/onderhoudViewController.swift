//
//  onderhoudViewController.swift
//  KRS
//
//  Created by Wessel Mel on 24/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit

class onderhoudViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    

    var nieuw: Int?
    var data: Klant3?
    let dateFormat = DateFormatter()
    let monteurs = ["Albert Mel", "Mike Visser", "Bart Dekker"]
    var needed_toestel_id: String?
    var needed_data = [onderhoud3]()
    
    
    
    @IBOutlet weak var onderhoudTableView: DesignableTableView!
    @IBOutlet weak var onderhoudsdatum: UIDatePicker!
    @IBOutlet weak var monteur: UIPickerView!
    @IBOutlet weak var werkzaamheden: DesignableTextView!
    @IBOutlet weak var Opmerkingen: DesignableTextView!
    @IBOutlet weak var datumLabel: UILabel!
    @IBOutlet weak var monteurLabel: UILabel!
    @IBOutlet weak var datumStackView: UIStackView!
    @IBOutlet weak var monteurStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormat.dateStyle = .full
        dateFormat.timeStyle = .none
        dateFormat.locale = Locale(identifier: "nl_NL")
        
        onderhoudTableView.delegate = self
        onderhoudTableView.dataSource = self
        onderhoudTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        monteur.delegate = self
        monteur.dataSource = self
        
        let edited = Notification.Name("edit")
        let edited2 = Notification.Name("edit2")
        let edited3 = Notification.Name("edit3")
        let neededData = Notification.Name("Data")
        NotificationCenter.default.addObserver(self, selector: #selector(onderhoudViewController.editOn), name:
            edited, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onderhoudViewController.editOff), name:
            edited2, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onderhoudViewController.save), name:
            edited3, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onderhoudViewController.datafunc), name: neededData, object: nil)
        
        
        if nieuw == 1 {
            newKlant()
        } else if data != nil {
            existingKlant()
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func editOn() {
        datumLabel.isHidden = true
        onderhoudsdatum.isHidden = false
        monteurLabel.isHidden = true
        monteur.isHidden = false
        werkzaamheden.isSelectable = true
        werkzaamheden.isEditable = true
        Opmerkingen.isSelectable = true
        Opmerkingen.isEditable = true
        if needed_data.count != 0 {
            if let index = onderhoudTableView.indexPathForSelectedRow {
                let date = needed_data[index.row].onderhoudsdatum
                let monteur2 = needed_data[index.row].monteur
                var row: Int?
                for i in 0...monteurs.count-1 {
                    if monteurs[i] == monteur2 {
                        row = i
                    }
                }
                onderhoudsdatum.date = date
                monteur.selectRow(row!, inComponent: 0, animated: true)
            }
//            else {
//                let date = needed_data[0].onderhoudsdatum
//                onderhoudsdatum.date = date
//                let nr = needed_data[0].monteur
//                var row: Int?
//                for i in 0...monteurs.count-1 {
//                    if monteurs[i] == nr {
//                        row = i
//                    }
//                }
//                monteur.selectRow(row!, inComponent: 0, animated: true)
//            }
        }
        
        
    }
    
    @objc func editOff() {
        datumLabel.isHidden = false
        onderhoudsdatum.isHidden = true
        monteurLabel.isHidden = false
        monteur.isHidden = true
        werkzaamheden.isSelectable = false
        werkzaamheden.isEditable = false
        Opmerkingen.isSelectable = false
        Opmerkingen.isEditable = false
        let endIndex = needed_data.count - 1
        if needed_data[endIndex].opmerkingen == "Nieuw Onderhoud" {
            needed_data.remove(at: endIndex)
        }
        onderhoudTableView.reloadData()
        onderhoudTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        let onderhoudsdatum2 = needed_data[0].onderhoudsdatum
        datumLabel?.text = dateFormat.string(from: onderhoudsdatum2)
        onderhoudsdatum?.date = needed_data[0].onderhoudsdatum
        let monteur2 = needed_data[0].monteur
        var row: Int?
        for i in 0...monteurs.count-1 {
            if monteurs[i] == monteur2 {
                row = i
            }
        }
        monteur.selectRow(row!, inComponent: 0, animated: true)
        monteurLabel?.text = monteur2
        werkzaamheden?.text = needed_data[0].werkzaamheden
        Opmerkingen?.text = needed_data[0].opmerkingen
    }
    
    @objc func save() {
        datumLabel.isHidden = false
        onderhoudsdatum.isHidden = true
        dateFormat.dateStyle = .full
        dateFormat.timeStyle = .none
        dateFormat.locale = Locale(identifier: "nl_NL")
        datumLabel.text = dateFormat.string(from: onderhoudsdatum.date)
        
        monteurLabel.isHidden = false
        monteur.isHidden = true
        monteurLabel.text = monteurs[monteur.selectedRow(inComponent: 0)]
        
        werkzaamheden.isSelectable = false
        werkzaamheden.isEditable = false
        Opmerkingen.isSelectable = false
        Opmerkingen.isEditable = false
        if nieuw != 1 {
            let len = needed_data.count
            let ip = onderhoudTableView.indexPathForSelectedRow
            updata(indexPath: ip!, toestel_id: needed_toestel_id!)
            if len > 1 {
                for index in 0..<len {
                    updateOnderhoud(index: index)
                }
            } else if len == 1 {
                let index = 0
                updateOnderhoud(index: index)
            }
        }
        onderhoudTableView.reloadData()
        onderhoudTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        let onderhoudsdatum2 = needed_data[0].onderhoudsdatum
        datumLabel?.text = dateFormat.string(from: onderhoudsdatum2)
        onderhoudsdatum?.date = needed_data[0].onderhoudsdatum
        let monteur2 = needed_data[0].monteur
        var row: Int?
        for i in 0...monteurs.count-1 {
            if monteurs[i] == monteur2 {
                row = i
            }
        }
        monteur.selectRow(row!, inComponent: 0, animated: true)
        monteurLabel?.text = monteur2
        werkzaamheden?.text = needed_data[0].werkzaamheden
        Opmerkingen?.text = needed_data[0].opmerkingen
    }
    
    func updateOnderhoud(index: Int) {
        let klant_id = data?.klant_id
        let toestel_id = needed_toestel_id
        var datum: String?
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        let date = needed_data[index].onderhoudsdatum
        datum = dateFormatterGet.string(from: date)
        datum = datum!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil) as String?
        let monteur: String?
        monteur = needed_data[index].monteur
        let update = updateData()
        update.updateOnderhoud(klant_id: klant_id ?? "", toestel_id: toestel_id ?? "", onderhoudsdatum: datum ?? "", monteur: monteur ?? "", werkzaamheden: needed_data[index].werkzaamheden, opmerkingen: needed_data[index].opmerkingen)
    }
    
    func updata(indexPath: IndexPath, toestel_id: String) {
        // HIER GEBLEVEN
    }
    
    @objc func datafunc(notification: Notification) {
        needed_toestel_id = notification.userInfo!["toestel_id"] as! String?
        let count = data?.onderhouden.count
        for index in 0..<count! {
            if needed_toestel_id != nil {
                if needed_toestel_id == data?.onderhouden[index].toestel_id {
                    needed_data.append((data?.onderhouden[index])!)
                }
            }
        }
    }

    func newKlant() {
        datumLabel.isHidden = true
        onderhoudsdatum.isHidden = false
        monteurLabel.isHidden = true
        monteur.isHidden = false
        werkzaamheden?.text = ""
        Opmerkingen?.text = ""
        
        werkzaamheden.isSelectable = true
        werkzaamheden.isEditable = true
        Opmerkingen.isSelectable = true
        Opmerkingen.isEditable = true
    }
    
    func emptyKlant() {
        datumLabel.isHidden = false
        datumLabel.text = "Onbekend"
        onderhoudsdatum.isHidden = true
        monteurLabel.isHidden = false
        monteurLabel.text = "Onbekend"
        monteur.isHidden = true
        werkzaamheden?.text = ""
        Opmerkingen?.text = ""
        
        werkzaamheden.isSelectable = false
        werkzaamheden.isEditable = false
        Opmerkingen.isSelectable = false
        Opmerkingen.isEditable = false
    }
    
    func existingKlant() {
        if needed_data.count == 0 {
            emptyKlant()
        } else {
            let date = needed_data[0].onderhoudsdatum
            dateFormat.dateStyle = .full
            datumLabel?.text = dateFormat.string(from: date)
            monteurLabel?.text = needed_data[0].monteur
            werkzaamheden?.text = needed_data[0].werkzaamheden
            Opmerkingen?.text = needed_data[0].opmerkingen
            
            datumLabel.isHidden = false
            onderhoudsdatum.isHidden = true
            monteurLabel.isHidden = false
            monteur.isHidden = true
            werkzaamheden.isSelectable = false
            werkzaamheden.isEditable = false
            Opmerkingen.isSelectable = false
            Opmerkingen.isEditable = false
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if needed_data.count != 0 {
            return needed_data.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = onderhoudTableView.dequeueReusableCell(withIdentifier: "onderhoudCell", for: indexPath)
        if needed_data.count != 0 {
            let date = needed_data[indexPath.row].onderhoudsdatum
            dateFormat.dateStyle = .short
            let werkzaamheden = needed_data[indexPath.row].werkzaamheden
            cell.textLabel?.text = "\(dateFormat.string(from: date)) \(werkzaamheden)"
            return cell
        } else {
            cell.textLabel?.text = "Nieuw Onderhoud"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if nieuw == 1  {
            newKlant()
        } else if needed_data.count == 0 {
            emptyKlant()
        } else {
            print(data?.onderhouden.count)
            let date = needed_data[indexPath.row].onderhoudsdatum
            dateFormat.dateStyle = .full
            if date != nil {
                datumLabel?.text = dateFormat.string(from: date)
                onderhoudsdatum.date = date
            }
            monteurLabel?.text = needed_data[indexPath.row].monteur
            let monteur2 = needed_data[indexPath.row].monteur
            var row: Int?
            for i in 0...monteurs.count-1 {
                if monteurs[i] == monteur2 {
                    row = i
                }
            }
            monteur.selectRow(row!, inComponent: 0, animated: true)
            werkzaamheden?.text = needed_data[indexPath.row].werkzaamheden
            Opmerkingen?.text = needed_data[indexPath.row].opmerkingen
        }
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
    
    
}

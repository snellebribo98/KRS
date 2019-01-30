//
//  ohViewController.swift
//  KRS
//
//  Created by Wessel Mel on 14/01/2019.
//  Copyright © 2019 Wessel Mel. All rights reserved.
//

import UIKit

class ohViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // variables
    var nieuw: Int?
    var data: Klant3?
    var backupdata: Klant3?
    let dateFormat = DateFormatter()
    let monteurs = ["Albert Mel", "Mike Visser", "Bart Dekker"]
    var needed_toestel_id: String?
    var needed_data = [onderhoud3]()
    var klantamount: Int?
    var toestelamount: Int?
    var onderhoudamount: Int?
    var backuponderhoudamount: Int?
    var noa: Int?
    var selectedRow: Int = 0
    var edit_on: Int = 0
    var addonderhoud = 0
    
    // outlets
    @IBOutlet weak var onderhoudTableView: DesignableTableView!
    @IBOutlet weak var onderhoudsdatum: UIDatePicker!
    @IBOutlet weak var monteur: UIPickerView!
    @IBOutlet weak var werkzaamheden: DesignableTextView!
    @IBOutlet weak var Opmerkingen: DesignableTextView!
    @IBOutlet weak var datumLabel: UILabel!
    @IBOutlet weak var monteurLabel: UILabel!
    @IBOutlet weak var datumStackView: UIStackView!
    @IBOutlet weak var monteurStackView: UIStackView!
    @IBOutlet weak var addOnderhoud: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backupdata = data
        backuponderhoudamount = onderhoudamount
        
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
        
        if data?.onderhouden.count != 0 && nieuw != 1
        {
            get_needed_data(toestel_id: ((data?.onderhouden[0].toestel_id)!))
        }
        
        if nieuw == 1
        {
            newKlant()
        }
        else if needed_data.count == 0
        {
            emptyKlant()
        }
        else
        {
            get_needed_data(toestel_id: (data?.onderhouden[0].toestel_id)!)
            updateOverview(index: 0)
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nieuw != 1 || data?.onderhouden.count != 0
        {
            if needed_data.count != 0
            {
                return needed_data.count
            }
            else
            {
                return 1
            }
        }
        else
        {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = onderhoudTableView!.dequeueReusableCell(withIdentifier: "onderhoudCell", for: indexPath)
        noa = 0
        if needed_data.count != 0
        {
            dateFormat.dateStyle = .short
            let date = needed_data[indexPath.row].onderhoudsdatum
            let werkzaamheden = needed_data[indexPath.row].werkzaamheden
            cell.textLabel?.text = "\(dateFormat.string(from: date)) \(werkzaamheden)"
            if werkzaamheden == ""
            {
                noa = 2
            }
            return cell
        }
        else
        {
            cell.textLabel?.text = "Nieuw Onderhoud"
            noa = 1
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if needed_data.count != 0
        {
            updata(nr: 3, row: selectedRow)
        }
        
        selectedRow = indexPath.row
        if nieuw == 1
        {
            if needed_data.count != 0
            {
                updateOverview(index: selectedRow)
            }
            else
            {
                newKlant()
            }
        }
        else if noa == 1
        {
            if edit_on == 1{
                newKlant()
            }
            else
            {
                emptyKlant()
            }
        }
        else
        {
            let index = onderhoudTableView.indexPathForSelectedRow?.row
            updateOverview(index: index)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        monteurLabel?.text = monteurs[row]
    }
    
    // update the data locally
    func updata(nr: Int, row: Int)
    {
        if nr == 1
        {
            if needed_data[row].onderhoudsdatum != onderhoudsdatum.date
            {
               needed_data[row].onderhoudsdatum = onderhoudsdatum.date
            }
            // monteur
            if needed_data[row].monteur != monteurs[monteur.selectedRow(inComponent: 0)]
            {
               needed_data[row].monteur = monteurs[monteur.selectedRow(inComponent: 0)]
            }
            // werkzaamheden
            if needed_data[row].werkzaamheden != werkzaamheden.text
            {
               needed_data[row].werkzaamheden = werkzaamheden.text
            }
            // opmerkingen
            if needed_data[row].opmerkingen != Opmerkingen.text
            {
               needed_data[row].opmerkingen = Opmerkingen.text
            }
        }
        else if nr == 2
        {
            var chosendatarow: Int?
            for index in 0..<(data?.onderhouden.count)!
            {
                if data?.onderhouden[index].onderhoud_id == needed_data[row].onderhoud_id
                {
                    chosendatarow = index
                    break
                }
            }
            while chosendatarow == nil
            {
                
            }
            if data?.onderhouden[chosendatarow!].onderhoudsdatum != onderhoudsdatum.date
            {
                data?.onderhouden[chosendatarow!].onderhoudsdatum = onderhoudsdatum.date
            }
            // monteur
            if data?.onderhouden[chosendatarow!].monteur != monteurs[monteur.selectedRow(inComponent: 0)]
            {
               data?.onderhouden[chosendatarow!].monteur = monteurs[monteur.selectedRow(inComponent: 0)]
            }
            // werkzaamheden
            if data?.onderhouden[chosendatarow!].werkzaamheden != werkzaamheden.text
            {
                data?.onderhouden[chosendatarow!].werkzaamheden = werkzaamheden.text
            }
            // opmerkingen
            if data?.onderhouden[chosendatarow!].opmerkingen != Opmerkingen.text
            {
               data?.onderhouden[chosendatarow!].opmerkingen = Opmerkingen.text
            }
        }
        else if nr == 3
        {
            updata(nr: 1, row: row)
            updata(nr: 2, row: row)
        }
    }
    
    func newKlant()
    {
        addOnderhoud.isHidden = false
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
        
        edit_on = 1
    }
    
    func emptyKlant()
    {
        addOnderhoud.isHidden = true
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
    
    // update the data displayed
    func updateOverview(index: Int?)
    {
        if edit_on == 0
        {
            addOnderhoud.isHidden = true
            
            datumLabel.isHidden = false
            let date = needed_data[index!].onderhoudsdatum
            dateFormat.dateStyle = .full
            datumLabel.text = dateFormat.string(from: date)
            
            onderhoudsdatum.isHidden = true
            onderhoudsdatum.date = date
            
            let currentmonteur = needed_data[index!].monteur
            monteurLabel?.text = currentmonteur
            monteurLabel.isHidden = false
            
            var row: Int?
            for i in 0..<monteurs.count
            {
                if monteurs[i] == currentmonteur
                {
                    row = i
                    break
                }
            }
            monteur.selectRow(row!, inComponent: 0, animated: true)
            monteur.isHidden = true
            
            werkzaamheden.isSelectable = false
            werkzaamheden.isEditable = false
            werkzaamheden.text = needed_data[index!].werkzaamheden
            
            Opmerkingen.isSelectable = false
            Opmerkingen.isEditable = false
            Opmerkingen.text = needed_data[index!].opmerkingen
        }
        else if edit_on == 1
        {
            addOnderhoud.isHidden = false
            
            datumLabel.isHidden = true
            let date = needed_data[index!].onderhoudsdatum
            dateFormat.dateStyle = .full
            datumLabel.text = dateFormat.string(from: date)
            
            onderhoudsdatum.isHidden = false
            onderhoudsdatum.date = date
            
            let currentmonteur = needed_data[index!].monteur
            monteurLabel?.text = currentmonteur
            
            var row: Int?
            for i in 0..<monteurs.count
            {
                if monteurs[i] == currentmonteur
                {
                    row = i
                    break
                }
            }
            monteur.selectRow(row!, inComponent: 0, animated: true)
            
            werkzaamheden.isSelectable = true
            werkzaamheden.isEditable = true
            werkzaamheden.text = needed_data[index!].werkzaamheden
            
            Opmerkingen.isSelectable = true
            Opmerkingen.isEditable = true
            Opmerkingen.text = needed_data[index!].opmerkingen
        }
        
    }
    
    // get the needed data from a toestel
    func get_needed_data(toestel_id: String)
    {
        needed_data.removeAll()
        needed_toestel_id = toestel_id
        let count = data?.onderhouden.count
        for index in 0..<count!
        {
            if needed_toestel_id == data?.onderhouden[index].toestel_id
            {
                needed_data.append((data?.onderhouden[index])!)
            }
        }
    }
    
    // add onderhoud
    @IBAction func addOnderhoud(_ sender: Any)
    {
        if needed_toestel_id == nil
        {
            toestelamount! += 1
            needed_toestel_id = String(toestelamount!)
        }
        if noa == 1
        {
            if werkzaamheden?.text == ""
            {
                let alert = UIAlertController(title: "Vul in", message: "Vul werkzaamheden in!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else
            {
                if monteurLabel.text == "Onbekend"
                {
                    monteurLabel.text = monteurs[0]
                }
                onderhoudamount! += 1
                var id = String(onderhoudamount! - 1)
                var newRow = onderhoud3(klant_id: data?.klant_id ?? "", toestel_id: needed_toestel_id ?? "", onderhoudsdatum: Date(), monteur: monteurs[0], werkzaamheden: "", opmerkingen: "", onderhoud_id: id)
                data?.onderhouden.append(newRow)
                needed_data.append(newRow)
                updata(nr: 3, row: onderhoudTableView.indexPathForSelectedRow!.row)
                
                
                onderhoudamount! += 1
                id = String(onderhoudamount! - 1)
                newRow = onderhoud3(klant_id: data?.klant_id ?? "", toestel_id: needed_toestel_id ?? "", onderhoudsdatum: Date(), monteur: monteurs[0], werkzaamheden: "", opmerkingen: "", onderhoud_id: id)
                data?.onderhouden.append(newRow)
                needed_data.append(newRow)
                onderhoudTableView.reloadData()
                let endIndex = needed_data.count - 1
                onderhoudTableView.selectRow(at: IndexPath(row: endIndex, section: 0), animated: true, scrollPosition: .bottom)
                selectedRow = endIndex
                updateOverview(index: endIndex)
            }
        }
        else if noa == 2
        {
            if monteurLabel.text == "Onbekend"
            {
                monteurLabel.text = monteurs[0]
            }
            onderhoudamount! += 1
            let id = String(onderhoudamount! - 1)
            let newRow = onderhoud3(klant_id: data?.klant_id ?? "", toestel_id: needed_toestel_id ?? "", onderhoudsdatum: Date(), monteur: monteurs[0], werkzaamheden: "", opmerkingen: "", onderhoud_id: id)
            data?.onderhouden.append(newRow)
            needed_data.append(newRow)
            updata(nr: 3, row: onderhoudTableView.indexPathForSelectedRow!.row)
            
            
            onderhoudTableView.reloadData()
            let endIndex = needed_data.count - 1
            onderhoudTableView.selectRow(at: IndexPath(row: endIndex, section: 0), animated: true, scrollPosition: .bottom)
            selectedRow = endIndex
            updateOverview(index: endIndex)
        }
        else
        {
            updata(nr: 3, row: selectedRow)
            onderhoudamount! += 1
            let id = String(onderhoudamount! - 1)
            let newRow = onderhoud3(klant_id: data?.klant_id ?? "", toestel_id: needed_toestel_id ?? "", onderhoudsdatum: Date(), monteur: monteurs[0], werkzaamheden: "", opmerkingen: "", onderhoud_id: id)
            data?.onderhouden.append(newRow)
            needed_data.append(newRow)
            onderhoudTableView.reloadData()
            let endIndex = needed_data.count - 1
            onderhoudTableView.selectRow(at: IndexPath(row: endIndex, section: 0), animated: true, scrollPosition: .bottom)
            selectedRow = endIndex
            updateOverview(index: endIndex)
            noa = 2
        }
    }
    
    
    
    
    // objc functions
    @objc func editOn()
    {
        edit_on = 1
        addOnderhoud.isHidden = false
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
                        break
                    }
                }
                onderhoudsdatum.date = date
                monteur.selectRow(row!, inComponent: 0, animated: true)
            }
        }
    }
    
    @objc func editOff()
    {
        edit_on = 0
        addOnderhoud.isHidden = true
        datumLabel.isHidden = false
        onderhoudsdatum.isHidden = true
        monteurLabel.isHidden = false
        monteur.isHidden = true
        werkzaamheden.isSelectable = false
        werkzaamheden.isEditable = false
        Opmerkingen.isSelectable = false
        Opmerkingen.isEditable = false
        data = backupdata
        onderhoudamount = backuponderhoudamount
        if data?.onderhouden.count != 0
        {
            get_needed_data(toestel_id: (data?.onderhouden[0].toestel_id)!)
        }
        
        onderhoudTableView.reloadData()
        onderhoudTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        selectedRow = 0
        if nieuw == 1
        {
            newKlant()
        }
        else if needed_data.count == 0
        {
            emptyKlant()
        }
        else
        {
            updateOverview(index: 0)
        }
    }
    
    @objc func save()
    {
        edit_on = 0
        if werkzaamheden?.text != ""
        {
            if data?.onderhouden.count == 0
            {
                if monteurLabel.text == "Onbekend"
                {
                    monteurLabel.text = monteurs[0]
                }
                onderhoudamount! += 1
                let id = String(onderhoudamount! - 1)
                let newRow = onderhoud3(klant_id: data?.klant_id ?? "", toestel_id: needed_toestel_id ?? "", onderhoudsdatum: Date(), monteur: monteurs[0], werkzaamheden: "", opmerkingen: "", onderhoud_id: id)
                data?.onderhouden.append(newRow)
                needed_data.append(newRow)
                updata(nr: 3, row: onderhoudTableView.indexPathForSelectedRow!.row)
            }
            else
            {
                updata(nr: 3, row: selectedRow)
            }
            
        }
        
        backupdata = data
        
        let verschil = onderhoudamount! - backuponderhoudamount!
        if verschil != 0
        {
            for i in 1...verschil
            {
                let ni = (data?.onderhouden.count)! - i
                if data?.onderhouden[ni].werkzaamheden != ""
                {
                    let create = createData()
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "dd-MM-yyyy"
                    let date = data?.onderhouden[ni].onderhoudsdatum
                    var datum = dateFormatterGet.string(from: date!) as String?
                    datum = datum!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
                    create.createOnderhoud(
                        klant_id: data?.onderhouden[ni].klant_id ?? "",
                        toestel_id: data?.onderhouden[ni].toestel_id ?? "",
                        onderhoudsdatum: datum ?? "",
                        monteur: data?.onderhouden[ni].monteur ?? "",
                        werkzaamheden: data?.onderhouden[ni].werkzaamheden ?? "",
                        opmerkingen: data?.onderhouden[ni].opmerkingen ?? "",
                        onderhoud_id: data?.onderhouden[ni].onderhoud_id ?? "")
                }
            }
        }
        backuponderhoudamount = onderhoudamount
        nieuw = 0
        
        // update onderhoud
        if nieuw != 1 && data?.onderhouden.count != 0
        {
            for current_onderhoud in (data?.onderhouden)!
            {
                var datum: String?
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "dd-MM-yyyy"
                datum = dateFormatterGet.string(from: current_onderhoud.onderhoudsdatum)
                datum = datum!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
                
                let update = updateData()
                update.updateOnderhoud(klant_id: current_onderhoud.klant_id , toestel_id: current_onderhoud.toestel_id , onderhoudsdatum: datum ?? "", monteur: current_onderhoud.monteur , werkzaamheden: current_onderhoud.werkzaamheden , opmerkingen: current_onderhoud.opmerkingen, onderhoud_id: current_onderhoud.onderhoud_id)
            }
            get_needed_data(toestel_id: (data?.onderhouden[0].toestel_id)!)
        }
        // update table and view
        onderhoudTableView.reloadData()
        onderhoudTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        selectedRow = 0
        if nieuw == 1
        {
            newKlant()
        }
        else if needed_data.count == 0
        {
            emptyKlant()
        }
        else
        {
            updateOverview(index: 0)
        }
        
    }
    
    @objc func datafunc(notification: Notification)
    {
        if werkzaamheden?.text != ""
        {
            if needed_data.count == 0
            {
                needed_toestel_id = notification.userInfo!["Toestel"] as? String
                if monteurLabel.text == "Onbekend"
                {
                    monteurLabel.text = monteurs[0]
                }
                onderhoudamount! += 1
                let id = String(onderhoudamount! - 1)
                let newRow = onderhoud3(klant_id: data?.klant_id ?? "", toestel_id: needed_toestel_id ?? "", onderhoudsdatum: Date(), monteur: monteurs[0], werkzaamheden: "", opmerkingen: "", onderhoud_id: id)
                data?.onderhouden.append(newRow)
                needed_data.append(newRow)
                updata(nr: 3, row: onderhoudTableView.indexPathForSelectedRow!.row)
            }
            else
            {
                updata(nr: 3, row: selectedRow)
            }
        }
        
        // set selectedrow
        selectedRow = 0
        
        // empty the needed_data list
        needed_data.removeAll()
        
        // call the current toestel_id
        needed_toestel_id = notification.userInfo!["Toestel"] as? String
        
        // fill needed_data
        get_needed_data(toestel_id: needed_toestel_id!)
        
        // update the tableview and overview
        onderhoudTableView.reloadData()
        onderhoudTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        if nieuw == 1
        {
            newKlant()
        }
        else if needed_data.count == 0
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
            updateOverview(index: 0)
        }
    }
}

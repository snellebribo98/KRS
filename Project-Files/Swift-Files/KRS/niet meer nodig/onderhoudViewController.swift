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
    var needed_toestel_id = "0"
    var needed_data = [onderhoud3]()
    var klantamount: Int?
    var toestelamount: Int?
    var onderhoudamount: Int?
    var no: Int?
    var addonderhoud = 0
    var noo: Int?
    var ipTest: IndexPath?
    var onderhoud_id_test: String?
    
    
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
                    }
                }
                onderhoudsdatum.date = date
                monteur.selectRow(row!, inComponent: 0, animated: true)
            }
        print(needed_data)
        }
        
        
    }
    
    @objc func editOff() {
        addOnderhoud.isHidden = true
        datumLabel.isHidden = false
        onderhoudsdatum.isHidden = true
        monteurLabel.isHidden = false
        monteur.isHidden = true
        werkzaamheden.isSelectable = false
        werkzaamheden.isEditable = false
        Opmerkingen.isSelectable = false
        Opmerkingen.isEditable = false
        print(needed_data.count)
        if needed_data.count != 0 {
            let endIndex = needed_data.count - 1
            if needed_data[endIndex].opmerkingen == "Nieuw Onderhoud" {
                needed_data.remove(at: endIndex)
            }
        }
        onderhoudTableView.reloadData()
        onderhoudTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        if needed_data.count != 0 {
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
    }
    
    @objc func save() {
        print("NEEDED1")
        print(needed_data)
        if addonderhoud > 0 {
            print(needed_data)
            print("Onderhouden")
            print(addonderhoud)
            print(needed_data)
//            if noo == 1 {
//                noo = 2
//                addonderhoud -= 1
//            }
            print(addonderhoud)
            for i in 1...addonderhoud {
                let endIndex = needed_data.count - i
                print("onderhoud")
                print(needed_data[endIndex])
                let create = createData()
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "dd-MM-yyyy"
                let date = needed_data[endIndex].onderhoudsdatum
                var datum = dateFormatterGet.string(from: date) as String?
                datum = datum!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
                print(needed_data[endIndex].werkzaamheden)
                if needed_data[endIndex].werkzaamheden != ""
                {
                    create.createOnderhoud(
                        klant_id: needed_data[endIndex].klant_id,
                        toestel_id: needed_data[endIndex].toestel_id,
                        onderhoudsdatum: datum ?? "",
                        monteur: needed_data[endIndex].monteur,
                        werkzaamheden: needed_data[endIndex].werkzaamheden,
                        opmerkingen: needed_data[endIndex].opmerkingen,
                        onderhoud_id: needed_data[endIndex].onderhoud_id)
                    print("ONDERHOUD")
                }
                
            }
        }
        addonderhoud = 0
        addOnderhoud.isHidden = true
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
        if nieuw != 1 && needed_data.count != 0 {
            noo = 0
            let len = needed_data.count
            let ip = onderhoudTableView.indexPathForSelectedRow
            let o_id = needed_data[(ip?.row)!].onderhoud_id
            updata(indexPath: ip!, onderhoud_id: o_id)
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
        if needed_data.count != 0 {
            let onderhoudsdatum2 = needed_data[0].onderhoudsdatum
            datumLabel?.text = dateFormat.string(from: onderhoudsdatum2)
            onderhoudsdatum?.date = needed_data[0].onderhoudsdatum
            let monteur2 = needed_data[0].monteur
            var row: Int?
            for i in 0..<monteurs.count {
                if monteurs[i] == monteur2 {
                    row = i
                }
            }
            monteur.selectRow(row!, inComponent: 0, animated: true)
            monteurLabel?.text = monteur2
            werkzaamheden?.text = needed_data[0].werkzaamheden
            Opmerkingen?.text = needed_data[0].opmerkingen
        } else {
            emptyKlant()
        }
        
    }
    
    func updateOnderhoud(index: Int) {
        print("UPDATE ONDERHOUD")
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
        print(needed_data)
        update.updateOnderhoud(klant_id: klant_id ?? "", toestel_id: toestel_id, onderhoudsdatum: datum ?? "", monteur: monteur ?? "", werkzaamheden: needed_data[index].werkzaamheden, opmerkingen: needed_data[index].opmerkingen, onderhoud_id: needed_data[index].onderhoud_id)
    }
    
    func updata(indexPath: IndexPath, onderhoud_id: String) {
        print("UPDATA")
        let amount = data?.onderhouden.count
        var date3: Date?
        var monteur3: String?
        var werkzaamheden3: String?
        var opmerkingen3: String?
        var index1: Int?
        for index in 0..<amount! {
            if data?.onderhouden[index].onderhoud_id == onderhoud_id {
                index1 = index
                date3 = data?.onderhouden[index].onderhoudsdatum
                monteur3 = data?.onderhouden[index].monteur
                werkzaamheden3 = data?.onderhouden[index].werkzaamheden
                opmerkingen3 = data?.onderhouden[index].opmerkingen
            }
        }
        let date = needed_data[indexPath.row].onderhoudsdatum
        let date2 = onderhoudsdatum?.date
//        if date != nil && date2 != nil && date3 != nil {
            if date != date2 {
                needed_data[indexPath.row].onderhoudsdatum = date2!
            }
            if date3 != date2 {
                data?.onderhouden[index1!].onderhoudsdatum = date2!
            }
//        }
        let monteur = needed_data[indexPath.row].monteur as String?
        let monteur2 = monteurLabel.text
        if monteur != nil && monteur2 != nil && monteur3 != nil {
            if monteur != monteur2 {
                needed_data[indexPath.row].monteur = monteur2!
            }
            if monteur3 != monteur2 {
                data?.onderhouden[index1!].monteur = monteur2!
            }
        }
        if needed_data[indexPath.row].werkzaamheden != werkzaamheden.text {
            needed_data[indexPath.row].werkzaamheden = werkzaamheden.text
        }
        print("HIER24")
        if werkzaamheden3 != werkzaamheden.text {
            print("HIER25")
            data?.onderhouden[index1!].werkzaamheden = werkzaamheden.text
        }
        if needed_data[indexPath.row].opmerkingen != Opmerkingen.text {
           needed_data[indexPath.row].opmerkingen = Opmerkingen.text
        }
        if opmerkingen3 != Opmerkingen.text {
            data?.onderhouden[index1!].opmerkingen = Opmerkingen.text
        }
    }
    
    func updateFullData()
    {
//        print("IP")
//        print(ipTest)
//        print(onderhoud_id_test)
        if onderhoud_id_test != nil
        {
            var needed_index: Int?
            let amount = data?.onderhouden.count
            for index in 0..<amount! {
                if data?.onderhouden[index].onderhoud_id == onderhoud_id_test {
                    needed_index = index
                    break
                }
            }
            if data?.onderhouden[needed_index!].onderhoudsdatum != onderhoudsdatum.date
            {
//                print(data?.onderhouden[needed_index!].onderhoudsdatum)
//                print(onderhoudsdatum.date)
                data?.onderhouden[needed_index!].onderhoudsdatum = onderhoudsdatum.date
            }
            if data?.onderhouden[needed_index!].monteur != monteurLabel.text
            {
//                print(data?.onderhouden[needed_index!].monteur)
//                print(monteurLabel.text)
                data?.onderhouden[needed_index!].monteur = monteurLabel.text ?? "Albert Mel"
            }
            if data?.onderhouden[needed_index!].werkzaamheden != werkzaamheden.text
            {
//                print(data?.onderhouden[needed_index!].werkzaamheden)
//                print(werkzaamheden.text)
                data?.onderhouden[needed_index!].werkzaamheden = werkzaamheden.text
            }
            if data?.onderhouden[needed_index!].opmerkingen != Opmerkingen.text
            {
//                print(data?.onderhouden[needed_index!].opmerkingen)
//                print(Opmerkingen.text)
                data?.onderhouden[needed_index!].opmerkingen = Opmerkingen.text
            }
        }
    }
    
    @objc func datafunc(notification: Notification) {
        print("DATAFUNC")
        updateFullData()
//        print(data)
        needed_data.removeAll()
        needed_toestel_id = notification.userInfo!["Toestel"] as! String
        print(needed_toestel_id)
        let count = data?.onderhouden.count
        for index in 0..<count! {
//            if needed_toestel_id != nil {
                if needed_toestel_id == data?.onderhouden[index].toestel_id {
//                    print("TESTERERE")
//                    print(data?.onderhouden[index].onderhoud_id)
                    needed_data.append((data?.onderhouden[index])!)
                }
//            }
        }
        ipTest = onderhoudTableView.indexPathForSelectedRow
        onderhoud_id_test = needed_data[ipTest!.row].onderhoud_id
//        print(ipTest)
//        print(onderhoud_id_test)
        onderhoudTableView.reloadData()
//        print(needed_data)
        onderhoudTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        if nieuw == 1  {
            newKlant()
        } else if needed_data.count == 0 {
            emptyKlant()
        } else {
            let date = needed_data[0].onderhoudsdatum
            dateFormat.dateStyle = .full
//            if date != nil {
                datumLabel?.text = dateFormat.string(from: date)
                onderhoudsdatum.date = date
//                print(onderhoudsdatum.date)
//            }
            monteurLabel?.text = needed_data[0].monteur
            let monteur2 = needed_data[0].monteur
            var row: Int?
            for i in 0...monteurs.count-1 {
//                print(monteurs[i])
                if monteurs[i] == monteur2 {
                    row = i
                }
            }
            monteur.selectRow(row!, inComponent: 0, animated: true)
            werkzaamheden?.text = needed_data[0].werkzaamheden
            Opmerkingen?.text = needed_data[0].opmerkingen
        }
    }

    func newKlant() {
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
    }
    
    func emptyKlant() {
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
    
    func existingKlant() {
        if needed_data.count == 0 {
            emptyKlant()
        } else {
            addOnderhoud.isHidden = true
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
        no = 0
        let cell = onderhoudTableView.dequeueReusableCell(withIdentifier: "onderhoudCell", for: indexPath)
        if needed_data.count != 0 {
            let date = needed_data[indexPath.row].onderhoudsdatum
            dateFormat.dateStyle = .short
            let werkzaamheden = needed_data[indexPath.row].werkzaamheden
            cell.textLabel?.text = "\(dateFormat.string(from: date)) \(werkzaamheden)"
            return cell
        } else {
            cell.textLabel?.text = "Nieuw Onderhoud"
            no = 1
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("test")
//        if no == 1 {
//
//        } else {
        let o_id = needed_data[indexPath.row].onderhoud_id
//        ipTest = indexPath
//        onderhoud_id_test = o_id
        updata(indexPath: indexPath, onderhoud_id: o_id)
        print("DIDSELECTROW")
        print(needed_data)
//        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if nieuw == 1  {
            newKlant()
        } else if needed_data.count == 0 {
            emptyKlant()
        } else {
//            print(data?.onderhouden.count)
            let date = needed_data[indexPath.row].onderhoudsdatum
            print(date)
            dateFormat.dateStyle = .full
//            if date != nil {
                datumLabel?.text = dateFormat.string(from: date)
                onderhoudsdatum.date = date
                print(onderhoudsdatum.date)
//            }
            monteurLabel?.text = needed_data[indexPath.row].monteur
            let monteur2 = needed_data[indexPath.row].monteur
            print("monteur2")
            print(monteur2)
            var row: Int?
            for i in 0...monteurs.count-1 {
                print(monteurs[i])
                if monteurs[i] == monteur2 {
                    row = i
//                    print(row)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        monteurLabel?.text = monteurs[row]
    }
    
    @IBAction func addOnderhoud(_ sender: Any) {
        if no == 1 {
            if werkzaamheden?.text == "" {
                print("VUL IN")
            } else {
                noo = 1
//                print(noo)
                if monteurLabel.text == "Onbekend" {
                    monteurLabel.text = monteurs[0]
                }

                addonderhoud += 1
                var id = String(onderhoudamount! + addonderhoud - 1)
                var newRow = onderhoud3(klant_id: data?.klant_id ?? "", toestel_id: needed_toestel_id , onderhoudsdatum: Date(), monteur: monteurs[0], werkzaamheden: "", opmerkingen: "", onderhoud_id: id)
                data?.onderhouden.append(newRow)
                needed_data.append(newRow)
                let ip = onderhoudTableView.indexPathForSelectedRow
                let o_id = needed_data[(ip?.row)!].onderhoud_id
                updata(indexPath: ip!, onderhoud_id: o_id)

                addonderhoud += 1
                id = String(onderhoudamount! + addonderhoud - 1)
                newRow = onderhoud3(klant_id: data?.klant_id ?? "", toestel_id: needed_toestel_id , onderhoudsdatum: Date(), monteur: monteurs[0], werkzaamheden: "", opmerkingen: "", onderhoud_id: id)
                data?.onderhouden.append(newRow)
                needed_data.append(newRow)
                onderhoudTableView.reloadData()
                let endIndex = needed_data.count - 1
                onderhoudTableView.selectRow(at: IndexPath(row: endIndex, section: 0), animated: true, scrollPosition: .top)
                let date = needed_data[endIndex].onderhoudsdatum
                dateFormat.dateStyle = .full
                datumLabel?.text = dateFormat.string(from: date)
                onderhoudsdatum.date = date
                monteurLabel?.text = needed_data[endIndex].monteur
                monteur.selectRow(0, inComponent: 0, animated: true)
                werkzaamheden?.text = needed_data[endIndex].werkzaamheden
                Opmerkingen?.text = needed_data[endIndex].opmerkingen
                print(needed_data)
            }
        } else {
            let ip = onderhoudTableView.indexPathForSelectedRow
            let o_id = needed_data[(ip?.row)!].onderhoud_id
            updata(indexPath: ip!, onderhoud_id: o_id)
            addonderhoud += 1
            let id = String(onderhoudamount! + addonderhoud - 1)
            let newRow = onderhoud3(klant_id: data?.klant_id ?? "", toestel_id: needed_toestel_id , onderhoudsdatum: Date(), monteur: monteurs[0], werkzaamheden: "", opmerkingen: "", onderhoud_id: id)
            data?.onderhouden.append(newRow)
            needed_data.append(newRow)
            onderhoudTableView.reloadData()
            let endIndex = needed_data.count - 1
            onderhoudTableView.selectRow(at: IndexPath(row: endIndex, section: 0), animated: true, scrollPosition: .top)
            let date = needed_data[endIndex].onderhoudsdatum
            dateFormat.dateStyle = .full
            datumLabel?.text = dateFormat.string(from: date)
            onderhoudsdatum.date = date
            monteurLabel?.text = needed_data[endIndex].monteur
            monteur.selectRow(0, inComponent: 0, animated: true)
            werkzaamheden?.text = needed_data[endIndex].werkzaamheden
            Opmerkingen?.text = needed_data[endIndex].opmerkingen
        }
    }
    
}

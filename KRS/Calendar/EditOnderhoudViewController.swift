//
//  EditOnderhoudViewController.swift
//  KRS
//
//  Created by Wessel Mel on 23/01/2019.
//  Copyright © 2019 Wessel Mel. All rights reserved.
//

import UIKit

class EditOnderhoudViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var date2: Date?

    @IBOutlet weak var datumPicker: UIDatePicker!
    @IBOutlet weak var monteurPicker: UIPickerView!
    @IBOutlet weak var werkzaamheden: UITextView!
    @IBOutlet weak var opmerkingen: UITextView!
    @IBOutlet weak var datumLabel: UILabel!
    @IBOutlet weak var monteurLabel: UILabel!
    
    @IBOutlet weak var editandcancel: UIBarButtonItem!
    @IBOutlet weak var doneandsave: UIBarButtonItem!
    
    var backup_onderhoud: onderhoud2?
    var onderhoud: onderhoud2?
    
    var monteurs = ["Albert Mel", "Mike Visser", "Bart Dekker"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onderhoud = backup_onderhoud
        editandcancel.title = "Edit"
        print(editandcancel.title)
        print(doneandsave.title)
        doneandsave.title = "Done"
        print(doneandsave.title)
        
        datumPicker.isHidden = true
        monteurPicker.isHidden = true
        datumLabel.isHidden = false
        monteurLabel.isHidden = false
        
        monteurPicker.delegate = self
        monteurPicker.dataSource = self
        
        datumPicker.datePickerMode = .date
        datumPicker.locale = Locale(identifier: "nl_NL")
        
        datumLabel.text = backup_onderhoud?.onderhoudsdatum
        monteurLabel.text = backup_onderhoud?.monteur
        
        werkzaamheden.isEditable = false
        werkzaamheden.isSelectable = false
        werkzaamheden.text = backup_onderhoud?.werkzaamheden
        
        opmerkingen.isEditable = false
        opmerkingen.isSelectable = false
        opmerkingen.text = backup_onderhoud?.opmerkingen
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editandcancelfunction(_ sender: Any) {
        if editandcancel.title == "Edit"
        {
            editandcancel.title = "Cancel"
            doneandsave.title = "Save"
            edit()
        }
        else
        {
            editandcancel.title = "Edit"
            doneandsave.title = "Done"
            cancel()
        }
    }
    
    @IBAction func doneandsavefunction(_ sender: Any) {
        if doneandsave.title == "Save"
        {
            editandcancel.title = "Edit"
            doneandsave.title = "Done"
            save()
        }
        else
        {
            done()
        }
    }
    
    func edit()
    {
        datumPicker.isHidden = false
        monteurPicker.isHidden = false
        datumLabel.isHidden = true
        monteurLabel.isHidden = true
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        let date = dateformatter.date(from: onderhoud!.onderhoudsdatum)
        datumPicker.date = date!
        
        let monteur = onderhoud!.monteur
        var row: Int?
        for i in 0...monteurs.count-1 {
            if monteurs[i] == monteur {
                row = i
            }
        }
        monteurPicker.selectRow(row!, inComponent: 0, animated: true)
        
        werkzaamheden.isEditable = true
        werkzaamheden.isSelectable = true
        
        opmerkingen.isEditable = true
        opmerkingen.isSelectable = true
    }
    
    func cancel()
    {
        onderhoud = backup_onderhoud
        datumPicker.isHidden = true
        monteurPicker.isHidden = true
        datumLabel.isHidden = false
        monteurLabel.isHidden = false
        
        datumLabel.text = onderhoud!.onderhoudsdatum
        monteurLabel.text = onderhoud!.monteur
        
        werkzaamheden.isEditable = false
        werkzaamheden.isSelectable = false
        werkzaamheden.text = onderhoud!.werkzaamheden
        
        opmerkingen.isEditable = false
        opmerkingen.isSelectable = false
        opmerkingen.text = onderhoud!.opmerkingen
    }
    
    func done()
    {
        performSegue(withIdentifier: "backSegue", sender: self)
    }
    
    func save()
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        var datum = dateFormatterGet.string(from: datumPicker.date) as String?
        datum = datum!.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        onderhoud?.werkzaamheden = werkzaamheden.text
        onderhoud?.opmerkingen = opmerkingen.text
        onderhoud?.monteur = monteurs[monteurPicker.selectedRow(inComponent: 0)]
        onderhoud?.onderhoudsdatum = datum!
        let update = updateData()
        update.updateOnderhoud(
            klant_id: onderhoud?.klant_id ?? "",
            toestel_id: onderhoud?.toestel_id ?? "",
            onderhoudsdatum: onderhoud?.onderhoudsdatum ?? "",
            monteur: onderhoud?.monteur ?? "",
            werkzaamheden: onderhoud?.werkzaamheden ?? "",
            opmerkingen: onderhoud?.opmerkingen ?? "",
            onderhoud_id: onderhoud?.onderhoud_id ?? "")
        
        backup_onderhoud = onderhoud
        
        datumPicker.isHidden = true
        monteurPicker.isHidden = true
        datumLabel.isHidden = false
        monteurLabel.isHidden = false
        
        datumLabel.text = onderhoud!.onderhoudsdatum
        monteurLabel.text = onderhoud!.monteur
        
        werkzaamheden.isEditable = false
        werkzaamheden.isSelectable = false
        werkzaamheden.text = onderhoud!.werkzaamheden
        
        opmerkingen.isEditable = false
        opmerkingen.isSelectable = false
        opmerkingen.text = onderhoud!.opmerkingen
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backSegue"
        {
            let AOVC = segue.destination as! AfsprakenOverzichtViewController
            AOVC.date = date2
        }
    }
}

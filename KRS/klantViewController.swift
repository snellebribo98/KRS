//
//  klantViewController.swift
//  KRS
//
//  Created by Wessel Mel on 24/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit

class klantViewController: UIViewController {
    
    var nieuw: Int?
    var data: Klant3?

    @IBOutlet weak var naam: UITextField!
    @IBOutlet weak var debnr: UITextField!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var mobiel: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var straat: UITextField!
    @IBOutlet weak var nr: UITextField!
    @IBOutlet weak var postcode: UITextField!
    @IBOutlet weak var woonplaats: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if nieuw == 1 {
            newKlant()
        } else if data != nil {
            print("HIER")
            existingKlant()
        }
        let edited = Notification.Name("edit")
        let edited2 = Notification.Name("edit2")
        let edited3 = Notification.Name("edit3")
        let notitie = Notification.Name("Note")
        NotificationCenter.default.addObserver(self, selector: #selector(klantViewController.editOn), name:
            edited, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(klantViewController.editOff), name:
            edited2, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(klantViewController.save), name:
            edited3, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(klantViewController.update), name: notitie, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func editOn() {
        naam?.isEnabled = true
        debnr?.isEnabled = true
        tel?.isEnabled = true
        mobiel?.isEnabled = true
        mail?.isEnabled = true
        straat?.isEnabled = true
        nr?.isEnabled = true
        postcode?.isEnabled = true
        woonplaats?.isEnabled = true
    }
    
    @objc func editOff() {
        naam?.isEnabled = false
        debnr?.isEnabled = false
        tel?.isEnabled = false
        mobiel?.isEnabled = false
        mail?.isEnabled = false
        straat?.isEnabled = false
        nr?.isEnabled = false
        postcode?.isEnabled = false
        woonplaats?.isEnabled = false
    }
    
    @objc func save() {
        naam?.isEnabled = false
        debnr?.isEnabled = false
        tel?.isEnabled = false
        mobiel?.isEnabled = false
        mail?.isEnabled = false
        straat?.isEnabled = false
        nr?.isEnabled = false
        postcode?.isEnabled = false
        woonplaats?.isEnabled = false
        
    }
    
    @objc func update(notification: Notification) {
        let note = notification.userInfo
        let notitie = note?["test"] as! String?
        if nieuw != 1 {
            let update = updateData()
            let klant_id = data?.klant_id
            update.updateKlantgegevens(naam: naam?.text ?? "", debnr: debnr?.text ?? "", tel: tel?.text ?? "", mobiel: mobiel?.text ?? "", mail: mail?.text ?? "", straat: straat?.text ?? "", nr: nr?.text ?? "", postcode: postcode?.text ?? "", woonplaats: woonplaats?.text ?? "", notities: notitie ?? "", klant_id: klant_id ?? "")
        }
    }
    
    func newKlant() {
        naam?.text = ""
        debnr?.text = ""
        tel?.text = ""
        mobiel?.text = ""
        mail?.text = ""
        straat?.text = ""
        nr?.text = ""
        postcode?.text = ""
        woonplaats?.text = ""
    }
    
    func existingKlant() {
        naam?.text = data?.naam
        debnr?.text = data?.debnr
        tel?.text = data?.tel
        mobiel?.text = data?.mobiel
        mail?.text = data?.mail
        straat?.text = data?.straat
        nr?.text = data?.nr
        postcode?.text = data?.postcode
        woonplaats?.text = data?.woonplaats
        
        naam?.isEnabled = false
        debnr?.isEnabled = false
        tel?.isEnabled = false
        mobiel?.isEnabled = false
        mail?.isEnabled = false
        straat?.isEnabled = false
        nr?.isEnabled = false
        postcode?.isEnabled = false
        woonplaats?.isEnabled = false
        
    }
    
    

}

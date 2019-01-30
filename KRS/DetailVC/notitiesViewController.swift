//
//  notitiesViewController.swift
//  KRS
//
//  Created by Wessel Mel on 24/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit

class notitiesViewController: UIViewController {
    
    // needed variables
    var nieuw: Int?
    var data: Klant3?
    public var test = 1
    var klantamount: Int?
    var toestelamount: Int?
    var onderhoudamount: Int?
    
    // outlet
    @IBOutlet weak var notities: DesignableTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        test = 0
        if nieuw == 1 {
            newKlant()
        } else if data != nil {
            existingKlant()
        }
        
        let edited = Notification.Name("edit")
        let edited2 = Notification.Name("edit2")
        let edited3 = Notification.Name("edit3")
        NotificationCenter.default.addObserver(self, selector: #selector(notitiesViewController.editOn), name:
            edited, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notitiesViewController.editOff), name:
            edited2, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notitiesViewController.save), name:
            edited3, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func newKlant() {
        notities?.text = ""
        notities?.isEditable = true
        notities?.isSelectable = true
    }
    
    func existingKlant() {
        notities?.text = data?.notities
        notities?.isEditable = false
        notities?.isSelectable = false
    }
    
    @objc func editOn() {
        notities?.isEditable = true
        notities?.isSelectable = true
    }
    
    @objc func editOff() {
        notities?.isEditable = false
        notities?.isSelectable = false
    }
    
    @objc func save() {
        notities?.isEditable = false
        notities?.isSelectable = false
        let notitie = Notification.Name("Note")
        NotificationCenter.default.post(name: notitie, object: nil, userInfo: ["test": notities?.text as Any])
    }

}

//
//  DetailViewController.swift
//  KRS
//
//  Created by Wessel Mel on 24/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var nieuw: Int?
    var data: Klant3?
    var editer: Int?
    
    @IBOutlet weak var links: UIBarButtonItem!
    @IBOutlet weak var titel: UINavigationItem!
    @IBOutlet weak var rechts: UIBarButtonItem!
    
    @IBOutlet weak var klantGegevensView: DesignableView!
    
    var klantamount: Int?
    var toestelamount: Int?
    var onderhoudamount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if nieuw != 1 && editer != 1 {
            links.title = "Edit"
            rechts.title = "Done"
            titel.title = "Klant Info"
        } else if editer == 1 {
            links.title = "Cancel"
            rechts.title = "Save"
            titel.title = "Klant Info"
        } else {
            links.title = "Cancel"
            rechts.title = "Save"
            titel.title = "Nieuwe Klant"
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "klantSegue" {
            let KVC = segue.destination as! klantViewController
            print("HIER")
            KVC.data = data
            KVC.nieuw = nieuw
            KVC.klantamount = klantamount
            KVC.toestelamount = toestelamount
            KVC.onderhoudamount = onderhoudamount
        }
        if segue.identifier == "toestelSegue" {
            let TVC = segue.destination as! toestelViewController
            TVC.data = data
            TVC.nieuw = nieuw
            TVC.klantamount = klantamount
            TVC.toestelamount = toestelamount
            TVC.onderhoudamount = onderhoudamount
        }
        if segue.identifier == "notitiesSegue" {
            let NVC = segue.destination as! notitiesViewController
            NVC.data = data
            NVC.nieuw = nieuw
            NVC.klantamount = klantamount
            NVC.toestelamount = toestelamount
            NVC.onderhoudamount = onderhoudamount
        }
        if segue.identifier == "onderhoudSegue" {
            let OVC = segue.destination as! ohViewController
            OVC.data = data
            OVC.nieuw = nieuw
            OVC.klantamount = klantamount
            OVC.toestelamount = toestelamount
            OVC.onderhoudamount = onderhoudamount
        }
    }
    
    @IBAction func linksButton(_ sender: Any) {
        if links.title == "Edit" {
            editer = 1
            let edited = Notification.Name("edit")
            NotificationCenter.default.post(name: edited, object: nil)
            self.viewDidLoad()
        } else if links.title == "Cancel" && editer == 1 {
            editer = 0
            let edited2 = Notification.Name("edit2")
            NotificationCenter.default.post(name: edited2, object: nil)
            self.viewDidLoad()
        } else if links.title == "Cancel" {
            performSegue(withIdentifier: "unwindSegue", sender: self)
        }
        
    }
    
    @IBAction func rechtsButton(_ sender: Any) {
        if rechts.title == "Save" {
            if nieuw != 1 {
                
            } else {
                nieuw = 0
            }
            editer = 0
            let edited3 = Notification.Name("edit3")
            NotificationCenter.default.post(name: edited3, object: nil)
            self.viewDidLoad()
        } else if rechts.title == "Done" {
            performSegue(withIdentifier: "unwindSegue", sender: self)
        }
    }
    
    
    
        

}

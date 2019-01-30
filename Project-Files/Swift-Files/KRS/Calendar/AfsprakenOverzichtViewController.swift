//
//  AfsprakenOverzichtViewController.swift
//  KRS
//
//  Created by Wessel Mel on 22/01/2019.
//  Copyright © 2019 Wessel Mel. All rights reserved.
//

import UIKit

class AfsprakenOverzichtViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var date: Date?
    var datum: String?
    var nieuw: Int?
    
    var all_onderhoud: [onderhoud2]?
    var all_klanten: [Klant2]?
    var all_toestellen: [toestel2]?
    var needed_onderhoud = [onderhoud2]()
    var klantenLijst = [String]()
    var toestellenLijst = [String]()
    var selected_onderhoud: onderhoud2?

    @IBOutlet weak var bar: UINavigationItem!
    @IBOutlet weak var overzichtTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "nl_NL")
        datum = formatter.string(from: date!)
        bar.title = datum
        
        fetchOnderhoud()
        
        overzichtTableView.delegate = self
        overzichtTableView.dataSource = self
    }
    
    func fetchOnderhoud()
    {
        let fetch = fetchDatas()
        all_onderhoud = fetch.onderhoudData()
        all_klanten = fetch.klantData()
        all_toestellen = fetch.toestelData()
        for onderhoud in all_onderhoud!
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            datum = formatter.string(from: date!)
            if onderhoud.onderhoudsdatum == datum
            {
                needed_onderhoud.append(onderhoud)
                for klant in all_klanten!
                {
                    if klant.klant_id == onderhoud.klant_id
                    {
                        klantenLijst.append(klant.naam)
                        break
                    }
                }
                for toestel in all_toestellen!
                {
                    if toestel.toestel_id == onderhoud.toestel_id
                    {
                        let naam = "\(toestel.merk) \(toestel.type)"
                        toestellenLijst.append(naam)
                        break
                    }
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return needed_onderhoud.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = overzichtTableView.dequeueReusableCell(withIdentifier: "EersteCell", for: indexPath)
            return cell
        }
        else
        {
            let cell = overzichtTableView.dequeueReusableCell(withIdentifier: "OnderhoudCell", for: indexPath) as! onderhoudCell
            cell.naamLabel.text = klantenLijst[indexPath.row - 1]
            cell.toestelLabel.text = toestellenLijst[indexPath.row - 1]
            cell.werkzaamhedenLabel.text = needed_onderhoud[indexPath.row - 1].werkzaamheden
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0
        {
            selected_onderhoud = needed_onderhoud[indexPath.row - 1]
            performSegue(withIdentifier: "editSegue", sender: self)
        }
    }
    
    @IBAction func addOnderhoud(_ sender: Any) {
        let alert = UIAlertController(title: "Ja of Nee?", message: "Staat de klant al in het systeem of is het een nieuwe klant?", preferredStyle: .alert)
        var keuze: String?
        nieuw = 0
        
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: {action in self.performSegue(withIdentifier: "addSegue", sender: self)}))
        alert.addAction(UIAlertAction(title: "Nee", style: .default, handler: {action in nee()}))
        self.present(alert, animated: true)
        
        func nee()
        {
            nieuw = 1
            let alert2 = UIAlertController(title: "Ja of Nee?", message: "Wilt u een nieuwe klant aanmaken", preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: "Ja", style: .default, handler: {action in self.performSegue(withIdentifier: "addKlantSegue", sender: self)}))
            alert2.addAction(UIAlertAction(title: "Nee", style: .default, handler: {action in self.performSegue(withIdentifier: "addSegue", sender: self)}))
            self.present(alert2, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue"
        {
            let EOVC = segue.destination as! EditOnderhoudViewController
            EOVC.backup_onderhoud = selected_onderhoud
            EOVC.date2 = date
        }
        else if segue.identifier == "addSegue"
        {
            let NOVC = segue.destination as! NAViewController
            NOVC.date = date
            NOVC.overzicht = 1
            NOVC.nieuw = nieuw
        }
        else if segue.identifier == "addKlantSegue"
        {
            let DVC = segue.destination as! DetailViewController
            DVC.nieuw = 1
            let fetch = fetchDatas()
            let testklantgegevens = fetch.klantData()
            let testonderhoudgegevens = fetch.onderhoudData()
            let testtoestelgegevens = fetch.toestelData()
            let klantamount = testklantgegevens?.count
            let onderhoudamount = testonderhoudgegevens?.count
            let toestelamount = testtoestelgegevens?.count
            let nieuwedata = Klant3(naam: "", debnr: "", tel: "", mobiel: "", mail: "", straat: "", nr: "", postcode: "", woonplaats: "", notities: "", klant_id: String(klantamount!), toestellen: [toestel3](), onderhouden: [onderhoud3]())
            DVC.klantamount = klantamount
            DVC.toestelamount = toestelamount
            DVC.onderhoudamount = onderhoudamount
            DVC.data = nieuwedata
        }
    }
    
    @IBAction func unwindToOverzich(segue: UIStoryboardSegue)
    {
    }

}

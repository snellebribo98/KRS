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
    
    var all_onderhoud: [onderhoud2]?
    var all_klanten: [Klant2]?
    var all_toestellen: [toestel2]?
    var needed_onderhoud = [onderhoud2]()
    var klantenLijst = [String]()
    var toestellenLijst = [String]()

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
        // Do any additional setup after loading the view.
    }
    
    func fetchOnderhoud()
    {
        let fetch = fetchDatas()
        all_onderhoud = fetch.onderhoudData()
        all_klanten = fetch.klantData()
        all_toestellen = fetch.toestelData()
        print(all_onderhoud!.count)
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

}

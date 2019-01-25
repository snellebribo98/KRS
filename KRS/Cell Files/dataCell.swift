//
//  dataCell.swift
//  KRS
//
//  Created by Wessel Mel on 23/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit

class dataCell: UITableViewCell {

    @IBOutlet weak var achternaam: UILabel!
    @IBOutlet weak var Straat: UILabel!
    @IBOutlet weak var woonplaats: UILabel!
    @IBOutlet weak var telNr: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var OGP: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  onderhoudCell.swift
//  KRS
//
//  Created by Wessel Mel on 22/01/2019.
//  Copyright © 2019 Wessel Mel. All rights reserved.
//

import UIKit

class onderhoudCell: UITableViewCell
{
    
    @IBOutlet weak var naamLabel: UILabel!
    @IBOutlet weak var toestelLabel: UILabel!
    @IBOutlet weak var werkzaamhedenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

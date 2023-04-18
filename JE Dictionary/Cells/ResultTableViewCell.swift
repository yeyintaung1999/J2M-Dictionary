//
//  ResultTableViewCell.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 17/04/2023.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

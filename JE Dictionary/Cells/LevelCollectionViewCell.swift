//
//  LevelCollectionViewCell.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 19/04/2023.
//

import UIKit

class LevelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var label: UILabel!
    var vo: LevelVO?{
        didSet{
            if let vo = vo {
                label.text = vo.level
                if vo.isSelected {
                    background.backgroundColor = .systemIndigo
                }else{
                    background.backgroundColor = .white
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

//
//  RadioButton.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 20/04/2023.
//

import Foundation
import UIKit

class RadioButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initButton()
    }
    
    func initButton(){
        //self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle("", for: .normal)
        self.setTitle("", for: .highlighted)
        self.tintColor = .label
        
        self.setImage(UIImage(systemName: "circle"),for: .normal)
        self.setImage(UIImage(systemName: "record.circle"), for: .highlighted)
        self.setImage(UIImage(systemName: "record.circle"), for: .selected)
    }
}

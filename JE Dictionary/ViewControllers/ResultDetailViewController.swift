//
//  ResultDetailViewController.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 17/04/2023.
//

import UIKit

class ResultDetailViewController: UIViewController {
    
    var vo : ResultVO?
    
    @IBOutlet weak var lblkana: UILabel!
    @IBOutlet weak var lblkanji: UILabel!
    @IBOutlet weak var lblmeaning: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Binding Data
        lblkana.text = "\(vo?.kana ?? "default") \n \n(\(vo?.romaji ?? "default"))"
        if vo?.kanji == nil || vo?.kanji == "" {
            
        }else{
            lblkanji.text = "\(vo?.kanji ?? "default") \n \n(\(vo?.romaji ?? "default"))"
        }
        lblmeaning.text = vo?.meaning_mm ?? "default"
    }

}

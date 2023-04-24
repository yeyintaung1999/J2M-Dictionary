//
//  SettingViewController.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 18/04/2023.
//

import UIKit

class SettingViewController: UIViewController {
    //MARK: - IB Outlets
    @IBOutlet weak var btnRomaji: RadioButton!
    @IBOutlet weak var btnKana: RadioButton!
    @IBOutlet weak var btnMm: RadioButton!
    @IBOutlet weak var btnKanji: RadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSearchOption()
        self.title = "Setting"
    }
    
    //MARK: - IB Actions
    //for radio buttons
    @IBAction func actionRomaji(_ sender: Any) {
        btnRomaji.isSelected = true
        btnKana.isSelected = false
        btnMm.isSelected = false
        btnKanji.isSelected = false
        UserDefaults.standard.set("romaji", forKey: "searchOption")
        let name = Notification.Name(romaji)
        NotificationCenter.default.post(name: name, object: nil)
        navigationController?.popViewController( animated: true)
    }
    
    @IBAction func actionKana(_ sender: Any) {
        btnRomaji.isSelected = false
        btnKana.isSelected = true
        btnMm.isSelected = false
        btnKanji.isSelected = false
        UserDefaults.standard.set("kana", forKey: "searchOption")
        let name = Notification.Name(kana)
        NotificationCenter.default.post(name: name, object: nil)
        navigationController?.popViewController( animated: true)
    }
    
    @IBAction func actionMm(_ sender: Any) {
        btnRomaji.isSelected = false
        btnKana.isSelected = false
        btnMm.isSelected = true
        btnKanji.isSelected = false
        UserDefaults.standard.set("meaning_mm", forKey: "searchOption")
        let name = Notification.Name(mm)
        NotificationCenter.default.post(name: name, object: nil)
        navigationController?.popViewController( animated: true)
    }
    
    @IBAction func actionKanji(_ sender: Any) {
        btnRomaji.isSelected = false
        btnKana.isSelected = false
        btnMm.isSelected = false
        btnKanji.isSelected = true
        UserDefaults.standard.set("kanji", forKey: "searchOption")
        let name = Notification.Name(kanji)
        NotificationCenter.default.post(name: name, object: nil)
        navigationController?.popViewController( animated: true)
    }
    
    //MARK: - Set Search Option
    func initialSearchOption(){
        let option = UserDefaults.standard.string(forKey: "searchOption")
        switch option {
            case "romaji":
                btnRomaji.isSelected = true
                btnKana.isSelected = false
                btnMm.isSelected = false
                btnKanji.isSelected = false
            case "kana":
                btnRomaji.isSelected = false
                btnKana.isSelected = true
                btnMm.isSelected = false
                btnKanji.isSelected = false
            case "meaning_mm":
                btnRomaji.isSelected = false
                btnKana.isSelected = false
                btnMm.isSelected = true
                btnKanji.isSelected = false
            case "kanji":
                btnRomaji.isSelected = false
                btnKana.isSelected = false
                btnMm.isSelected = false
                btnKanji.isSelected = true
            default:
                btnRomaji.isSelected = true
                btnKana.isSelected = false
                btnMm.isSelected = false
                btnKanji.isSelected = false
        }
        
    }
}




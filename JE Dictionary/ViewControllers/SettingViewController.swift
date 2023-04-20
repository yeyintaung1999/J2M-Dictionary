//
//  SettingViewController.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 18/04/2023.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var btnRomaji: RadioButton!
    
    @IBOutlet weak var btnKana: RadioButton!
    
    @IBOutlet weak var btnMm: RadioButton!
    
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ViewController.self)) as! ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSearchOption()
        self.title = "Setting"
    }
   
    
    @IBAction func actionRomaji(_ sender: Any) {
        btnRomaji.isSelected = true
        btnKana.isSelected = false
        btnMm.isSelected = false
        UserDefaults.standard.set("romaji", forKey: "searchOption")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen

        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionKana(_ sender: Any) {
        btnRomaji.isSelected = false
        btnKana.isSelected = true
        btnMm.isSelected = false
        UserDefaults.standard.set("kana", forKey: "searchOption")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen

        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionMm(_ sender: Any) {
        btnRomaji.isSelected = false
        btnKana.isSelected = false
        btnMm.isSelected = true
        UserDefaults.standard.set("meaning_mm", forKey: "searchOption")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func initialSearchOption(){
        let option = UserDefaults.standard.string(forKey: "searchOption")
        switch option {
            case "romaji":
                btnRomaji.isSelected = true
                btnKana.isSelected = false
                btnMm.isSelected = false
            case "kana":
                btnRomaji.isSelected = false
                btnKana.isSelected = true
                btnMm.isSelected = false
            case "meaning_mm":
                btnRomaji.isSelected = false
                btnKana.isSelected = false
                btnMm.isSelected = true
            default:
                btnRomaji.isSelected = true
                btnKana.isSelected = false
                btnMm.isSelected = false
        }
        
    }
    

}




//
//  LevelViewController.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 18/04/2023.
//

import UIKit

class LevelViewController: UIViewController {

    var nowlevel : selectedLevel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func n1(_ sender: Any) {
        nowlevel = .n1
        pushVC(.n1, level: "N1")
    }
    
    @IBAction func n2(_ sender: Any) {
        nowlevel = .n2
        pushVC(.n2, level: "N2")
    }
    
    @IBAction func n3(_ sender: Any) {
        nowlevel = .n3
        pushVC(.n3, level: "N3")
    }
    
    @IBAction func n4(_ sender: Any) {
        nowlevel = .n4
        pushVC(.n4, level: "N4")
    }
    
    @IBAction func n5(_ sender: Any) {
        nowlevel = .n5
        pushVC(.n5, level: "N5")
    }
    
    func pushVC(_ lvl: selectedLevel, level: String){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ViewController.self)) as! ViewController
        vc.dblevel = level
        vc.dbtable = lvl.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }

}

enum selectedLevel: String {
    case n1 = "dtb_n1"
    case n2 = "dtb_n2"
    case n3 = "dtb_n3"
    case n4 = "dtb_n4"
    case n5 = "dtb_n5"
    case all = "dtb_n1,dtb_n2"
}

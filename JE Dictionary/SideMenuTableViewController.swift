//
//  SideMenuTableViewController.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 18/04/2023.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    let lvlArray = [1,2,3,4,5]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: String(describing: LevelTableViewCell.self), bundle: nil), forCellReuseIdentifier: "tvclevel")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tvclevel", for: indexPath) as! LevelTableViewCell

        cell.lbl.text = "N\(lvlArray[indexPath.row])"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        level = "N\(indexPath.row+1)"
        table = "dtb_n\(indexPath.row+1)"
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ViewController.self)) as! ViewController
//        vc.fetchInitialResults()
        navigationController?.pushViewController(vc, animated: false)
        dismiss(animated: true)
    }

}

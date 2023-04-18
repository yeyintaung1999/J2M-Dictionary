//
//  ViewController.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 11/04/2023.
//

import UIKit
import SQLite

var table = "dtb_n5"
var level = "N5"

class ViewController: UIViewController {
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tvResults: UITableView!
    
    var results: [ResultVO] = []
    
    var dbtable: String?{
        didSet {
            if let dbtable = dbtable {
                table = dbtable
            }
        }
    }
    var dblevel: String?{
        didSet {
            if let dblevel = dblevel{
                level = dblevel
            }
        }
    }

    var manager : DBManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = DBManager(table: table, level: level)
        results = []
        fetchInitialResults()
        tfSearch.delegate = self
        setUpTableView()
        navigationItem.backButtonTitle = ""
        navigationItem.hidesBackButton = true
        self.title = "\(level)"
        
    }
    
    @IBAction func didTapSearch(_ sender: UIButton) {
        self.results = []
        let data = manager.fetchResults(for: tfSearch.text!)
        results.append(contentsOf: data)
        self.tvResults.reloadData()
        tfSearch.endEditing(true)
    }
    
    func fetchInitialResults(){
        results = []
        let data = manager.fetchInitialResults()
        self.results.append(contentsOf: data)
        tvResults.reloadData()
    }
    
    func setUpTableView(){
        tvResults.dataSource = self
        tvResults.delegate = self
        tvResults.register(UINib(nibName: String(describing: ResultTableViewCell.self), bundle: nil), forCellReuseIdentifier: "tvcresult")
    }
    
    
    @IBAction func onTapLvl(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: LevelViewController.self)) as! LevelViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK: - TEXTFIELD DELEGATE
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearch.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.results = []
        let data = manager.fetchResults(for: tfSearch.text!)
        self.results.append(contentsOf: data)
        self.tvResults.reloadData()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.results = []
        let data = manager.fetchResults(for: tfSearch.text!)
        self.results.append(contentsOf: data)
        if tfSearch.text! == "" {
            fetchInitialResults()
        }
        self.tvResults.reloadData()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if tfSearch.text == nil || tfSearch.text == "" {
            tfSearch.placeholder = "Type Something"
            return false
        }else{
            return true
        }
    }
    
}

//MARK: - TABLEVIEW DATASOURCE & DELEGATE
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tvcresult", for: indexPath) as! ResultTableViewCell
        cell.lbl.text = results[indexPath.row].kana
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcresultdetail") as! ResultDetailViewController
        vc.vo = results[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        tvResults.deselectRow(at: indexPath, animated: true)
    }
    
}


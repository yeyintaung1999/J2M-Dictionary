//
//  ViewController.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 11/04/2023.
//

import UIKit
import SQLite

var table : String = "dtb_n5"
var level : String = "N5"

class ViewController: UIViewController {

//    var database: Connection!
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tvResults: UITableView!
    
    var results: [ResultVO] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "\(level)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        results = []
        
        
        
        fetchInitialResults()
        tfSearch.delegate = self
        setUpTableView()
        
        navigationItem.backButtonTitle = ""
    }

    @IBAction func didTapSearch(_ sender: UIButton) {
        
        self.results = []
        let key = tfSearch.text!
        
        let query = "SELECT * FROM \(table) WHERE romaji = '\(key)'"
        
        for item in try! database.prepare(query){
            
            let vo = ResultVO(
                kana: item[3] as! String,
                romaji: item[2] as! String,
                kanji: item[4] as! String,
                meaning_mm: item[5] as! String
            )
            self.results.append(vo)
        }
        self.tvResults.reloadData()
        tfSearch.endEditing(true)
    }
    
    func fetchInitialResults(){
        results = []
        let query = "SELECT * FROM \(table)"
        
        for item in try! database.prepare(query){
            let vo = ResultVO(
                kana: item[3] as! String,
                romaji: item[2] as! String,
                kanji: item[4] as! String,
                meaning_mm: item[5] as! String
            )
            self.results.append(vo)
        }
        
        
    }
    
    func setUpTableView(){
        tvResults.dataSource = self
        tvResults.delegate = self
        tvResults.register(UINib(nibName: String(describing: ResultTableViewCell.self), bundle: nil), forCellReuseIdentifier: "tvcresult")
    }
    
    
}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearch.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.results = []
        let key = tfSearch.text!
        
        let query = "SELECT * FROM \(table) WHERE romaji = '\(key)'"
        
        for item in try! database.prepare(query){
            
            let vo = ResultVO(
                kana: item[3] as! String,
                romaji: item[2] as! String,
                kanji: item[4] as! String,
                meaning_mm: item[5] as! String
            )
            self.results.append(vo)
        }
        
        self.tvResults.reloadData()
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        self.results = []
        let key = tfSearch.text!
        
        let query = "SELECT * FROM \(table) WHERE romaji LIKE '%\(key)%'"
        
        for item in try! database.prepare(query){
            
            let vo = ResultVO(
                kana: item[3] as! String,
                romaji: item[2] as! String,
                kanji: item[4] as! String,
                meaning_mm: item[5] as! String
            )
            self.results.append(vo)
        }
        self.tvResults.reloadData()
        
        if tfSearch.text! == "" {
            fetchInitialResults()
            tvResults.reloadData()
        }
      
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


//
//  ViewController.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 11/04/2023.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tvResults: UITableView!
    @IBOutlet weak var cvLevel: UICollectionView!
    
    var results: [ResultVO] = []
    
    var dbtable: String = "dtb_n5"
    var dblevel: String = "N5"
    let lvls = [1,2,3,4,5]
    var lvlArray : [LevelVO] = [LevelVO]()

    var manager : DBManager!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldPlaceholder()
        lvlArray = []
        for lvl in lvls {
            if lvl == 5 {
                let vo = LevelVO(isSelected: true, table: "dtb_n\(lvl)", level: "N\(lvl)")
                lvlArray.append(vo)
            }else {
                let vo = LevelVO(isSelected: false, table: "dtb_n\(lvl)", level: "N\(lvl)")
                lvlArray.append(vo)
            }
        }
        
        manager = DBManager()
        results = []
        fetchInitialResults(table: dbtable)
        tfSearch.delegate = self
        setUpTableView()
        navigationItem.backButtonTitle = ""
        navigationItem.hidesBackButton = true
        self.title = dblevel
    }
    
    @IBAction func didTapSearch(_ sender: UIButton) {
        self.results = []
        let data = manager.fetchResults(for: tfSearch.text!, table: dbtable)
        results.append(contentsOf: data)
        self.tvResults.reloadData()
        tfSearch.endEditing(true)
    }
    
    func fetchInitialResults(table: String){
        results = []
        let data = manager.fetchInitialResults(table: table)
        self.results.append(contentsOf: data)
        tvResults.reloadData()
        
    }
    
    func setUpTableView(){
        tvResults.dataSource = self
        tvResults.delegate = self
        tvResults.register(UINib(nibName: String(describing: ResultTableViewCell.self), bundle: nil), forCellReuseIdentifier: "tvcresult")
        
        cvLevel.dataSource = self
        cvLevel.delegate = self
        cvLevel.register(UINib(nibName: String(describing: LevelCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "cvclevel")
    }
    
    @IBAction func onTapSetting(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: SettingViewController.self)) as! SettingViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectLevel(index: Int){
        lvlArray = []
        for lvl in lvls {
            if lvl == index {
                let vo = LevelVO(isSelected: true, table: "dtb_n\(lvl)", level: "N\(lvl)")
                lvlArray.append(vo)
            }else{
                let vo = LevelVO(isSelected: false, table: "dtb_n\(lvl)", level: "N\(lvl)")
                
                lvlArray.append(vo)
            }
        }
        self.title = "N\(index)"
        self.dbtable = "dtb_n\(index)"
        fetchInitialResults(table: dbtable)
        cvLevel.reloadData()
    }
    
    func setTextFieldPlaceholder(){
        switch getOption(){
            case "kana":
                tfSearch.placeholder = "Search with Hiragana/Katakana"
            case "romaji":
                tfSearch.placeholder = "Search with Romaji"
            case "meaning_mm":
                tfSearch.placeholder = "Search with Myanmar"
            default:
                tfSearch.placeholder = "Search"
        }
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
        let data = manager.fetchResults(for: tfSearch.text!, table: dbtable)
        self.results.append(contentsOf: data)
        self.tvResults.reloadData()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.results = []
        let data = manager.fetchResults(for: tfSearch.text!, table: dbtable)
        self.results.append(contentsOf: data)
        if tfSearch.text! == "" {
            fetchInitialResults(table: dbtable)
        }
        self.tvResults.reloadData()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if tfSearch.text == nil || tfSearch.text == "" {
            setTextFieldPlaceholder()
            results = []
            tvResults.reloadData()
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
        switch getOption() {
            case "kana":
                cell.lbl.text = results[indexPath.row].kana
            case "romaji":
                cell.lbl.text = results[indexPath.row].kana
            case "meaning_mm":
                cell.lbl.text = results[indexPath.row].meaning_mm
            default:
                cell.lbl.text = results[indexPath.row].kana
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcresultdetail") as! ResultDetailViewController
        vc.vo = results[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        tvResults.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvclevel", for: indexPath) as! LevelCollectionViewCell
        cell.vo = lvlArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/5.8, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectLevel(index: indexPath.row+1)
    }
}

func getOption()->String{
    let option = UserDefaults.standard.string(forKey: "searchOption")
    return option!
}

//
//  ViewController.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 11/04/2023.
//

import UIKit
import SQLite

//MARK: - Unique Key for Notification Center Observers
let romaji = "co.pcent.romaji"
let kana = "co.pcent.kana"
let mm = "co.pcent.mm"
let kanji = "co.pcent.kanji"

class ViewController: UIViewController {
    //MARK: - IB Outlets
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
        manager = DBManager()
        initializeLevel()
        fetchInitialResults(table: dbtable)
        setTextFieldPlaceholder()
        tfSearch.delegate = self
        setUpTableView()
        navigationItem.backButtonTitle = ""
        self.title = dblevel
        addObservers()
        
    }
    
    //MARK: - NotificationCenter Observers
    func addObservers(){
        let romajiname = Notification.Name(romaji)
        let kananame = Notification.Name(kana)
        let mmname = Notification.Name(mm)
        let kanjiname = Notification.Name(kanji)
        
        NotificationCenter.default.addObserver(self, selector: #selector(observerFunc), name: romajiname, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(observerFunc), name: kananame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(observerFunc), name: mmname, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(observerFunc), name: kanjiname, object: nil)
    }
    
    @objc func observerFunc(){
        fetchInitialResults(table: dbtable)
        setTextFieldPlaceholder()
    }
    
    //MARK: - Fetch Results
    func fetchInitialResults(table: String){
        results = []
        let data = manager.fetchInitialResults(table: table)
        self.results.append(contentsOf: data)
        tvResults.reloadData()
        
    }
    
    //MARK: - Initialize UI
    func setUpTableView(){
        tvResults.dataSource = self
        tvResults.delegate = self
        tvResults.register(UINib(nibName: String(describing: ResultTableViewCell.self), bundle: nil), forCellReuseIdentifier: "tvcresult")
        
        cvLevel.dataSource = self
        cvLevel.delegate = self
        cvLevel.register(UINib(nibName: String(describing: LevelCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "cvclevel")
    }
    
    func initializeLevel(){
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

    }
    //Handle Level Selection
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
    
    //MARK: - IB Actions
    //Setting Button Action
    @IBAction func onTapSetting(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: SettingViewController.self)) as! SettingViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //Search Button Action
    @IBAction func didTapSearch(_ sender: UIButton) {
        self.results = []
        let data = manager.fetchResults(for: tfSearch.text!, table: dbtable)
        results.append(contentsOf: data)
        self.tvResults.reloadData()
        tfSearch.endEditing(true)
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
    //TextField Placeholder Change
    func setTextFieldPlaceholder(){
        switch getOption(){
            case "kana":
                tfSearch.placeholder = "Search with Hiragana/Katakana"
            case "romaji":
                tfSearch.placeholder = "Search with Romaji"
            case "meaning_mm":
                tfSearch.placeholder = "Search with Myanmar"
            case "kanji":
                tfSearch.placeholder = "Search with Kanji"
            default:
                tfSearch.placeholder = "Search"
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
            case "kanji":
                cell.lbl.text = results[indexPath.row].kanji
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

//MARK: - Collection View Delegate and Datasourcec
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

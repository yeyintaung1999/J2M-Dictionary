//
//  DBManager.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 18/04/2023.
//

import Foundation

protocol DBProtocol{
    func fetchResults(for key: String) -> [ResultVO]
    func fetchInitialResults()->[ResultVO]
}

class DBManager: DBProtocol{
    
    var table: String = ""
    var level: String = ""
   
    init(table: String, level: String){
        self.table = table
        self.level = level
    }
    
    func fetchResults(for key: String) -> [ResultVO] {
        var results: [ResultVO] = [ResultVO]()
        let query = "SELECT * FROM \(table) WHERE romaji LIKE '%\(key)%'"
        
        for item in try! database.prepare(query){
            let vo = ResultVO(
                kana: item[3] as! String,
                romaji: item[2] as! String,
                kanji: item[4] as! String,
                meaning_mm: item[5] as! String
            )
            results.append(vo)
        }
        
        return results
        
    }
    
    func fetchInitialResults() -> [ResultVO] {
        var results: [ResultVO] = [ResultVO]()
        let query = "SELECT * FROM \(table)"
        
        for item in try! database.prepare(query){
            let vo = ResultVO(
                kana: item[3] as! String,
                romaji: item[2] as! String,
                kanji: item[4] as! String,
                meaning_mm: item[5] as! String
            )
            results.append(vo)
        }
        
        return results
    }
    
}

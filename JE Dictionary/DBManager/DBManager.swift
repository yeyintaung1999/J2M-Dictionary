//
//  DBManager.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 18/04/2023.
//

import Foundation

protocol DBProtocol{
    func fetchResults(for key: String, table: String) -> [ResultVO]
    func fetchInitialResults(table: String)->[ResultVO]
}

class DBManager: DBProtocol{
    //Results for Search with query
    func fetchResults(for key: String, table: String) -> [ResultVO] {
        let option = getOption()
        var results: [ResultVO] = [ResultVO]()
        let query = "SELECT * FROM \(table) WHERE \(option) LIKE '%\(key)%'"
        
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
    //Initial Data Results
    func fetchInitialResults(table: String) -> [ResultVO] {
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

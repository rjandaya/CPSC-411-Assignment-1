//
//  ClaimDAO.swift
//  RestfulServer
//
//  Created by RJ Andaya on 10/25/20.
//
import SQLite3

struct Claim: Codable{
    var id_: String
    var title_: String?
    var date_: String?
    var isSolved_: Int
    
    init(id: String, title: String?, date: String?, isSolved: Int) {
        id_ = id
        title_ = title
        date_ = date
        isSolved_ = isSolved
    }
}

class ClaimDAO {
    func addClaim(cObj: Claim) {
        let sqlStmt = String(format: "insert into claim (id, title, date, is_solved) values ('%@', '%@', '%@', 0)", cObj.id_, cObj.title_!, cObj.date_!)
//        Get database connection
        let conn = Database.getInstance().getDBConnection()
        
//        Submit the insert sql statement
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert a Claim record due to error \(errcode)")
        }
//        Close connection
        sqlite3_close(conn)
    }
    
    func getAll() -> [Claim] {
        var cList = [Claim]()
        var resultSet: OpaquePointer?
        var sqlStr = "select id, title, date, is_solved from claim"
        let conn = Database.getInstance().getDBConnection()
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while sqlite3_step(resultSet) == SQLITE_ROW {
//                Convert the record into a Claim object
//                Unsafe_Pointer<CChar> Sqlite3
                let id_val = sqlite3_column_text(resultSet, 0)
                let id = String(cString: id_val!)
                let title_val = sqlite3_column_text(resultSet, 1)
                let title = String(cString: title_val!)
                let date_val = sqlite3_column_text(resultSet, 2)
                let date = String(cString: date_val!)
                let isSolved_val = sqlite3_column_int(resultSet, 3)
                let isSolved = Int(isSolved_val)
                cList.append(Claim(id: id, title: title, date: date, isSolved: isSolved))
            }
        }
        return cList
    }
}

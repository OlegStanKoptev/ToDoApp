//
//  Task.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 17.02.2021.
//

import Foundation

@objc class Task: NSObject, Identifiable, NSCoding {
    enum Status: String {
        case new
        case done
    }
    
    var id: String
    var title: String?
    var note: String?
    var dateDue: Date?
    var hasTime: Bool
    var status: Status
    var flag: Bool
    
    init(id: String = UUID().uuidString, title: String?, note: String?, dateDue: Date?, hasTime: Bool = false, status: Status = .new, flag: Bool = false) {
        self.id = id
        self.title = title
        self.note = note
        self.dateDue = dateDue
        self.hasTime = hasTime
        self.status = status
        self.flag = flag
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! String
        title = aDecoder.decodeObject(forKey: "title") as? String
        note = aDecoder.decodeObject(forKey: "note") as? String
        dateDue = aDecoder.decodeObject(forKey: "dateDue") as? Date
        hasTime = aDecoder.decodeObject(forKey: "hasTime") as! Int8 == 1 ? true : false
        status = Status(rawValue: aDecoder.decodeObject(forKey: "status") as! String) ?? .new
        flag = aDecoder.decodeObject(forKey: "flag") as! Int8 == 1 ? true : false
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(note, forKey: "note")
        aCoder.encode(dateDue, forKey: "dateDue")
        aCoder.encode(hasTime ? 1 as Int8 : 0 as Int8, forKey: "hasTime")
        aCoder.encode(status.rawValue, forKey: "status")
        aCoder.encode(flag ? 1 as Int8: 0 as Int8, forKey: "flag")
    }
}

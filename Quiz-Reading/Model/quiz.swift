//
//  quiz.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/07.
//

import Foundation
import RealmSwift

class Quiz: Object {
    @objc dynamic var question = ""
    @objc dynamic var answer = ""
    @objc dynamic var id = ""
    @objc dynamic var date = ""
    let listQuiz = List<Quiz>()
    override static func primaryKey() -> String? {
        return "id"
    }
}

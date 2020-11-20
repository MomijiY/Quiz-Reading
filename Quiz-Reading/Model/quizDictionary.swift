//
//  quizDictionary.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/15.
//


import Foundation
import RealmSwift

class QuizDictionary: Object {
    @objc dynamic var question = ""
    @objc dynamic var answer = ""
    @objc dynamic var id = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

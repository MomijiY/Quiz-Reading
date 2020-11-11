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
}

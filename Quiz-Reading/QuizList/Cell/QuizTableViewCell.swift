//
//  QuizTableViewCell.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/07.
//

import UIKit

class QuizTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    static let reuseIdentifier = "QuizTableViewCell"
    static let rowHeight: CGFloat = 60
    static var nib: UINib {
        return UINib(nibName: "QuizTableViewCell", bundle: nil)
    }
    
    func setUpCell(question: String, answer: String) {
        questionLabel.text = question
        answerLabel.text = answer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

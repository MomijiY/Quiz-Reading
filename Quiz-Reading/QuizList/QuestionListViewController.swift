//
//  QuestionListViewController.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/07.
//

import UIKit

class QuestionListViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        // Do any additional setup after loading the view.
    }
    

    func setLayout() {
        addButton.layer.cornerRadius = 40
    }
}

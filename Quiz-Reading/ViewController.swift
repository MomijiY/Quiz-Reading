//
//  ViewController.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/06.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var readingButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }


    func setLayout() {
        readingButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
    }
}


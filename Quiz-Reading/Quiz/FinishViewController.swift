//
//  FinishViewController.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/08.
//

import UIKit

class FinishViewController: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var gradeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        finishButton.layer.cornerRadius = 10
        
        let correctAnswer = UserDefaults.standard.object(forKey: "correctAnswer")
        let allQuizNum = UserDefaults.standard.object(forKey: "allQuizNum")
        gradeLabel.text = "正答率 \n \(correctAnswer!)/\(allQuizNum!)"
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func tappedFinishButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHomeView", sender: nil)
    }

}

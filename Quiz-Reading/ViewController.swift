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
    @IBAction func tappedReadingButton(_ sender: UIButton) {
        if UserDefaults.standard.array(forKey: "QUIZ") != nil {
            if UserDefaults.standard.array(forKey: "QUIZ")!.count > 0 {
                self.performSegue(withIdentifier: "toReading", sender: nil)
            } else {
                let alert = UIAlertController(title: "表示するクイズがありません", message: "先に下の「追加」ボタンから\nクイズを追加してください。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setLayout() {
        readingButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
    }
    
    func alert(title:String, message:String) {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}


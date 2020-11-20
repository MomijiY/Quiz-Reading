//
//  AddContentTableViewController.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/07.
//

import UIKit
import RealmSwift

class AddContentTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let realm = try! Realm()
    let items = Quiz()
    
    var quizArray: [Dictionary<String, String>] = []
//    var quizCount: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.delegate = self
        answerTextField.delegate = self
        configureUI()
        
        if UserDefaults.standard.array(forKey: "QUIZ") != nil {
            quizArray = UserDefaults.standard.array(forKey: "QUIZ") as! [Dictionary<String, String>]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        questionTextView.delegate = self
        answerTextField.delegate = self
        configureUI()
        
        if UserDefaults.standard.array(forKey: "QUIZ") != nil {
            quizArray = UserDefaults.standard.array(forKey: "QUIZ") as! [Dictionary<String, String>]
        }
    }
    @IBAction func tappedSaveButton(_ sender: UIButton) {
        saveQuiz()
    }
    func configureUI() {
        questionTextView.becomeFirstResponder()
        //color
        questionTextView.tintColor = UIColor(red: 0/255, green: 145/255, blue: 147/255, alpha: 1.0)
        answerTextField.tintColor = UIColor(red: 0/255, green: 145/255, blue: 147/255, alpha: 1.0)
        
        //toolbar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        spacelItem.tintColor = UIColor(red: 0/255, green: 145/255, blue: 147/255, alpha: 1.0)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        doneItem.tintColor = UIColor(red: 0/255, green: 145/255, blue: 147/255, alpha: 1.0)
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        let toolbar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        spacelItem2.tintColor = UIColor(red: 0/255, green: 145/255, blue: 147/255, alpha: 1.0)
        let doneItem2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        doneItem2.tintColor = UIColor(red: 0/255, green: 145/255, blue: 147/255, alpha: 1.0)
        toolbar2.setItems([spacelItem2, doneItem2], animated: true)
        
        questionTextView.inputAccessoryView = toolbar
        answerTextField.inputAccessoryView = toolbar2
    }
    
    func saveQuiz() {
        if questionTextView.text == "" || answerTextField.text == ""{
            alert(title: "問題または回答の欄に空白があります。", message: "問題とそれに対する答えを入力してください。")
            
        } else {
            items.question = questionTextView.text!
            items.answer = answerTextField.text!
            
            let quizDictionary = ["question": items.question, "answer": items.answer]
            quizArray.append(quizDictionary)
            UserDefaults.standard.set(quizArray, forKey: "QUIZ")
            
//            let quizDictionary = ["question": items.question, "answer": items.answer]
//            let dicQuiz = Quiz(value: quizDictionary)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
            try! realm.write{
                let quiz = [Quiz(value: ["question": items.question, "answer": items.answer, "id": UUID().uuidString, "date": dateFormatter.string(from: Date())])]
                realm.add(quiz)
//                realm.add(dicQuiz)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func done() {
        questionTextView.endEditing(true)
    }
    
    @objc func done2() {
        answerTextField.endEditing(true)
    }
    
    func alert(title:String, message:String) {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 2
//    }
    
}

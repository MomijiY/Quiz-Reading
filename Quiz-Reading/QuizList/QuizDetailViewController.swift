//
//  QuizDetailViewController.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/07.
//

import UIKit
import RealmSwift

class QuizDetailViewController: UITableViewController {

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let realm = try! Realm()
    let quiz =  Quiz()
    var quizArray: [Dictionary<String, String>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.text = UserDefaults.standard.object(forKey: "question") as? String
        answerTextField.text = UserDefaults.standard.object(forKey: "answer") as? String
        
        configureUI()
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func tappedSaveButton(_ sender: UIButton) {
        if questionTextView.text == "" || answerTextField.text == "" {
            alert(title: "問題または回答の欄に空白があります。", message: "問題とそれに対する答えを入力してください。")
        }
        quiz.question = questionTextView.text!
        quiz.answer = answerTextField.text!
        let quizDictionary = ["question": quiz.question, "answer": quiz.answer]
        quizArray.append(quizDictionary)
        UserDefaults.standard.set(quizArray, forKey: "QUIZ")
        
        let results = realm.objects(Quiz.self)
        try! realm.write{
            results.setValue(questionTextView.text!, forKey: "question")
            results.setValue(answerTextField.text!, forKey: "answer")
            quiz.question = questionTextView.text!
            quiz.answer = answerTextField.text!
        }
        self.navigationController?.popViewController(animated: true)
    }

    func configureUI() {
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
    
    func alert(title:String, message:String) {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    @objc func done() {
        questionTextView.endEditing(true)
    }
    
    @objc func done2() {
        answerTextField.endEditing(true)
    }
}


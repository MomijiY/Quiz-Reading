//
//  ListTableViewController.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/07.
//

import UIKit
import RealmSwift

class ListTableViewController: UITableViewController {

    var Item: Results<Quiz>!
    var items = [Quiz]()
    var quizArray: [Dictionary<String, String>] = []
    
    let realm = try! Realm()
    let cellHeight: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "QUIZ") as? [Dictionary<String, String>] != nil {
            quizArray = UserDefaults.standard.object(forKey: "QUIZ") as! [Dictionary<String, String>]
        }
        
        tableView.register(QuizTableViewCell.nib, forCellReuseIdentifier: QuizTableViewCell.reuseIdentifier)
        loadQuiz()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadQuiz()
    }
    
    func loadQuiz() {
        let results = realm.objects(Quiz.self)
        items = [Quiz]()
        
        for qz in results {
            items.append(qz)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuizTableViewCell.reuseIdentifier, for: indexPath) as! QuizTableViewCell
        
        let content = items[indexPath.row]
        
        cell.setUpCell(question: content.question, answer: content.answer)

        let selectionView = UIView()
        selectionView.backgroundColor = UIColor(red: 230/255, green: 220/255, blue: 201/255, alpha: 1.0)
        cell.selectedBackgroundView = selectionView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            try! realm.write {
                print("削除")
                realm.delete(items[indexPath.row])
                items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                quizArray.remove(at: indexPath.row)
                tableView.reloadData()
                UserDefaults.standard.setValue(quizArray, forKey: "QUIZ")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quiz = items[indexPath.row]
        UserDefaults.standard.set(quiz.question, forKey: "question")
        UserDefaults.standard.set(quiz.answer, forKey: "answer")
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

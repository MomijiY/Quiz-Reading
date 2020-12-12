//
//  ListTableViewController.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/07.
//

import UIKit
import RealmSwift

class ListTableViewController: UITableViewController {

    var quizzes = [Quiz]()
    var quizArray: [Dictionary<String, String>] = []
    
    let realm = try! Realm()
    let cellHeight: CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(QuizTableViewCell.nib, forCellReuseIdentifier: QuizTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        navigationController?.setNavigationBarHidden(false, animated: true)
        loadQuiz()
    }
    
    func loadQuiz() {
        if UserDefaults.standard.object(forKey: "QUIZ") as? [Dictionary<String, String>] != nil {
            quizArray = UserDefaults.standard.object(forKey: "QUIZ") as! [Dictionary<String, String>]
            print("quizArray:\(quizArray)")
            quizzes = [Quiz]()
            
            let results = realm.objects(Quiz.self).sorted(byKeyPath: "date")
            
            for qz in results {
                quizzes.append(qz)
                print("quizzes:\(quizzes)")
            }
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quizzes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuizTableViewCell.reuseIdentifier, for: indexPath) as! QuizTableViewCell
        
        let content = quizzes[indexPath.row]
        
        cell.setUpCell(question: content.question, answer: content.answer)
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor(red: 0/255, green: 145/255, blue: 147/255, alpha: 0.6)
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
                realm.delete(quizzes[indexPath.row])
                quizzes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                quizArray.remove(at: indexPath.row)
                tableView.reloadData()
                UserDefaults.standard.setValue(quizArray, forKey: "QUIZ")
                print(quizArray)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quiz = quizzes[indexPath.row]
        UserDefaults.standard.set(quiz.question, forKey: "question")
        UserDefaults.standard.set(quiz.answer, forKey: "answer")
        UserDefaults.standard.set(quiz.id, forKey: "id")
        UserDefaults.standard.set(indexPath.row + 1, forKey: "indexPath")
        UserDefaults.standard.set(quizArray, forKey: "quizFromList")
        print("indexPathNum:", indexPath.row + 1, "quizArray.count: ", quizArray.count)
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

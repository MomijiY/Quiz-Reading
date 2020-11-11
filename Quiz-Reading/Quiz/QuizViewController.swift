//
//  QuizViewController.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/07.
//

import UIKit
import RealmSwift
import AVFoundation

class QuizViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var showAnswerButton: UIButton!
    
    var Item: Results<Quiz>!
    var items = [Quiz]()
    var quizArray: [Dictionary<String, String>] = []
    var isAnswered: Bool = false
    var nowNumber: Int = 0
    var answerButtonTappedCount: Int = 0
    var showButtonTappedCount: Int = 0
    var showAnswerBool: Bool = false
    
    let speechService = SpeechService()
    let answerSpeechService = AnswerSpeechService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizArray = UserDefaults.standard.object(forKey: "QUIZ") as! [Dictionary<String, String>]
        quizArray.shuffle()
        questionLabel.text = quizArray[nowNumber]["question"]
        answerLabel.text = ""
        setUpLayout()
        UserDefaults.standard.removeObject(forKey: "showAnswer")
        //イヤホンジャックが抜けた時に止める
        NotificationCenter.default.addObserver(self, selector: #selector(onAudioSessionRouteChange(notification:)), name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        answerButtonTappedCount = 1
        speechService.say(questionLabel.text!)
        nextButton.setTitle("分かった", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        speechService.stop()
    }
    @IBAction func tappedNextButton(_ sender: UIButton) {
        print("answerButtonTappedCount: \(nowNumber),\(answerButtonTappedCount)")
        if answerButtonTappedCount == 0 {
            nowNumber += 1
            answerButtonTappedCount = 1
            answerLabel.text = ""
            if nowNumber < quizArray.count {
                self.navigationController?.navigationItem.title = "Q.\(nowNumber)"
                questionLabel.text = quizArray[nowNumber]["question"]
                speechService.say(questionLabel.text!)
                isAnswered = false
                nextButton.setTitle("分かった", for: .normal)
                print("isAnswered = false \(isAnswered)")
            } else {
                UserDefaults.standard.set(quizArray.count, forKey: "allQuizNum")
                let correctAnswer = quizArray.count - showButtonTappedCount
                UserDefaults.standard.set(correctAnswer, forKey: "correctAnswer")
                nowNumber = 0
                answerButtonTappedCount = 0
                performSegue(withIdentifier: "toFinishView", sender: nil)
            }
        } else if answerButtonTappedCount == 1 {
            answerButtonTappedCount = 2
            nextButton.setTitle("答えを表示", for: .normal)
            speechService.stop()
        } else {
            answerLabel.text = quizArray[nowNumber]["answer"]
            isAnswered = true
            showAnswerButton.setTitle("分からない", for: .normal)
            nextButton.setTitle("次へ", for: .normal)
            readAnswer()
            speechService.stop()
            answerButtonTappedCount = 0
        }
    }
    
    @IBAction func tappedShowAnswerButton(_ sender: UIButton) {
        showButtonTappedCount += 1
        showAnswerBool = true
        UserDefaults.standard.set(showAnswerBool, forKey: "showAnswer")
        answerLabel.text = quizArray[nowNumber]["answer"]
        isAnswered = true
        showAnswerButton.setTitle("分からない", for: .normal)
        nextButton.setTitle("次へ", for: .normal)
        readAnswer()
        speechService.stop()
    }

    func readAnswer() {
        speechService.stop()
        answerSpeechService.say(answerLabel.text!)
    }
    
    func setUpLayout() {
        nextButton.layer.cornerRadius = 10
        showAnswerButton.layer.cornerRadius = 10
    }
    
    @objc func onAudioSessionRouteChange(notification :NSNotification) {
        speechService.stop()
        answerSpeechService.stop()
    }
}

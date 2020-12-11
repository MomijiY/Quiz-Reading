//
//  QuizViewController.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/07.
//

import UIKit
import RealmSwift
import AVFoundation

class QuizViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var enterAnswerTextField: UITextField!
    @IBOutlet weak var enterAnswerView: UIView!
    @IBOutlet weak var enterAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionTextView: Timertext!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var Item: Results<Quiz>!
    var items = [Quiz]()
    var quizArray: [Dictionary<String, String>] = []
    var isAnswered: Bool = false
    var nowNumber: Int = 0
    var answerButtonTappedCount: Int = 0
    var correctButtonTappedCount: Int = 0
    var enterAnswerButtonTappedCount: Int = 0
    var player: AVAudioPlayer?
    
    let speechService = SpeechService()
    let answerSpeechService = AnswerSpeechService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerLabel.isHidden = true
        quizArray = UserDefaults.standard.object(forKey: "QUIZ") as! [Dictionary<String, String>]
        quizArray.shuffle()
        print(quizArray)
        questionLabel.text = quizArray[nowNumber]["question"]
        answerLabel.text = quizArray[nowNumber]["answer"]
        questionLabel.isHidden = true
        answerLabel.text = ""
        setUpLayout()
        UserDefaults.standard.removeObject(forKey: "showAnswer")
        //イヤホンジャックが抜けた時に止める
        NotificationCenter.default.addObserver(self, selector: #selector(onAudioSessionRouteChange(notification:)), name: AVAudioSession.routeChangeNotification, object: nil)
        questionTextView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if let textView = object as? UITextView {
                var topCorrect = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
                topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
                textView.contentInset.top = topCorrect
            }
        }
        deinit {
            questionTextView.removeObserver(self, forKeyPath: "contentSize")
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        answerLabel.isHidden = true
        answerButtonTappedCount = 1
        questionTextView.text = quizArray[nowNumber]["question"]
        answerLabel.text = quizArray[nowNumber]["answer"]
        speechService.say(questionTextView.text)
        questionTextView.startAnimation()
        navItem.title = "第\(nowNumber + 1)問/\(quizArray.count)問"
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
                answerLabel.isHidden = true
                navItem.title = "第\(nowNumber + 1)問/\(quizArray.count)問"
                questionLabel.text = quizArray[nowNumber]["question"]
                questionTextView.text = quizArray[nowNumber]["question"]
                answerLabel.text = quizArray[nowNumber]["answer"]
                speechService.say(questionTextView.text)
                questionTextView.startAnimation()
                answerSpeechService.stop()
                isAnswered = false
                nextButton.setTitle("回答する", for: .normal)
                enterAnswerButtonTappedCount = 0
            } else {
                speechService.stop()
                answerSpeechService.stop()
                UserDefaults.standard.set(quizArray.count, forKey: "allQuizNum")
                let correctAnswer = correctButtonTappedCount
                UserDefaults.standard.set(correctAnswer, forKey: "correctAnswer")
                nowNumber = 0
                answerButtonTappedCount = 0
                correctButtonTappedCount = 0
                performSegue(withIdentifier: "toFinishView", sender: nil)
            }
        } else if answerButtonTappedCount == 1 {
            answerButtonTappedCount = 2
            let soundURL = Bundle.main.url(forResource: "Quiz-Buzzer", withExtension: "mp3")
            do {
                player = try! AVAudioPlayer(contentsOf: soundURL!)
                player?.play()
            }
            nextButton.setTitle("答えを表示", for: .normal)
            speechService.stop()
            questionTextView.stopAnimation()
            
            enterAnswerView.isHidden = false
            enterAnswerTextField.isHidden = false
            enterAnswerButton.isHidden = false
            enterAnswerTextField.becomeFirstResponder()
            self.view.backgroundColor = UIColor(red: 209/255, green: 236/255, blue: 209/255, alpha: 0.8)
        } else {
            showAnswer()
        }
    }
    
    @IBAction func tappedEnterAnswerButton(_ sender: UIButton) {
        enterAnswerButtonTappedCount += 1
        enterAnswerView.isHidden = true
        enterAnswerTextField.isHidden = true
        enterAnswerButton.isHidden = true
        enterAnswerTextField.endEditing(true)
        showAnswer()
        self.view.backgroundColor = UIColor(red: 209/255, green: 236/255, blue: 209/255, alpha: 1.0)
        if answerLabel.text == enterAnswerTextField.text {
            enterAnswerButtonTappedCount = 0
            correctButtonTappedCount += 1
            let soundURL = Bundle.main.url(forResource: "Quiz-Correct", withExtension: "mp3")
            do {
                player = try! AVAudioPlayer(contentsOf: soundURL!)
                player?.play()
            }
            print("correct")
        } else {
            alert(title: "違います", message: "")
            enterAnswerButtonTappedCount = 0
            let soundURL = Bundle.main.url(forResource: "Quiz-Wrong", withExtension: "mp3")
            do {
                player = try! AVAudioPlayer(contentsOf: soundURL!)
                player?.play()
            }
            print("incorrect")
        }
        enterAnswerTextField.text  = ""
    }

    @IBAction func tappedBackButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toHome", sender: nil)
    }
    func readAnswer() {
        speechService.stop()
        answerSpeechService.say(answerLabel.text!)
    }
    
    func stopAnswer() {
        answerSpeechService.stop()
    }
    
    func showAnswer() {
        answerLabel.isHidden = false
        answerLabel.text = quizArray[nowNumber]["answer"]
        nextButton.setTitle("次へ", for: .normal)
        readAnswer()
        speechService.stop()
        questionTextView.text = quizArray[nowNumber]["question"]
        answerButtonTappedCount = 0
    }
    func setUpLayout() {
        enterAnswerTextField.delegate = self
        nextButton.layer.cornerRadius = 10
        enterAnswerButton.layer.cornerRadius = 10
        enterAnswerView.layer.cornerRadius = 10
        
        enterAnswerTextField.borderStyle = .none
        enterAnswerTextField.layer.cornerRadius = 10
        enterAnswerTextField.layer.borderColor = UIColor.black.cgColor
        enterAnswerTextField.layer.borderWidth = 1
        enterAnswerTextField.layer.masksToBounds = true
        enterAnswerTextField.tintColor = UIColor(red: 0/255, green: 145/255, blue: 147/255, alpha: 1.0)
        
        enterAnswerView.isHidden = true
        enterAnswerTextField.isHidden  = true
        enterAnswerButton.isHidden = true
        
        enterAnswerTextField.delegate = self
        navigationBar.barTintColor = UIColor(red: 209/255, green: 236/255, blue: 209/255, alpha: 0)
    }
    func alert(title:String, message:String) {
        var alertController: UIAlertController!
            alertController = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil))
            present(alertController, animated: true)
        }
    @objc func onAudioSessionRouteChange(notification :NSNotification) {
        speechService.stop()
        answerSpeechService.stop()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterAnswerTextField.resignFirstResponder()
        return true
    }
}

extension UITextView {
    var isAnimating: Bool {
        return layer.animationKeys() != nil
    }
}

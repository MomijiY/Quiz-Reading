//
//  AnswerSpeechService.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/08.
//
import UIKit
import AVFoundation

class AnswerSpeechService {
    private let synthesizer = AVSpeechSynthesizer()
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    var voice = AVSpeechSynthesisVoice(language: "ja_JP")
    
    func say(_ phrase: String) {
        // 話す内容をセット
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.rate = rate
        utterance.voice = voice

        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    func getVoices() {
        AVSpeechSynthesisVoice.speechVoices().forEach({ print($0.language) })
    }
}

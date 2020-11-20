//
//  TimerText.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/13.
//

import UIKit

class Timertext: UITextView {
    var titlestr:String!

    //表示文字のインデックス
    var idx = 0

    //処理中フラグ
    var flgRun = false

    var timer: Timer?
    override func draw(_ rect: CGRect) {

        let tmr = Timer.scheduledTimer(
            timeInterval: 0.05,
            target: self,
            selector: #selector(tickTimer(_:)),
            userInfo: nil,
            repeats: true)

        titlestr = self.text
        self.text = ""

        tmr.fire()
    }

    func startAnimation() {
        let tmr = Timer.scheduledTimer(
            timeInterval: 0.15,
            target: self,
            selector: #selector(tickTimer(_:)),
            userInfo: nil,
            repeats: true)

        titlestr = self.text
        self.text = ""

        tmr.fire()
    }
    
    func stopAnimation() {
        let tmr = Timer.scheduledTimer(
            timeInterval: 0.15,
            target: self,
            selector: #selector(tickTimer(_:)),
            userInfo: nil,
            repeats: true)

        titlestr = self.text
        self.text = ""

        tmr.invalidate()
    }
    
    func startFastAnimation() {
        let tmr = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(tickTimer(_:)),
            userInfo: nil,
            repeats: true)

        titlestr = self.text
        self.text = ""

        tmr.fire()
    }
    @objc func tickTimer(_ timer: Timer) {
        //表示文字インデックス判定
        if idx < titlestr.count {
            self.text = titlestr.substring(to: titlestr.index(titlestr.startIndex, offsetBy: idx))

            //表示文字のインデックスのインプリメント
            idx += 1
        } else {
            self.text = titlestr
            //タイマーの停止
            timer.invalidate()

            //処理中フラグOFF
            flgRun = false
            idx = 0
        }
    }
}

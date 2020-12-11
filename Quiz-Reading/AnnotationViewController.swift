//
//  AnnotationViewController.swift
//  Quiz-Reading
//
//  Created by 吉川椛 on 2020/11/29.
//

//import UIKit
//import Gecco
// 
//class AnnotationViewController: SpotlightViewController {
//     
//    var annotationViews: [UIView] = []
//     
//    var stepIndex: Int = 0
//     
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        delegate = self
//         
//        // ボタン等を強調した時に表示したいテキストがある場合は、ここで annotationViews に追加する
//        let message: UILabel = UILabel(frame: CGRect(x:0, y: 0, width: self.view.bounds.width, height: 150))
//        message.text = "チュートリアルで表示したいメッセージ1"
//        message.layer.position = CGPoint(x: self.view.bounds.width/2, y: 300)
//        self.view.addSubview(message)
//        annotationViews.append(message)
//    }
//     
//    func next(_ labelAnimated: Bool) {
//        updateAnnotationView(labelAnimated)
//         
//        let screenSize = UIScreen.main.bounds.size
//        switch stepIndex {
//        case 0:
//            spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width/2, y: 320), size: CGSize(width: screenSize.width, height: 500), cornerRadius: 50))
//        case 1:
//            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width - 28, y: 42), diameter: 50))
//        case 2:
//            spotlightView.move(Spotlight.Oval(center: CGPoint(x: 28, y: 42), diameter: 50))
//        case 3:
//            dismiss(animated: true, completion: nil)
//        default:
//            break
//        }
//         
//        stepIndex += 1
//    }
//     
//    func updateAnnotationView(_ animated: Bool) {
//        annotationViews.enumerated().forEach { index, view in
//            UIView.animate(withDuration: animated ? 0.25 : 0) {
//                view.alpha = index == self.stepIndex ? 1 : 0
//            }
//        }
//    }
//}
// 
//extension AnnotationViewController: SpotlightViewControllerDelegate {
//    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
//        
//    }
//    
//    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
//        next(false)
//    }
//     
//    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
//        next(true)
//    }
//     
//    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
//        spotlightView.disappear()
//    }
//}

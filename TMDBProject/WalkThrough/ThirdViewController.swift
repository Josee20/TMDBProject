//
//  ThirdViewController.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/17.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.backgroundColor = .black
        startButton.setTitle("시작!!!", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        startButton.layer.cornerRadius = 20
        startButton.clipsToBounds = true
        startButton.layer.opacity = 0
        
        UIView.animate(withDuration: 1) {
            self.startButton.layer.opacity = 1
        } completion: { _ in
            
        }
    }
    @IBAction func startBtnClicked(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false)
        
        let tutorialFinished = true
        UserDefaults.standard.set(tutorialFinished, forKey: "tutorial")
        
    }
}

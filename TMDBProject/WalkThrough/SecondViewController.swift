//
//  SecondViewController.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/17.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var introduceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        introduceLabel.alpha = 0
        introduceLabel.text = "세상 모든 영화를 한 번에!!!"
        introduceLabel.font = .boldSystemFont(ofSize: 20)
        introduceLabel.textAlignment = .center
        
        UIView.animate(withDuration: 2) {
            self.introduceLabel.alpha = 1
        } completion: { _ in
            
        }

        
    }
    

    

}

//
//  ACPayOneViewController.swift
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/12.
//

import UIKit

class ACPayOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        creatUI()
    }
    

    func creatUI() {
        let payDetailV = ACPayDetailView(frame: CGRect(x: 0, y: 100, width: KScreenWidth, height: 300))
        view.addSubview(payDetailV)
        payDetailV.HeaderL.text = KLanguage(key: "Upgrade PRO")
    }

}

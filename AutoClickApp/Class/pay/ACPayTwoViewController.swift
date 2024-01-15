//
//  ACPayTwoViewController.swift
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/14.
//

import UIKit

class ACPayTwoViewController: UIViewController {

    var selectIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        creatUI()
    }
    

    func creatUI() {
        let bgImageV = UIImageView("pay_bg")
        view.addSubview(bgImageV)
        bgImageV.contentMode = .scaleAspectFill
        bgImageV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let disbtn = UIButton(type: .custom)
        disbtn.frame = CGRect(x: 14, y: bmStatusBarHeight(), width: 44, height: 44)
        view.addSubview(disbtn)
        disbtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        let btnImage = UIImageView("pay_close")
        btnImage.frame = CGRect(x: 10, y: 10, width: 24, height: 24)
        disbtn.addSubview(btnImage)
        disbtn.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            UIView.animate(withDuration: 1) {
                disbtn.alpha = 1
            }
        }
        
        var topHeight = bmStatusBarHeight() + 120
        var bottomHeight = 82
        var centerHeight = 55
        if isX == false {
            topHeight = bmStatusBarHeight() + 110
            bottomHeight = 32
            centerHeight = 55
        }
        
        let payDetailV = ACPayDetailView(frame: CGRect(x: 0, y: topHeight, width: KScreenWidth, height: 210))
        view.addSubview(payDetailV)
        payDetailV.HeaderL.text = KLanguage(key: "auto clicker") + " " + KLanguage(key: "PRO")
        
        
        let bClabel = UILabel()
        // 设置带下划线的文本
        let text = KLanguage(key: "Terms of Service")
        let underlineAttriString = NSMutableAttributedString(string: text)
        underlineAttriString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: text.count)
        )
        bClabel.attributedText = underlineAttriString

        // 添加点击手势
        bClabel.isUserInteractionEnabled = true
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(bclabelTapped))
        bClabel.addGestureRecognizer(labelTapGesture)
        bClabel.frame = CGRect(x: KScreenWidth/2, y: KScreenHeight - BottomHomeHeight - CGFloat(bottomHeight), width: 100, height: 14)
        bClabel.font = .pingFangRegular(10)
        bClabel.textColor = RGBA(r: 255, g: 255, b: 255, a: 0.6)
        bClabel.sizeToFit()
        bClabel.centerX = KScreenWidth / 2
        
        let bClabel1 = UILabel()
        // 设置带下划线的文本
        let text1 = KLanguage(key: "Privacy Policy")
        let underlineAttriString1 = NSMutableAttributedString(string: text1)
        underlineAttriString1.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: text1.count)
        )
        bClabel1.attributedText = underlineAttriString1

        // 添加点击手势
        bClabel1.isUserInteractionEnabled = true
        let labelTapGesture1 = UITapGestureRecognizer(target: self, action: #selector(bllabelTapped))
        bClabel1.addGestureRecognizer(labelTapGesture1)
        bClabel1.frame = CGRect(x: KScreenWidth/2, y: KScreenHeight - BottomHomeHeight - 82, width: 100, height: 14)
        bClabel1.font = .pingFangRegular(10)
        bClabel1.textColor = RGBA(r: 255, g: 255, b: 255, a: 0.6)
        bClabel1.sizeToFit()
        
        
        
        let bClabel2 = UILabel()
        // 设置带下划线的文本
        let text2 = KLanguage(key: "Resume purchase")
        let underlineAttriString2 = NSMutableAttributedString(string: text2)
        underlineAttriString2.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: text2.count)
        )
        bClabel2.attributedText = underlineAttriString2

        // 添加点击手势
        bClabel2.isUserInteractionEnabled = true
        let labelTapGesture2 = UITapGestureRecognizer(target: self, action: #selector(brlabelTapped))
        bClabel2.addGestureRecognizer(labelTapGesture2)
        bClabel2.frame = CGRect(x: KScreenWidth/2, y: KScreenHeight - BottomHomeHeight - 82, width: 100, height: 14)
        bClabel2.font = .pingFangRegular(10)
        bClabel2.textColor = RGBA(r: 255, g: 255, b: 255, a: 0.6)
        bClabel2.sizeToFit()
        view.addSubview(bClabel)
        view.addSubview(bClabel1)
        view.addSubview(bClabel2)
        
        
        bClabel1.snp.makeConstraints { make in
            make.centerY.equalTo(bClabel)
            make.right.equalTo(bClabel.snp.left).offset(-10)
            make.height.equalTo(14)
        }
        bClabel2.snp.makeConstraints { make in
            make.centerY.equalTo(bClabel)
            make.left.equalTo(bClabel.snp.right).offset(10)
            make.height.equalTo(14)
        }
        let l = UILabel()
        l.font = .pingFangRegular(10)
        l.textColor = RGBA(r: 255, g: 255, b: 255, a: 0.6)
        l.text = "-"
        l.textAlignment = .center
        view.addSubview(l)
        l.snp.makeConstraints { make in
            make.centerY.equalTo(bClabel)
            make.right.equalTo(bClabel.snp.left)
            make.height.equalTo(14)
            make.width.equalTo(10)

        }
        
        let r = UILabel()
        r.font = .pingFangRegular(10)
        r.textColor = RGBA(r: 255, g: 255, b: 255, a: 0.6)
        r.text = "-"
        r.textAlignment = .center
        view.addSubview(r)
        r.snp.makeConstraints { make in
            make.centerY.equalTo(bClabel)
            make.left.equalTo(bClabel.snp.right)
            make.height.equalTo(14)
            make.width.equalTo(10)

        }
        
        let continuebtn = UIButton(type: .custom)
        continuebtn.frame = CGRect(x: 14, y: bmStatusBarHeight(), width: 44, height: 44)
        view.addSubview(continuebtn)
        continuebtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        continuebtn.backgroundColor = .white
        continuebtn.layer.cornerRadius = 11
        continuebtn.layer.masksToBounds = true
        continuebtn.snp.makeConstraints { make in
            make.bottom.equalTo(bClabel.snp.top).offset(-8)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        continuebtn.setTitle(KLanguage(key: "continue"), for: .normal)
        continuebtn.titleLabel?.font = .pingFangSCMedium(14)
        continuebtn.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        let imageV1 = UIImageView("guider_click")
        imageV1.frame = CGRect(x: KScreenWidth - 40 - 48, y: 16, width: 24, height: 24)
        continuebtn.addSubview(imageV1)
        continuebtn.setTitleColor(.black, for: .normal)
       
        let labelPro1 = UILabel(frame: CGRect(x: 20, y: topHeight, width: 47, height: 25))
        labelPro1.font = .pingFangRegular(12)
        labelPro1.textColor = UIColor.hex("9E9E9E")
        labelPro1.text = KLanguage(key: "Unlock all advanced features now")
        view.addSubview(labelPro1)
        labelPro1.snp.makeConstraints { make in
            make.bottom.equalTo(continuebtn.snp.top).offset(-24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(17)
        }
        
        let labelPro2 = UILabel(frame: CGRect(x: 20, y: topHeight, width: 47, height: 25))
        labelPro2.font = .pingFangSCMedium(12)
        labelPro2.textColor = .white
        labelPro2.text = KLanguage(key: "Only the price of 1 cup of coffee")
        view.addSubview(labelPro2)
        labelPro2.snp.makeConstraints { make in
            make.bottom.equalTo(labelPro1.snp.top).offset(-4)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(17)
        }
        let payChooseView = ACPayChooseView(frame: CGRect(x: 0, y: payDetailV.bottom + CGFloat(centerHeight), width: KScreenWidth, height: 90))
        view.addSubview(payChooseView)
        payChooseView.chooseBack = { index in
            self.selectIndex = index
        }
    }
    
    @objc func dismissAction(){
        self.dismiss(animated: true)
    }
    @objc func bclabelTapped() {
            print("Label 被点击了")
            // 处理点击事件
        }
    @objc func bllabelTapped() {
            print("Label 被点击了")
            // 处理点击事件
        }
    @objc func brlabelTapped() {
            print("Label 被点击了")
            // 处理点击事件
        }
    @objc func continueAction() {
            print("Label 被点击了")
            // 处理点击事件
    }
}

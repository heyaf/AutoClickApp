//
//  ACPayChooseView.swift
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/14.
//

import UIKit

class ACPayChooseView: UIView {
    var chooseBack : ((Int)->())?

    var leftButton = UIButton()
    var rightButton = UIButton()
    var LeftbgView = UIView()
    var RightbgView = UIView()

    public var selectIndex = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI(){
        let leftBtn = UIButton(type: .custom)
        leftBtn.frame = CGRect(x: 20, y: 0, width: (Int(KScreenWidth) - 40 - 13)/2 , height: 90)
        addSubview(leftBtn)
        leftBtn.layer.borderWidth = 2
        leftBtn.layer.borderColor = UIColor.hex("994AFF").cgColor
        leftBtn.layer.cornerRadius = 16
        leftBtn.clipsToBounds = true
        leftBtn.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        leftButton = leftBtn
        leftBtn.backgroundColor = .black
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: Int(leftBtn.right) + 13, y: 0, width: (Int(KScreenWidth) - 40 - 13)/2 , height: 90)
        addSubview(rightBtn)
        rightBtn.layer.borderWidth = 2
        rightBtn.layer.borderColor = UIColor.hex("242424").cgColor
        rightBtn.layer.cornerRadius = 16
        rightBtn.clipsToBounds = true
        rightBtn.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        rightButton = rightBtn
        rightBtn.backgroundColor = .black
        
        let leftbgView = UIView(frame: CGRect(x: -10, y: -10, width: 72, height: 34))
        leftbgView.backgroundColor = .black
        leftBtn.addSubview(leftbgView)
        leftbgView.layer.cornerRadius = 9
        leftbgView.clipsToBounds = true
        LeftbgView = leftbgView
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 72, height: 24))
        label.textAlignment = .center
        label.text = KLanguage(key: "85%OFF")
        label.font = .pingFangSCSemibold(10)
        leftbgView.addSubview(label)
        label.textColor = .white
        label.backgroundColor = UIColor.hex("994AFF")
        let Leftlabel = UILabel(frame: CGRect(x: 10, y: 27, width: leftBtn.width - 20 , height: 22))
        Leftlabel.textAlignment = .center
        Leftlabel.text = "$16.99 / year"
        Leftlabel.font = .pingFangSCSemibold(16)
        leftBtn.addSubview(Leftlabel)
        Leftlabel.textColor = .white
        let LeftBlabel = UILabel(frame: CGRect(x: 10, y: 50, width: leftBtn.width - 20 , height: 14))
        LeftBlabel.textAlignment = .center
        let str = KLanguage(key: "that's $1.42 a month")
        let str1 = str.replacingOccurrences(of: "**", with: "8.99")
        LeftBlabel.text = str1
        LeftBlabel.font = .pingFangSCMedium(14)
        leftBtn.addSubview(LeftBlabel)
        LeftBlabel.textColor = .white
        
        let rightbgView = UIView(frame: CGRect(x: -10, y: -10, width: 72, height: 34))
        rightbgView.backgroundColor = .black
        rightBtn.addSubview(rightbgView)
        rightbgView.layer.cornerRadius = 9
        rightbgView.clipsToBounds = true
        RightbgView = rightbgView
        let label1 = UILabel(frame: CGRect(x: 10, y: 10, width: 72, height: 24))
        label1.textAlignment = .center
        label1.text = KLanguage(key: "85%OFF")
        label1.font = .pingFangSCSemibold(10)
        rightbgView.addSubview(label1)
        label1.backgroundColor = UIColor.hex("994AFF")
        let RightL = UILabel(frame: CGRect(x: 10, y: 27, width: leftBtn.width - 20 , height: 22))
        RightL.textAlignment = .center
        RightL.text = "$16.99 / year"
        RightL.font = .pingFangSCSemibold(16)
        rightBtn.addSubview(RightL)
        rightbgView.isHidden = true
        label1.textColor = .white
        RightL.textColor = .white
        
    }
    @objc func leftAction(){
        selectIndex = 0
        RightbgView.isHidden = true
        LeftbgView.isHidden = false
        rightButton.layer.borderColor = UIColor.hex("242424").cgColor
        leftButton.layer.borderColor = UIColor.hex("994AFF").cgColor
        self.chooseBack?(0)
    }
    @objc func rightAction(){
        selectIndex = 1
        RightbgView.isHidden = false
        LeftbgView.isHidden = true
        leftButton.layer.borderColor = UIColor.hex("242424").cgColor
        rightButton.layer.borderColor = UIColor.hex("994AFF").cgColor
        self.chooseBack?(1)

    }
}

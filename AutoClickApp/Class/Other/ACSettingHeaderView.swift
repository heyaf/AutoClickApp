//
//  ACSettingHeaderView.swift
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/17.
//

import UIKit

class ACSettingHeaderView: UIView {

    @objc var payBack : (()->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI(){
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 16, y: 16, width: KScreenWidth - 32, height: frame.height - 16)
        btn .setBackgroundImage(UIImage(named: "banner"), for: .normal)
        addSubview(btn)
        btn.addTarget(self, action: #selector(clickedAction), for: .touchUpInside)
        
        let label = UILabel(frame: CGRectMake(24 + 16, FitWidth(25) + 16, KScreenWidth - 48 - 32, 34))
        label.font = .pingFangSCMedium(24)
        label.textColor = .white
        label.text = KLanguage(key: "Get Premium")
        addSubview(label)
        //"Unlock all paid features and"
        
        let label1 = UILabel(frame: CGRectMake(24 + 16, label.bottom + 11, KScreenWidth - 48 - 32, 15))
        label1.font = .pingFangRegular(14)
        label1.textColor = .white
        label1.text = KLanguage(key: "Unlock all paid features and")
        addSubview(label1)
        let label2 = UILabel(frame: CGRectMake(24 + 16, label1.bottom + 11, KScreenWidth - 48 - 32, 15))
        label2.font = .pingFangRegular(14)
        label2.textColor = .white
        label2.text = KLanguage(key: "permissions")
        addSubview(label2)
        
        let imageV = UIImageView("set_right1")
        imageV.frame = CGRect(x: KScreenWidth - 40 - 30, y: FitWidth(16) + 16, width: 30, height: 30);
        addSubview(imageV)
        
    }
    @objc func clickedAction(){
        payBack?()
    }
}

//
//  ACPayDetailView.swift
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/12.
//

import UIKit

class ACPayDetailView: UIView {

    public lazy var HeaderL : UILabel = {
        let label = UILabel()
        label.font = .pingFangSCSemibold(24)
        label.textColor = .white
        label.frame = CGRect(x: 20, y: 33, width: Int(KScreenWidth) - 40, height: 34)
        
        
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setUI()
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI(){
        addSubview(HeaderL)
        
        let imageV = UIImageView("pay_choose")
        addSubview(imageV)
        imageV.frame = CGRect(x: 20, y: HeaderL.bottom + 21 , width: 24, height: 24)
        
        let Label = UILabel(frame: CGRect(x: imageV.right + 8, y: imageV.y + 4, width: KScreenWidth - imageV.right - 28, height: 16))
        Label.font = .pingFangRegular(12)
        Label.textColor = .white
        addSubview(Label)
        Label.text = KLanguage(key: "Unlock the Web's auto-click feature")
        
        
        let imageV1 = UIImageView("pay_choose")
        addSubview(imageV1)
        imageV1.frame = CGRect(x: 20, y: imageV.bottom + 18 , width: 24, height: 24)
        
        let Label1 = UILabel(frame: CGRect(x: imageV.right + 8, y: imageV1.y + 4, width: KScreenWidth - imageV.right - 28, height: 16))
        Label1.font = .pingFangRegular(12)
        Label1.textColor = .white
        addSubview(Label1)
        Label1.text = KLanguage(key: "How to solve automatic clicking in other APPs")
        
        let imageV2 = UIImageView("pay_choose")
        addSubview(imageV2)
        imageV2.frame = CGRect(x: 20, y: imageV1.bottom + 18 , width: 24, height: 24)
        
        let Label2 = UILabel(frame: CGRect(x: imageV.right + 8, y: imageV2.y + 4, width: KScreenWidth - imageV.right - 28, height: 16))
        Label2.font = .pingFangRegular(12)
        Label2.textColor = .white
        addSubview(Label2)
        Label2.text = KLanguage(key: "Unlock Privacy Album and Privacy Browser")
        
        
        let imageV3 = UIImageView("pay_choose")
        addSubview(imageV3)
        imageV3.frame = CGRect(x: 20, y: imageV2.bottom + 18 , width: 24, height: 24)
        
        let Label3 = UILabel(frame: CGRect(x: imageV.right + 8, y: imageV3.y + 4, width: KScreenWidth - imageV.right - 28, height: 16))
        Label3.font = .pingFangRegular(12)
        Label3.textColor = .white
        addSubview(Label3)
        Label3.text = KLanguage(key: "Unlock the document scanning function")
        
    }
    

}

//
//  ACPayOneView.swift
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/16.
//

import UIKit
import MBProgressHUD

class ACPayOneView: UIView {

    @objc var disMissBack : (()->())?
    var dismissBtn = UIButton()
    var continueBtn = UIButton()

    var clickedPay = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        setUI()
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI(){
    
        let bgImageV = UIImageView("pay_bg")
        addSubview(bgImageV)
        bgImageV.contentMode = .scaleAspectFill
        bgImageV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let disbtn = UIButton(type: .custom)
        disbtn.frame = CGRect(x: 14, y: bmStatusBarHeight()-10, width: 44, height: 44)
        addSubview(disbtn)
        disbtn.addTarget(self, action: #selector(diMissTapped), for: .touchUpInside)
        
        let btnImage = UIImageView("pay_close")
        btnImage.frame = CGRect(x: 10, y: 10, width: 24, height: 24)
        disbtn.addSubview(btnImage)
        disbtn.alpha = 0
       dismissBtn = disbtn
        
        var topHeight = bmStatusBarHeight() + 220
        var bottomHeight = 140

        if isX == false {
            topHeight = bmStatusBarHeight() + 200
            bottomHeight = 72

        }
        let labelPro = UILabel(frame: CGRect(x: 20, y: topHeight, width: 47, height: 25))
        labelPro.textAlignment = .center
        labelPro.font = .pingFangSCSemibold(12)
        labelPro.textColor = UIColor.hex("8A38F5")
        labelPro.text = KLanguage(key: "PRO")
        labelPro.layer.cornerRadius = 5
        labelPro.layer.masksToBounds = true
        labelPro.backgroundColor = UIColor.hex("E7D4FF")
        addSubview(labelPro)
        
        let payDetailV = ACPayDetailView(frame: CGRect(x: 0, y: labelPro.bottom + 8, width: KScreenWidth, height: 300))
        addSubview(payDetailV)
        payDetailV.HeaderL.text = KLanguage(key: "Upgrade PRO")
        
        
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
        addSubview(bClabel)
        addSubview(bClabel1)
        addSubview(bClabel2)
        
        
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
        addSubview(l)
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
        addSubview(r)
        r.snp.makeConstraints { make in
            make.centerY.equalTo(bClabel)
            make.left.equalTo(bClabel.snp.right)
            make.height.equalTo(14)
            make.width.equalTo(10)

        }
        
        let continuebtn = UIButton(type: .custom)
        continuebtn.frame = CGRect(x: 14, y: bmStatusBarHeight(), width: 44, height: 44)
        addSubview(continuebtn)
        continuebtn.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        continuebtn.backgroundColor = .white
        continuebtn.layer.cornerRadius = 28
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
        labelPro1.textAlignment = .center
        labelPro1.font = .pingFangRegular(12)
        labelPro1.textColor = RGBA(r: 255, g: 255, b: 255, a: 0.9)
        let str = KLanguage(key: "Go Premium for $8.99/mo")
        var str1 = str.replacingOccurrences(of: "**", with: "$8.99")
        let productInfoDefaults = UserDefaults.standard
        if let arrdata = productInfoDefaults.object(forKey: "productInfoDefaultsKey") as? [[String : String]] , arrdata.count == 2{
            // 使用 arr，它是一个 [Any] 类型的数组
            let dic = arrdata[0]
            str1 = str.replacingOccurrences(of: "**", with: (dic["finalPrice"] ?? "8.99"))
        }
        continueBtn = continuebtn
        continuebtn.alpha = 0
        labelPro1.text = str1
        addSubview(labelPro1)
        labelPro1.snp.makeConstraints { make in
            make.bottom.equalTo(continuebtn.snp.top).offset(-12)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(17)        }
    }
    
    
    @objc func bclabelTapped() {
        clickedPay = false
        openUrl("https://fair-chalk-fc5.notion.site/Term-of-use-b7afe95e11e54b93be6b1fe349ad0214?pvs=4")


        }
    @objc func bllabelTapped() {
        clickedPay = false
        openUrl("https://fair-chalk-fc5.notion.site/Privacy-Policy-63a04c8f370449c09b61fadb28d5dbea?pvs=4")

        }
    @objc func brlabelTapped() {
        clickedPay = false

        PayCenter.sharedInstance().restorePay()
        PayCenter.sharedInstance().paySuccessBlock = {
            let date = Date.getNewDateDistanceNow(year: 0, month: 1, days: 0)
            let dateStr = Date.dateToString(date, dateFormat: "yyyy-MM-dd HH:mm:ss")
            UserDefaults.standard.setValue(dateStr, forKey: "payInfo");
            self.clickedPay = false
            self.disMissBack?()
        }
        }
    @objc func diMissTapped() {
        if clickedPay {
            NotificationCenter.default.post(name:NSNotification.Name("ACShowPay"), object: nil)

            clickedPay = false
        }
        disMissBack?()
    }
    @objc func showView() {
        dismissBtn.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            UIView.animate(withDuration: 1) {
                self.dismissBtn.alpha = 1
            }
        }
        continueBtn.alpha = 1
    }
    @objc func continueAction() {
    
        clickedPay = true
        PayCenter.sharedInstance().payItem(IAP1_ProductID)
        PayCenter.sharedInstance().paySuccessBlock = {
            let date = Date.getNewDateDistanceNow(year: 0, month: 1, days: 0)
            let dateStr = Date.dateToString(date, dateFormat: "yyyy-MM-dd HH:mm:ss")
            UserDefaults.standard.setValue(dateStr, forKey: "payInfo");
            self.clickedPay = false
            self.disMissBack?()
        }
        
    }
    func openUrl(_ urlStr: String) {
        guard let url = URL(string: urlStr) else {
            print("无法创建URL")
            return
        }

        let application = UIApplication.shared
        if !application.canOpenURL(url) {
            print("无法打开\"\(url)\", 请确保此应用已经正确安装.")
            return
        }

        application.open(url, options: [:], completionHandler: { success in
            // 这里可以处理URL打开之后的回调
        })
    }

}

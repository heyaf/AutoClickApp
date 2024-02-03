//
//  ACPayTwoViewController.swift
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/14.
//

import UIKit
import MBProgressHUD
import FLAnimatedImage
import XYIAPKit
class ACPayTwoViewController: UIViewController {
    
    var selectIndex = 0
    @objc var reloadVip : (() -> ())?
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
            make.left.right.top.equalToSuperview()
            make.height.equalTo(KScreenWidth * 812 / 375)
        }
        
        let disbtn = UIButton(type: .custom)
        disbtn.frame = CGRect(x: 14, y: bmStatusBarHeight() + 10 , width: 44, height: 44)
        view.addSubview(disbtn)
        disbtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        let btnImage = UIImageView("pay_close")
        btnImage.frame = CGRect(x: 10, y: 10, width: 24, height: 24)
        disbtn.addSubview(btnImage)
        disbtn.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0){
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
        continuebtn.addTarget(self, action: #selector(continueAction(_ :)), for: .touchUpInside)
        let animatedImageView = FLAnimatedImageView()
        animatedImageView.frame = CGRect(x: (KScreenWidth - 40) / 2 + 40 , y: 16, width: 24, height: 24)
        continuebtn.addSubview(animatedImageView)
        
        // 设置 GIF 文件名
        let gifFileName = "system-regular"
        if let gifFilePath = Bundle.main.path(forResource: gifFileName, ofType: "gif"),
           let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifFilePath)),
           let animatedImage = FLAnimatedImage(animatedGIFData: gifData) {
            // 设置 FLAnimatedImage 到 FLAnimatedImageView
            animatedImageView.animatedImage = animatedImage
        }
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
        payChooseView.selectBack = { index in
            self.selectIndex = index
            self.continueAction1()
        }
    }
    
    @objc func dismissAction(){
        self.dismiss(animated: true)
    }
    @objc func bclabelTapped() {
        openUrl("https://fair-chalk-fc5.notion.site/Term-of-use-b7afe95e11e54b93be6b1fe349ad0214?pvs=4")
        
        
    }
    @objc func bllabelTapped() {
        openUrl("https://fair-chalk-fc5.notion.site/Privacy-Policy-63a04c8f370449c09b61fadb28d5dbea?pvs=4")
        
    }
    @objc func brlabelTapped() {
        //        let hub = self.showHUD("Loading...")
        //
        //        PayCenter.sharedInstance().restorePay()
        //        PayCenter.sharedInstance().paySuccessBlock = {
        //            let date = Date.getNewDateDistanceNow(year: 0, month: 1, days: 0)
        //            let dateStr = [Date.dateToString(date, dateFormat: "yyyy-MM-dd HH:mm:ss")]
        //            UserDefaults.standard.setValue(dateStr, forKey: "payInfo");
        //            self.dismissAction()
        //            self.reloadVip?()
        //            MBProgressHUD.showSuccessMessage("Recovery successful")
        //            hub.hide(false)
        //        }
        let hub = self.showHUD("Loading...")
        hub.hide(false, afterDelay: 100.0)
        var payID = IAP2_ProductID
        if selectIndex == 1 {
            payID = IAP1_ProductID
        }
        
        XYStore.default().addPayment(payID) { _ in
            var date = Date.getNewDateDistanceNow(year: 1, month: 0, days: 0)
            if self.selectIndex == 1 {
                date = Date.getNewDateDistanceNow(year: 0, month: 1, days: 0)
            }
            let dateStr = [Date.dateToString(date, dateFormat: "yyyy-MM-dd HH:mm:ss")]
            UserDefaults.standard.setValue(dateStr, forKey: "payInfo");
            self.dismissAction()
            self.reloadVip?()
            MBProgressHUD.showSuccessMessage("Recovery successful")
            hub.hide(false)
        } failure: { transaction,_  in
            hub.hide(false)
            if let error = transaction?.error as NSError?, error.code == SKError.paymentCancelled.rawValue {
                // 处理支付被取消的情况
                MBProgressHUD.showErrorMessage(KLanguage(key:"Cancel purchase"))
            }else{
                MBProgressHUD.showErrorMessage(KLanguage(key:"Recovery failed"))
            }
        }
        
    }
    @objc func continueAction(_ btn : UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            btn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                btn.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (finished) in
                UIView.animate(withDuration: 0.1, animations: {
                    btn.transform = CGAffineTransform.identity
                }) { (finished) in
                    self.continueAction1()
                }
            }
        }
    }
    
    @objc func continueAction1() {
        let hub = self.showHUD("Loading...")
        hub.hide(false, afterDelay: 100.0)
        var payID = IAP2_ProductID
        if selectIndex == 1 {
            payID = IAP1_ProductID
        }
        XYStore.default().addPayment(payID) { _ in
            var date = Date.getNewDateDistanceNow(year: 1, month: 0, days: 0)
            if self.selectIndex == 1 {
                date = Date.getNewDateDistanceNow(year: 0, month: 1, days: 0)
            }
            let dateStr = [Date.dateToString(date, dateFormat: "yyyy-MM-dd HH:mm:ss")]
            UserDefaults.standard.setValue(dateStr, forKey: "payInfo");
            self.dismissAction()
            self.reloadVip?()
            hub.hide(false)
            MBProgressHUD.showSuccessMessage("successful")
        } failure: { transaction,_  in
            hub.hide(false)
            if let error = transaction?.error as NSError?, error.code == SKError.paymentCancelled.rawValue {
                // 处理支付被取消的情况
                MBProgressHUD.showErrorMessage(KLanguage(key:"Cancel purchase"))
            }else{
                MBProgressHUD.showErrorMessage(KLanguage(key:"Failed purchase"))
            }
        }
        
        //        PayCenter.sharedInstance().payItem(payID)
        //        PayCenter.sharedInstance().paySuccessBlock = {
        
        //
        //        }
        //        PayCenter.sharedInstance().payfailBlock = {
        //
        //
        //        }
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
extension UIViewController {
    
    func showHUD(_ text: String) -> MBProgressHUD {
        let HUD = MBProgressHUD.showAdded(to: view, animated: true)
        HUD?.labelText = text
        HUD?.removeFromSuperViewOnHide = true
        
        return HUD ?? MBProgressHUD()
    }
    
}
import Foundation

extension Date {
    static func getNewDateDistanceNow(year: Int, month: Int, days: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = days
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: dateComponents, to: Date()) ?? Date()
    }
    
    static func dateToString(_ date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    static func stringToDate(_ dateString: String, dateFormat: String) -> Date {
        if dateString.isEmpty {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    static func compareDate(_ aDate: Date, with bDate: Date) -> Int {
        if aDate == bDate {
            return 0
        } else if aDate < bDate {
            return 1
        } else {
            return -1
        }
    }
}

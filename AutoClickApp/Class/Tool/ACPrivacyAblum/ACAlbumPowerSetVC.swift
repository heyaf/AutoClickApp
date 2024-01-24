//
//  ACAlbumPowerSetVC.swift
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/24.
//

import UIKit
import Photos

class ACAlbumPowerSetVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.hex("#110C10")
        
        setupUI()
    }
    func setupUI() {
        let Label = UILabel(frame: CGRect(x: KScreenWidth / 2 - 80, y: StatusBarHeight + 10, width: 160, height: 20))
        Label.font = .boldSystemFont(ofSize: 16)
        Label.textColor = .white
        Label.textAlignment = .center
        Label.text = KLanguage(key: "Photos")
        view.addSubview(Label)
        
        
        let cancleBtn = UIButton(type: .custom)
        cancleBtn.frame = CGRect(x: KScreenWidth - 50 - SPACE, y: StatusBarHeight + 10, width: 50, height: 20)
        cancleBtn.setTitle(KLanguage(key: "Cancel"), for: .normal)
        cancleBtn.titleLabel?.font = .pingFangRegular(14)
        cancleBtn.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
        cancleBtn.setTitleColor(UIColor(hex: "999999"), for: .normal)
        view.addSubview(cancleBtn)
        
        
        let Label1 = UILabel(frame: CGRect(x: SPACE * 2, y: NavBarAndStatusBarHeight + 100, width: KScreenWidth - SPACE * 4 , height: 50))
        Label1.font = .pingFangRegular(16)
        Label1.textColor = UIColor(hex: "999999")
        Label1.numberOfLines = 2
        Label1.textAlignment = .center
        Label1.text = KLanguage(key: "Face Snap needs your permission to access your photos and continue")
        view.addSubview(Label1)
        
        let setBtn = UIButton(type: .custom)
        setBtn.frame = CGRect(x: KScreenWidth / 2 - 40 , y: Label1.bottom + 60, width: 80, height: 20)
        setBtn.setTitle(KLanguage(key: "Go to Settings"), for: .normal)
        setBtn.titleLabel?.font = .pingFangRegular(16)
        setBtn.setTitleColor(.blue, for: .normal)
        setBtn.addTarget(self, action: #selector(setAction), for: .touchUpInside)
        view.addSubview(setBtn)
    }
    
    @objc func cancleAction (){
        dismiss(animated: true)
    }
    @objc func setAction (){
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL) { Bool in
                self.dismiss(animated: false)
            }
        }
    }
    
    
}

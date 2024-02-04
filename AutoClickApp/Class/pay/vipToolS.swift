//
//  vipTool.swift
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/2/4.
//

import UIKit

class vipToolS: NSObject {

    
    @objc func setVip (type : Int){
        var date = Date.getNewDateDistanceNow(year: 1, month: 0, days: 0)
        if type == 1 {
            date = Date.getNewDateDistanceNow(year: 0, month: 1, days: 0)
        }
        let dateStr = [Date.dateToString(date, dateFormat: "yyyy-MM-dd HH:mm:ss")]
        UserDefaults.standard.setValue(dateStr, forKey: "payInfo");
    }
    @objc func clearVip (){
       
        UserDefaults.standard.setValue([], forKey: "payInfo");
    }
}

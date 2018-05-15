//
//  CommonView.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/14.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import UIKit

/**
 * Date→String
 */
func dateToString(_ date:Date) -> String{
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
    
    let dateString:String = formatter.string(from: date)
    
    return dateString
}

/**
 * Date→String
 */
func stringToDate(_ strDate:String) -> Date?{
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
    let date = formatter.date(from: strDate)
    
    return date!
}




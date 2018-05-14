//
//  CommonExtension.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/14.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import UIKit

/**
 * tableのHeaderをを0
 */
extension ToDoController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

/**
 * tableのHeaderをを0
 */
extension CategoryController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}




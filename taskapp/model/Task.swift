//
//  Task.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/09.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import RealmSwift

/**---------------------------------*
 * Task
 *----------------------------------*/
class Task: Object{
    /** 管理用 ID。プライマリーキー */
    @objc dynamic var id = 0
    
    /** カテゴリID */
    @objc dynamic var categoryId = 0
    
    /** タイトル */
    @objc dynamic var title = ""
    
    /** 内容 */
    @objc dynamic var contents = ""
    
    /** 日時 */
    @objc dynamic var date = Date()
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}

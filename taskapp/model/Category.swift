//
//  Category.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/10.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import RealmSwift

class Category: Object{
    
    /** カテゴリID */
    @objc dynamic var categoryId = 0
    
    /** カテゴリ名 */
    @objc dynamic var categoryName = ""
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "categoryId"
    }
}

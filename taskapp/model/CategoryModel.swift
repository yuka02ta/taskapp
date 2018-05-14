//
//  CategoryModel.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/11.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import RealmSwift

class CategoryModel{
    
    /** Realmインスタンスを取得する */
    let realm = try! Realm()
    
    /** リスト: 日付の降順 */
    var categoryArray : Results<Category>?
    
    /**
     * 初期処理
     */
    func doInit() {
        categoryArray = try! Realm().objects(Category.self).sorted(byKeyPath: "categoryId", ascending: false)
    }
    
    /**
     * リスト取得
     */
    func getCategoryList() -> Results<Category>?{
        return categoryArray
    }
    
    /**
     * taskタイトル取得
     */
    func getCategoryListTitle(_ index: Int) -> String{

        let categoryName = categoryArray![index].categoryName

        return categoryName
    }

    /**
     * 新規行追加
     */
    func doNewCategory(){

        let category = Category()
        
       // doUpdate()

        /** 新規タスク取得 */
        let categoryArray = realm.objects(Category.self)
        if categoryArray.count != 0 {
            category.categoryId = categoryArray.max(ofProperty: "categoryId")! + 1
        }
        
        /** 新規追加 */
        try! realm.write {
            self.realm.add(category, update: true)
        }
    }

    /**
     * 行削除
     */
    func deleteCategory(_ indexPath: IndexPath) -> Bool{

        var ret: Bool = false

        /** データベースから削除する */
        try! realm.write {
            self.realm.delete(self.categoryArray![indexPath.row])
            ret = true
        }

        return ret
    }
    
    /**
     * 更新処理
     */
    func doUpdate(){
        
        /** 更新処理 */
        try! realm.write {
            
            for category in categoryArray!{
                self.realm.add(category, update: true)
            }
        }
    }

    
}

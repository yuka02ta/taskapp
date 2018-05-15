//
//  ToDo.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/11.
//  Copyright © 2018年 y.kawa. All rights reserved.
// UITableViewDataSource

import RealmSwift

/**---------------------------------*
 * ToDoModel
 *----------------------------------*/
class ToDoModel{
    
    /** Realmインスタンスを取得する */
    let realm = try! Realm()
    
    /** taskリスト: 日付の降順 */
    var taskArray : Results<Task>?

    /**
     * 初期処理
     */
    func doInit() {
        taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    /**
     * taskリスト取得
     */
    func getTaskList() -> Results<Task>?{
        return taskArray
    }
    
    /**
     * taskタイトル取得
     */
    func getTaskListTitle(_ index: Int) -> String{
        
        let title = taskArray![index].title
        
        if title == "" {
            return "(タイトルなし)"
        } else {
            return title
        }
    }
    
    /**
     * カテゴリ取得
     */
    func getCategoryName(_ index: Int) -> String{
        
        var categoryName: String
        
        /** id取得 */
        let id = taskArray![index].categoryId
 
        /** カテゴリ取得 */
        let categoryArray = try! Realm().objects(Category.self).filter("categoryId == %@", id)
        
        if categoryArray.count == 0 {
            categoryName = "(カテゴリなし)"
        }else{
            categoryName = categoryArray[0].categoryName
        }
        
        return categoryName
    }
    
    /**
     * task時刻取得
     */
    func getTaskListDate(_ index: Int) -> String{
        
        let date = taskArray![index].date
    
        return dateToString(date)
    }
    
    /**
     * 新規行取得
     */
    func getNewTask() -> Task{
        
        let task = Task()
        
        /** 新規タスク取得 */
        let taskArray = realm.objects(Task.self)
        if taskArray.count != 0 {
            task.id = taskArray.max(ofProperty: "id")! + 1
        }
        
        return task
    }
    
    /**
     * 行削除
     */
    func deleteTask(_ indexPath: IndexPath) -> Bool{
        
        var ret: Bool = false
        
        /** データベースから削除する */
        try! realm.write {
            self.realm.delete(self.taskArray![indexPath.row])
            ret = true
        }
        
        return ret
    }
    
    /**
     * 検索
     */
    func doInq(_ searchText: String){
        
        /** 全件 */
        if searchText.isEmpty {
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)

        } else {
            taskArray = realm
                .objects(Task.self)
                .filter("title BEGINSWITH %@", searchText)
        }
    }
    
}


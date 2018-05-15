//
//  InputViewModel.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/15.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import RealmSwift
import UserNotifications

/**---------------------------------*
 * InputViewModel
 *----------------------------------*/
class InputViewModel{
    
    /** Realmインスタンスを取得する */
    let realm = try! Realm()
    
    /** リスト: 日付の降順 */
    var categoryArray : Results<Category>?
    
    /**
     * 初期処理
     */
    func doInit() {
        categoryArray = try! Realm().objects(Category.self).sorted(byKeyPath: "categoryId", ascending: true)
    }
    
    /**
     * リスト取得
     */
    func getCategoryList() -> Results<Category>?{
        return categoryArray
    }
    
    /**
     * カテゴリ取得
     */
    func getCategoryName(_ id: Int) -> String{
        
        var categoryName: String
        
        let categoryArray = try! Realm().objects(Category.self).filter("categoryId == %@", id)
        
        if categoryArray.count == 0 {
            categoryName = "(カテゴリなし)"
        }else{
            categoryName = categoryArray[0].categoryName
        }
        
        return categoryName
    }
    
    /**
     * タスクのローカル通知を登録する
     */
    func setNotification(task: Task) {
        
        /** ローカル通知の設定取得 */
        let content = getNotificationContent(task: task)
        
        /** ローカル通知が発動するtrigger（日付マッチ）を作成 */
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        /** identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）*/
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        /** ローカル通知を登録 */
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            
            /** error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。 */
            print(error ?? "ローカル通知登録 OK")
        }
        
        /** 未通知のローカル通知一覧をログ出力 */
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }

    /**
     * ローカル通知の設定取得
     */
    func getNotificationContent(task: Task) -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent()
        
        /** タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する) */
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        return content
    }
    
}


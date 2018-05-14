//
//  InputViewController.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/08.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    
    @IBOutlet weak var categorySelect: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /** Realmインスタンスを取得する */
    let realm = try! Realm()
    
    /** task */
    var task: Task!
    
    /**
     * viewDidLoad
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        /** 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する */
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        /** taskセット */
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
    }

    /**
     * didReceiveMemoryWarning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /**
     * 画面が非表示の時に呼ばれる
     */
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.categoryId = 0
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }

        /** タスクの通知 */
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    /**
     * segueで画面遷移するに呼ばれる
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
//        let inputViewController:InputViewController = segue.destination as! InputViewController
//
//        /** カテゴリ押下時 */
//        if segue.identifier == "cellSegue" {
//
//            self.task= task
//        }
    }
    
    /**
     * 戻ってきた時処理
     */
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
    }
    
    /**
     * キーボードを閉じる
     */
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    /**
     * タスクのローカル通知を登録する
     */
    func setNotification(task: Task) {
        
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
}

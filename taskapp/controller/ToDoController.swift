//
//  ToDoController.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/08.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ToDoController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UISearchBar!

    var model: ToDo = ToDo()
    
    /**
     * viewDidLoad
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        search.delegate = self
        search.scopeButtonTitles = ["全て"]
        
        /** 初期処理 */
        model.doInit()
    }
    
    /**
     * didReceiveMemoryWarning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * セル数取得
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getTaskList()!.count
    }
    
    /**
     * 検索
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        /** 検索 */
        model.doInq(searchText)

        /** テーブル再読み込み */
        tableView.reloadData()
    }
    
    /**
     * 各セルの内容を返す
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /** 再利用可能なセル */
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        /** セルに値をセット */
        cell.textLabel?.text = model.getTaskListTitle(indexPath.row)
        cell.detailTextLabel?.text = model.getTaskListDate(indexPath.row)
    
        return cell
    }
    
    /**
     * 各セルの選択時処理
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /** タスク作成/編集画面遷移 */
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    /**
     * セル編集可能
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /**
     * 削除処理
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let btnDelete = UITableViewRowAction(style: .default, title: "削除") {
            action, index in
            self.doCellDelete(tableView, indexPath)
        }
        
        /** 削除ボタン */
        btnDelete.backgroundColor = .red
        
        return [btnDelete]
    }
    
    /**
     * Deleteボタン押下
     */
    func doCellDelete(_ tableView: UITableView, _ indexPath: IndexPath){
        
        var ret: Bool
        /** 削除されたタスクを取得する */
        let task = model.getTaskList()![indexPath.row]

        /** ローカル通知をキャンセルする */
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])

        /** データベースから削除する */
        ret = model.deleteTask(indexPath)
        if ret == true{
            tableView.deleteRows(at: [indexPath], with: .fade)
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
     * segueで画面遷移するに呼ばれる
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let inputCtrl:InputViewController = segue.destination as! InputViewController

        /** セル押下時 */
        if segue.identifier == "cellSegue" {

            /** idx取得 */
            let indexRow = self.tableView.indexPathForSelectedRow!.row
            
            /** 遷移先にセット */
            inputCtrl.task = model.getTaskList()![indexRow]
        }
        /** +押下時 */
        else {
            
            /** 新規タスクセット */
            inputCtrl.task = model.getNewTask()
        }
    }
    
    /**
     * 入力画面から戻ってきたとき
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /** task更新 */
        tableView.reloadData()
    }
    
    /**
     * 入力UI終了処理
     * ・完了押下
     */
//    func textFieldShouldReturn(_ search: UISearchBar) -> Bool {
//
//        /** 非表示にする */
//       search.resignFirstResponder()
//
//        return true
//    }

    /**
     * 入力UI終了処理
     * ・エリア外押下
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        /** 非表示にする */
        if search.isFirstResponder{
            search.resignFirstResponder()
        }
    }
    
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        search.resignFirstResponder()
    }
}


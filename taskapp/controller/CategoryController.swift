//
//  CategoryController.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/10.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    //var myItems: Array<String> = ["タイトル１", "タイトル２", "タイトル３"]
    
    var model: CategoryModel = CategoryModel()
    
    /**
     * viewDidLoad
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        /** 初期処理 */
        model.doInit()
        viewNavBtn()
    }

    /**
     * didReceiveMemoryWarning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * セル編集可能
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /**
     * 追加ボタン押下
     */
     @objc func tapAdd() {
        
        print("追加")
        
        /** 新規追加 */
        //myItems.append("")
        model.doNewCategory()
        
        /** TableViewを再読み込み. */
        //tableView.reloadData()
    }
    
    /**
     * セル数取得
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getCategoryList()!.count
    }
    
    /**
     * セルの設定
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath)

        let titleText = cell.viewWithTag(1) as! UITextField
        titleText.text = model.getCategoryListTitle(indexPath.row)

        return cell
    }
    
    /**
     * 各セルの選択時処理
     */
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        /** タスク作成/編集画面遷移 */
//        //performSegue(withIdentifier: "cellSegue", sender: nil)
//        print(indexPath.row)
//    }
    
    /**
     * 削除処理
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        /** 削除処理セット */
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
        
        /** データベースから削除する */
        ret = model.deleteCategory(indexPath)
        if ret == true{
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
//    /**
//     * 画面が非表示の時に呼ばれる
//     */
//    override func viewWillDisappear(_ animated: Bool) {
//
//        super.viewWillDisappear(animated)
//    }
    
    /**
     * ボタンview
     */
    func viewNavBtn() {
        
        /** 表示変更 */
//        if ？？？？ == true{
        let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAdd))
            navItem.setRightBarButton(btn, animated: false)
//        }
//        else{
//            let btn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(KeyBoard.closeButtonTapped))
//            navItem.setRightBarButton(btn, animated: false)
//        }
        
        
    }

}

/**
 * 閉じるボタンの付いたキーボード
 */
class KeyBoard: UITextField{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /**
     * 閉じるボタンの付いたキーボード作成
     */
    private func commonInit(){
        let tools = UIToolbar()
        tools.frame = CGRect(x: 0, y: 0, width: frame.width, height: 40)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeButtonTapped))
        tools.items = [spacer, closeButton]
        self.inputAccessoryView = tools
    }
    
    @objc func closeButtonTapped(){
        
        self.endEditing(true)
        self.resignFirstResponder()
    }
}


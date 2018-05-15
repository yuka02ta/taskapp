//
//  CategoryController.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/10.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import UIKit
import RealmSwift

/**---------------------------------*
 * デリゲート
 *----------------------------------*/
protocol CategoryUpdateDelegate {
    func doUpdateData(rowIndex index: Int, cellValue value: String)
}

/**---------------------------------*
 * CategoryController
 *----------------------------------*/
class CategoryController: UIViewController, CategoryUpdateDelegate {

    @IBOutlet weak var tableView: UITableView!

    /** モデル */
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
    }

    /**
     * didReceiveMemoryWarning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * 追加ボタン押下
     */
    @IBAction func tapAdd(_ sender: Any) {
        /** 新規追加 */
        model.doNewCategory()
        
        /** TableViewを再読み込み. */
        tableView.reloadData()
    }
    
    /**
     * 削除ボタン押下
     */
    func doCellDelete(_ tableView: UITableView, _ indexPath: IndexPath){
        
        var ret: Bool
        
        /** データベースから削除する */
        ret = model.deleteCategory(indexPath)
        if ret == true{
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        /** TableViewを再読み込み. */
        tableView.reloadData()
    }
    
    /**
     * デリゲートメソッド
     * 行登録処理
     */
    func doUpdateData(rowIndex index: Int, cellValue value: String) -> () {

        /** 登録 */
        model.doUpdate(index, value)
    }
    
    /**
     * 画面が非表示の時に呼ばれる
     */
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
    }
}

/**---------------------------------*
 * tableView
 *----------------------------------*/
extension CategoryController: UITableViewDelegate, UITableViewDataSource{
    
    /**
     * セル数取得
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getCategoryList()!.count
    }
    
    /**
     * 各セルの選択時処理
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    /**
     * セルの設定
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        /** セルを取得して値を設定する */
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! InputTextTableCell

        /** 行番号セット */
        cell.categoryName.tag = indexPath.row
        cell.categoryName.text = model.getCategoryListTitle(indexPath.row)
        cell.delegate = self

        return cell
    }
    
    /**
     * セル編集可能
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /**
     * セルスワイプ処理
     * 削除ボタン表示
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
     * tableのHeaderをを0
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

/**---------------------------------*
 * InputTextTableCell
 * デリゲート
 *----------------------------------*/
class InputTextTableCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate:CategoryUpdateDelegate! = nil
    
    @IBOutlet weak var categoryName: KeyBoard!
    
    /**
     * 初期化
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryName.delegate = self
    }
    
    /**
     * setSelected
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /**
     * 改行押下時
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        /** キーボード閉じる */
        textField.endEditing(true)
        textField.resignFirstResponder()
        
        return true
    }
    
    /**
     * デリゲート
     * 値変更時呼び出し
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
 
        /** 行更新 */
        self.delegate.doUpdateData(rowIndex: textField.tag, cellValue: textField.text!)
    }
}




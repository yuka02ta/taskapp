//
//  InputViewController.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/08.
//  Copyright © 2018年 y.kawa. All rights reserved.
//

import UIKit
import RealmSwift

/**---------------------------------*
 * InputViewController
 *----------------------------------*/
class InputViewController: UIViewController{
    
    @IBOutlet weak var categorySelect: UITextField!
    @IBOutlet weak var titleTextField: KeyBoard!
    @IBOutlet weak var contentsTextView: KeyBoardView!
    @IBOutlet weak var datePicker: UITextField!
    
    /** モデル */
    var model: InputViewModel = InputViewModel()
    
    /** Realmインスタンスを取得する */
    let realm = try! Realm()
    
    /** task */
    var task: Task!
    
    var pickerView: UIPickerView = UIPickerView()
    let datePickerView:UIDatePicker = UIDatePicker()
    
    /**
     * viewDidLoad
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        /** 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する */
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        /** カテゴリーPickerセット */
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        categorySelect.inputView = pickerView
        
        /** datePickerセット */
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.inputView = datePickerView
        
        /** taskセット */
        categorySelect.tag = task.categoryId
        categorySelect.text = model.getCategoryName(task.categoryId)
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.text = dateToString(task.date)
        
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
     * 画面が非表示の時に呼ばれる
     */
    override func viewWillDisappear(_ animated: Bool) {
        
        try! realm.write {
            self.task.categoryId = self.categorySelect.tag
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = stringToDate(self.datePicker.text!)!
            self.realm.add(self.task, update: true)
        }

        /** タスクの通知 */
        model.setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    /**
     * segueで画面遷移するに呼ばれる
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
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
     * 日時押下時
     */
    @IBAction func textFieldEditing(sender: UITextField) {

        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    /**
     * 日時変更時処理
     */
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        datePicker.text = dateToString(sender.date)
    }
}

/**---------------------------------*
 * カテゴリーピッカー
 *----------------------------------*/
extension InputViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    /**
     * コンポーネント数
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
     * コンポーネント内の行数
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.getCategoryList()!.count
    }
    
    /**
     * 行ごとに設定されたタイトル
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.getCategoryList()![row].categoryName
    }
    
    /**
     * 行が選択されたときにテキストフィールドのテキストを更新
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorySelect.tag = model.getCategoryList()![row].categoryId
        categorySelect.text = model.getCategoryList()![row].categoryName
    }
}

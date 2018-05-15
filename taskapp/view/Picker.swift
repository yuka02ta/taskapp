//
//  Picker.swift
//  taskapp
//
//  Created by KawasumiYuka on 2018/05/15.
//  Copyright © 2018年 y.kawa. All rights reserved.
//
//
import UIKit

/**---------------------------------*
 * CategoryPickerTextField: textField
 *----------------------------------*/
class CategoryPickerTextField: UITextField, UIPickerViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit(){

        /** ツールバー作成 */
        let tools: UIToolbar = UIToolbar()
        tools.frame = CGRect(x: 0, y: 0, width: frame.width, height: 40)

        /** ツールバーボタン作成 */
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(title: "キャンセル", style: .done, target: self, action: #selector(cancel))
        tools.items = [spacer, doneItem, cancelItem]

        self.inputAccessoryView = tools
    }

    @objc func cancel() {
        self.tag = 0
        self.text = "(カテゴリなし)"
        self.endEditing(true)
    }

    @objc func done() {
        self.endEditing(true)
    }
}

/**---------------------------------*
 * DateickerTextField: 日付
 *----------------------------------*/
class DateickerTextField: UITextField, UIPickerViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        
        /** ツールバー作成 */
        let tools: UIToolbar = UIToolbar()
        tools.frame = CGRect(x: 0, y: 0, width: frame.width, height: 40)
        
        /** ツールバーボタン作成 */
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(title: "今日", style: .done, target: self, action: #selector(today))
        tools.items = [spacer, doneItem, cancelItem]
        
        self.inputAccessoryView = tools
    }
    
    @objc func today() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        
        let dateString:String = formatter.string(from: Date())
        
        self.text = dateString
        self.endEditing(true)
    }
    
    @objc func done() {
        self.endEditing(true)
    }
}


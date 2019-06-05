//
//  TransactionViewController.swift
//  CryptoTracker
//
//  Created by Alexander Schüßling on 22.05.19.
//  Copyright © 2019 UTS. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var coinPicker: UIPickerView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var bar: UISegmentedControl!
    
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var quantityText: UITextField!
    @IBOutlet weak var transactionFeeText: UITextField!
    
    var q = 0.0
    var c = ""
    var timer: Timer?
    var change: Bool = false
    
    //String(format: "$%.02f", currencies[c]!)
    @IBAction func amountAction(_ sender: UITextField) {
        let coin: String = currString[coinPicker.selectedRow(inComponent: 0)]
        let value: Double = currencies[coin]!
        if amountText.text!.prefix(1) == "$" {
            amountText.text!.removeFirst()
        }
        let newQ: Double = Double(self.amountText.text!)! / value
        q = newQ
        c = coin
        quantityText.text = String(format: "%.02f", newQ)
        amountText.text = String(format: "$%.02f", Double(self.amountText.text!)!)
        change = true
    }
    
    @IBAction func quantityAction(_ sender: UITextField) {
        q = Double(quantityText.text!)!
        let coin: String = currString[coinPicker.selectedRow(inComponent: 0)]
        let value: Double = currencies[coin]!
        let newV: Double = Double(self.quantityText.text!)! * value
        c = coin
        amountText.text = String(format: "$%.02f", newV)
        change = true
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if q == 0 {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            return
        }
        if bar.selectedSegmentIndex == 0 {
            holdings[c]! += q
        }
        else {
            holdings[c]! -= q
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currString.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currString[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    func setupView() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        amountText.keyboardType = UIKeyboardType.decimalPad
        quantityText.keyboardType = UIKeyboardType.decimalPad
        transactionFeeText.keyboardType = UIKeyboardType.decimalPad
        coinPicker.delegate = self
        coinPicker.dataSource = self
        coinPicker.layer.cornerRadius = 5
        saveButtonOutlet.layer.cornerRadius = 5
    }

}

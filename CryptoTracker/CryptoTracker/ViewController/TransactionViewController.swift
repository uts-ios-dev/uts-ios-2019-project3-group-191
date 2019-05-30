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
    var amountTimer = Timer()
    var quantityTimer = Timer()
    var a = 0.0
    
    //String(format: "$%.02f", currencies[c]!)
    @IBAction func amountAction(_ sender: UITextField) {
        let coin: String = currString[coinPicker.selectedRow(inComponent: 0)]
        let value: Double = currencies[coin]!
        let newQ: Double = Double(self.amountText.text!)! / value
        q = newQ
        c = coin
        print(String(newQ))
        quantityText.text = String(format: "%.02f", newQ)
    }
    
    @IBAction func quantityAction(_ sender: UITextField) {
        q = Double(quantityText.text!)!
        let coin: String = currString[coinPicker.selectedRow(inComponent: 0)]
        let value: Double = currencies[coin]!
        let newV: Double = Double(self.quantityText.text!)! * value
        a = newV
        c = coin
        print(newV)
        amountText.text = String(format: "%.02f", newV)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
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
        amountText.text = "123"
        super.viewDidLoad()
        setupView()
        //runAmountUpdater()
        //runQuantityUpdater()
    }
    
    func setupView() {
        coinPicker.delegate = self
        coinPicker.dataSource = self
        coinPicker.layer.cornerRadius = 5
        saveButtonOutlet.layer.cornerRadius = 5
    }
    
    
    /*
     //this is the code to update the Amount in real time (or as close to real time as possible.
     @objc func runAmountUpdater() {
     amountTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: (#selector(amountUpdater)), userInfo: nil, repeats: true)
     }
     
     //this updates the amount at each time interval
     @objc func amountUpdater() {
     print(String(a))
     //amountText.text = String(format: "%.02f", a)
     }
     
     //this is the code to update the Quantity in real time (or as close to real time as possible.
     @objc func runQuantityUpdater() {
     quantityTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: (#selector(quantityUpdater)), userInfo: nil, repeats: true)
     }
     
     //this updates the quantity at each time interval
     @objc func quantityUpdater() {
     //quantityText.text = String(format: "%.02f", String(a))
     print(String(q))
     }
     */
}

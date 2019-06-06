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
    
    var q = 0.0
    var c = ""
    var timer: Timer?
    var change: Bool = false
    
    //this code grabs the amount value in the quantity text field, divides it by the price amount of the cryptocurrency the coinpicker currently sits, and updates it into the quantity text field.
    @IBAction func amountAction(_ sender: UITextField) {
        let coin: String = currString[coinPicker.selectedRow(inComponent: 0)]
        let value: Double = currencies[coin]!
        if amountText.text!.prefix(1) == "$" {
            amountText.text!.removeFirst()
        }
        do {
            try checkValidAmount()
        }
        catch InputError.NotANumberError(let message) {
            print(message)
            amountText.text = ""
            quantityText.text = ""
            return
        }
        catch {
            print("Unknown Error!")
            exit(10)
        }
        //this converts the amount by price of coin into quantity
        let newQ: Double = Double(self.amountText.text!)! / value
        //q and c are values to be used to modify the holdings in the main view. q is the quantity, and c is the type of cryptocurrency.
        q = newQ
        c = coin
        
        //this prints the value on both quantity and amount text field.
        quantityText.text = String(format: "%.02f", newQ)
        amountText.text = String(format: "$%.02f", Double(self.amountText.text!)!)
        change = true
    }
    
    //this code grabs the quantity value in the quantity text field, multiplies it by the price amount of the cryptocurrency the coinpicker currently sits, and updates it into the amount text field.
    @IBAction func quantityAction(_ sender: UITextField) {
        do {
            try checkValidQuantity()
        }
        catch InputError.NotANumberError(let message) {
            print(message)
            amountText.text = ""
            quantityText.text = ""
            return
        }
        catch {
            print("Unknown Error!")
            exit(10)
        }
        q = Double(quantityText.text!)!
        let coin: String = currString[coinPicker.selectedRow(inComponent: 0)]
        let value: Double = currencies[coin]!
        let newV: Double = Double(self.quantityText.text!)! * value
        c = coin
        amountText.text = String(format: "$%.02f", newV)
        change = true
    }
    
    //this checks if the quantity being input is null (nothing)
    func checkValidQuantity() throws {
        if Double(self.quantityText.text!) == nil {
            throw InputError.NotANumberError("Error: This is not a valid quantity!")
        }
    }
    //this checks if the amount input is null
    func checkValidAmount() throws {
        if Double(self.amountText.text!) == nil {
            throw InputError.NotANumberError("Error: This is not a valid amount!")
        }
    }
    
    
    //this code saves the data inputted in the Amount text field into Holdings in the main view controller.
    @IBAction func saveButton(_ sender: UIButton) {
        if q == 0 {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            return
        }
        
        //this commands the inputted amount to be added into holdings
        if bar.selectedSegmentIndex == 0 {
            holdings[c]! += q
        }
        else {
        //this checks if the holding amounts is less than the amount subtraction. if so, sets holdings to 0 instead.
            if q >= holdings[c]! {
                holdings[c]! = 0
            }
        //this commands the inputted amount to subtract the holdings amount
            else {
                holdings[c]! -= q
            }
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
    
    //loads the transaction view
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
   
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TransactionViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        amountText.keyboardType = UIKeyboardType.decimalPad
        quantityText.keyboardType = UIKeyboardType.decimalPad
        coinPicker.delegate = self
        coinPicker.dataSource = self
        coinPicker.layer.cornerRadius = 5
        saveButtonOutlet.layer.cornerRadius = 5
    }
}

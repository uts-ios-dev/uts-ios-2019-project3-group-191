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
    
    @IBAction func saveButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    let coins = ["Bitcoin","Ethereum","Litecoin"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coins.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coins[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        coinPicker.delegate = self
        coinPicker.dataSource = self
        coinPicker.layer.cornerRadius = 5
        saveButtonOutlet.layer.cornerRadius = 5
    }

}

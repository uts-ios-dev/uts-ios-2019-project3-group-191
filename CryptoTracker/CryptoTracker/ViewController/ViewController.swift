//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Alexander Schüßling on 16.05.19.
//  Copyright © 2019 UTS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var portfolioView: UIView!
    
    @IBAction func addButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toTransaction", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        portfolioView.layer.cornerRadius = 5
    }
    func updateCurrencies() {
        
    }


}


//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Alexander Schüßling on 16.05.19.
//  Copyright © 2019 UTS. All rights reserved.
//

import UIKit
import CryptoCurrencyKit

let defaults = UserDefaults.standard
var holdings: [String: Double] = [:]
var currencies: [String: Double] = [:]
var currString: [String] = ["bitcoin", "ether", "litecoin"]

//Prices in numeric(not text format)
//var bcPriceNum: Double = 0
//var bcHoldingsNum: Double = 0
//var etherPriceNum: Double = 0
//var etherHoldingsNum: Double = 0
//var lcPriceNum: Double = 0
//var litecoinHoldingsNum: Double = 0

class ViewController: UIViewController {

    @IBOutlet weak var portfolioView: UIView!
    
    @IBOutlet weak var bitCoinPrice: UILabel!
    @IBOutlet weak var bitCoinGainLoss: UILabel!
    @IBOutlet weak var bitCoinHoldings: UILabel!
    @IBOutlet weak var bitCoinValue: UILabel!
    
    @IBOutlet weak var etherPrice: UILabel!
    @IBOutlet weak var etherGainLoss: UILabel!
    @IBOutlet weak var etherHoldings: UILabel!
    @IBOutlet weak var etherValue: UILabel!
    
    @IBOutlet weak var litecoinPrice: UILabel!
    @IBOutlet weak var liteCoinGainLoss: UILabel!
    @IBOutlet weak var litecoinHoldings: UILabel!
    @IBOutlet weak var litecoinValue: UILabel!
    
    @IBOutlet weak var portfolioValue: UILabel!
    
    @IBAction func addButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toTransaction", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.dictionary(forKey: "holdingsKey") != nil {
            holdings = defaults.dictionary(forKey: "holdingsKey") as! [String : Double]
        } else {
            setupHoldingDic()
        }
        if defaults.dictionary(forKey: "currencies") != nil {
            currencies = defaults.dictionary(forKey: "currencies") as! [String : Double]
        } else {
            setupCurrencyDic()
        }
//        holdings["bitcoin"] = 0.1
//        holdings["ether"] = 1.0
//        holdings["litecoin"] = 0.0
//        defaults.set(holdings, forKey: "holdingsKey")
        let currenciesOld = currencies
        setupView()
        updateCurrencies()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.updatePortolio()
            self.updateGainsLosses(currenciesOld)
        })
    }
    
    func setupHoldingDic() {
        for c in currString {
            holdings[c] = 0.0
        }
    }
    func setupCurrencyDic() {
        for c in currString {
            print(c)
            currencies[c] = 0.0
        }
    }
    
    func setupView() {
        portfolioView.layer.cornerRadius = 5
        
        bitCoinPrice.text = String(format: "$%.02f", currencies["bitcoin"]!)
        etherPrice.text = String(format: "$%.02f", currencies["ether"]!)
        litecoinPrice.text = String(format: "$%.02f", currencies["litecoin"]!)
        
        bitCoinHoldings.text = String(format: "%.02f", holdings["bitcoin"]!)
        etherHoldings.text = String(format: "%.02f", holdings["ether"]!)
        litecoinHoldings.text = String(format: "%.02f", holdings["litecoin"]!)
    }
    
    func updateCurrencies() {
        //Bitcoin
        CryptoCurrencyKit.fetchTicker(coinName: "BitCoin", convert: .usd) { r in
            switch r {
            case .success(let bitCoin):
                currencies.updateValue(bitCoin.priceUSD!, forKey:"bitcoin")
                self.bitCoinPrice.text = String(format: "$%.02f", currencies["bitcoin"]!)
                self.bitCoinValue.text = String(format: "$%.02f", (holdings["bitcoin"]! * currencies["bitcoin"]!))
            case .failure(let error):
                print(error)
            }
        }
        //Ether
        CryptoCurrencyKit.fetchTicker(coinName: "Ethereum", convert: .usd) { r in
            switch r {
            case .success(let ether):
                currencies.updateValue(ether.priceUSD!, forKey:"ether")
                self.etherPrice.text = String(format: "$%.02f", currencies["ether"]!)
                self.etherValue.text = String(format: "$%.02f", (holdings["ether"]! * currencies["ether"]!))
            case .failure(let error):
                print(error)
            }
        }
        //Litecoin
        CryptoCurrencyKit.fetchTicker(coinName: "Litecoin", convert: .usd) { r in
            switch r {
            case .success(let litecoin):
                currencies.updateValue(litecoin.priceUSD!, forKey:"litecoin")
                self.litecoinPrice.text = String(format: "$%.02f", currencies["litecoin"]!)
                self.litecoinValue.text = String(format: "$%.02f", (holdings["litecoin"]! * currencies["litecoin"]!))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updatePortolio() {
        //update Portfolio
        var portfolioTemp: Double = 0.0
        for c in currString {
            portfolioTemp += (holdings[c]! * currencies[c]!)
        }
        self.portfolioValue.text = String(format: "$%.02f", portfolioTemp)
        defaults.set(currencies, forKey: "currencies")
    }
    
    func updateGainsLosses(_ currOld: [String:Double]) {
        //caculating Gains/losses compared to last update
        let bitcoinGaintemp = currOld["bitcoin"]! - currencies["bitcoin"]!
        self.bitCoinGainLoss.text = String(format: "%.02f", (bitcoinGaintemp / currOld["bitcoin"]!) * 100.0) + "%"
        if bitcoinGaintemp >= 0 {
            self.bitCoinGainLoss.textColor = UIColor.green
        }
        else {
            self.bitCoinGainLoss.textColor = UIColor.red
        }
    }


}


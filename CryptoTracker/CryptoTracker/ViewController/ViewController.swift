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
var currString: [String] = ["BitCoin", "Ethereum", "Litecoin", "Ripple","EOS"]

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
    @IBOutlet weak var litecoinGainLoss: UILabel!
    @IBOutlet weak var litecoinHoldings: UILabel!
    @IBOutlet weak var litecoinValue: UILabel!
    
    @IBOutlet weak var xrpPrice: UILabel!
    @IBOutlet weak var xrpGainLoss: UILabel!
    @IBOutlet weak var xrpHoldings: UILabel!
    @IBOutlet weak var xrpValue: UILabel!
    
    @IBOutlet weak var eosPrice: UILabel!
    @IBOutlet weak var eosGainLoss: UILabel!
    @IBOutlet weak var eosHoldings: UILabel!
    @IBOutlet weak var eosValue: UILabel!
    
    var labels: [String: [UILabel]] = [:]
    
    @IBOutlet weak var portfolioValue: UILabel!
    
    @IBAction func addButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toTransaction", sender: self)
    }
    
    
    @IBAction func refreshButton(_ sender: UIButton) {
        let currenciesOld = currencies
        updateCurrencies()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.updatePortolio()
            self.updateGainsLosses(currenciesOld)
        })
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
        let bitcoinLabels: [UILabel] = [bitCoinPrice, bitCoinGainLoss, bitCoinHoldings, bitCoinValue]
        let etherLabels: [UILabel] = [etherPrice, etherGainLoss, etherHoldings, etherValue]
        let litecoinLabels: [UILabel] = [litecoinPrice, litecoinGainLoss, litecoinHoldings, litecoinValue]
        let xrpLabels: [UILabel] = [xrpPrice, xrpGainLoss, xrpHoldings, xrpValue]
        let eosLabels: [UILabel] = [eosPrice, eosGainLoss, eosHoldings, eosValue]
        labels["BitCoin"] = bitcoinLabels
        labels["Ethereum"] = etherLabels
        labels["Litecoin"] = litecoinLabels
        labels["Ripple"] = xrpLabels
        labels["EOS"] = eosLabels
    }
    
    func setupHoldingDic() {
        for c in currString {
            holdings[c] = 0.0
        }
    }
    func setupCurrencyDic() {
        for c in currString {
            currencies[c] = 0.0
        }
    }
    
    func setupView() {
        portfolioView.layer.cornerRadius = 5

        for c in currString {
            self.labels[c]![0].text = String(format: "$%.02f", currencies[c]!)
            self.labels[c]![2].text = String(format: "%.02f", holdings[c]!)
        }
    }
    
    func updateCurrencies() {
        for c in currString {
            CryptoCurrencyKit.fetchTicker(coinName: c, convert: .usd) { r in
                switch r {
                case .success(let coin):
                    currencies.updateValue(coin.priceUSD!, forKey: c)
                    self.labels[c]![0].text = String(format: "$%.02f", currencies[c]!)
                    self.labels[c]![3].text = String(format: "$%.02f", (holdings[c]! * currencies[c]!))
                case .failure(let error):
                    print(error)
                }
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
        for c in currString {
            if (currOld[c] == 0.0) {
                self.labels[c]![1].text = String(format: "%.02f", 0.0) + "%"
                self.labels[c]![1].textColor = UIColor.green
                continue
            }
            let temp = currOld[c]! - currencies[c]!
            self.labels[c]![1].text = String(format: "%.02f", (temp / currOld[c]!) * 100.0) + "%"
            if temp >= 0 {
                self.labels[c]![1].textColor = UIColor.green
            }
            else {
                self.labels[c]![1].textColor = UIColor.red
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //        holdings["BitCoin"] = 0.1
        //        holdings["Ethereum"] = 1.0
        //        holdings["Litecoin"] = 0.0
        defaults.set(holdings, forKey: "holdingsKey")
        let currenciesOld = currencies
        setupView()
        updateCurrencies()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.updatePortolio()
            self.updateGainsLosses(currenciesOld)
        })
    }


}


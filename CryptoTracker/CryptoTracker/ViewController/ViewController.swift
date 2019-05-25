//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Alexander Schüßling on 16.05.19.
//  Copyright © 2019 UTS. All rights reserved.
//

import UIKit
import CryptoCurrencyKit

//Prices in numeric(not text format)
var bcPriceNum: Double = 0
var bcHoldingsNum: Double = 0
var etherPriceNum: Double = 0
var etherHoldingsNum: Double = 0
var lcPriceNum: Double = 0
var litecoinHoldingsNum: Double = 0

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
        portfolioView.layer.cornerRadius = 5
        updateCurrencies()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.updatePortolio()
        })
    }
    
    func updateCurrencies() {
        //Bitcoin
        CryptoCurrencyKit.fetchTicker(coinName: "BitCoin", convert: .usd) { r in
            switch r {
            case .success(let bitCoin):
                bcPriceNum = bitCoin.priceUSD!
                self.bitCoinPrice.text = String(format: "$%.02f", bcPriceNum)
                bcHoldingsNum = bcPriceNum * (Double(self.bitCoinHoldings.text!)!)
                print(bcHoldingsNum)
                self.bitCoinValue.text = String(format: "$%.02f", bcHoldingsNum)
            case .failure(let error):
                print(error)
            }
        }
        //Ether
        CryptoCurrencyKit.fetchTicker(coinName: "Ethereum", convert: .usd) { r in
            switch r {
            case .success(let ether):
                etherPriceNum = ether.priceUSD!
                self.etherPrice.text = String(format: "$%.02f", etherPriceNum)
                etherHoldingsNum = etherPriceNum * (Double(self.etherHoldings.text!)!)
                self.bitCoinValue.text = String(format: "$%.02f", etherHoldingsNum)
            case .failure(let error):
                print(error)
            }
        }
        //Litecoin
        CryptoCurrencyKit.fetchTicker(coinName: "Litecoin", convert: .usd) { r in
            switch r {
            case .success(let litecoin):
                lcPriceNum = litecoin.priceUSD!
                self.litecoinPrice.text = String(format: "$%.02f", lcPriceNum)
                litecoinHoldingsNum = lcPriceNum * (Double(self.litecoinHoldings.text!)!)
                self.litecoinValue.text = String(format: "$%.02f", litecoinHoldingsNum)
            case .failure(let error):
                print(error)
            }
        }
    }
    func updatePortolio() {
        //update Portfolio
        let portfolioTemp = bcHoldingsNum + etherHoldingsNum + litecoinHoldingsNum
        print(portfolioTemp)
        self.portfolioValue.text = String(format: "$%.02f", portfolioTemp)
    }


}


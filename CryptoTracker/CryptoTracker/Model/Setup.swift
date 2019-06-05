//
//  Setup.swift
//  CryptoTracker
//
//  Created by Alexander Schüßling on 05.06.19.
//  Copyright © 2019 UTS. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard
var holdings: [String: Double] = [:]
var currencies: [String: Double] = [:]
var currString: [String] = ["BitCoin", "Ethereum", "Litecoin", "Ripple","EOS"]

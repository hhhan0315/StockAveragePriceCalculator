//
//  ViewController.swift
//  StockAveragePriceCalculator
//
//  Created by 한승래 on 2021/03/05.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var finalPriceField: UITextField!
    @IBOutlet weak var finalAmountField: UITextField!
    @IBOutlet weak var finalTotalPriceField: UITextField!
    
    @IBOutlet weak var currentPriceField: UITextField!
    @IBOutlet weak var currentAmountField: UITextField!
    @IBOutlet weak var currentTotalPriceField: UITextField!
    
    @IBOutlet weak var addPriceField: UITextField!
    @IBOutlet weak var addAmountField: UITextField!    
    @IBOutlet weak var addTotalPriceField: UITextField!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        
        currentPriceField.addTarget(self, action: #selector(currentPriceEdit(_:)), for: .editingChanged)
        currentAmountField.addTarget(self, action: #selector(currentAmountEdit(_:)), for: .editingChanged)
        addPriceField.addTarget(self, action: #selector(addPriceEdit(_:)), for: .editingChanged)
        addAmountField.addTarget(self, action: #selector(addAmountEdit(_:)), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setDelegate() {
        //        finalPriceField.delegate = self
        //        finalAmountField.delegate = self
        currentPriceField.delegate = self
        currentAmountField.delegate = self
        addPriceField.delegate = self
        addAmountField.delegate = self
    }
    
    // 각각 필드마다 다 따로따로 해주면서 userDefaults에 저장해주자.
    
    @objc func currentPriceEdit(_ sender: UITextField) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let commaRemovedPrice = currentPriceField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let price = Int(commaRemovedPrice) else {
            userDefaults.set(0, forKey: "currentPrice")
            currentTotalPriceField.text = .none
            return
        }
        
        userDefaults.set(price, forKey: "currentPrice")
        
        let currentPrice = userDefaults.integer(forKey: "currentPrice")
        let currentAmount = userDefaults.integer(forKey: "currentAmount")
//        let addPrice = userDefaults.integer(forKey: "addPrice")
//        let addAmount = userDefaults.integer(forKey: "addAmount")
        
        if currentAmount == 0 {
            currentTotalPriceField.text = .none
        } else {
            let formatString = numberFormatter.string(from: NSNumber(value: currentPrice*currentAmount))
            currentTotalPriceField.text = formatString
        }
//        finalPriceField.text = String(currentPrice+addPrice)
//        finalAmountField.text = String(currentAmount+addAmount)
    }
    
    @objc func currentAmountEdit(_ sender: UITextField) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let commaRemovedAmount = currentAmountField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let amount = Int(commaRemovedAmount) else {
            userDefaults.set(0, forKey: "currentAmount")
            currentTotalPriceField.text = .none
            return
        }
        
        userDefaults.set(amount, forKey: "currentAmount")
        
        let currentPrice = userDefaults.integer(forKey: "currentPrice")
        let currentAmount = userDefaults.integer(forKey: "currentAmount")
//        let addPrice = userDefaults.integer(forKey: "addPrice")
//        let addAmount = userDefaults.integer(forKey: "addAmount")
        
        if currentPrice == 0 {
            currentTotalPriceField.text = .none
        } else {
            let formatString = numberFormatter.string(from: NSNumber(value: currentPrice*currentAmount))
            currentTotalPriceField.text = formatString
        }
        
//        finalAmountField.text = String(currentAmount+addAmount)
    }
    
    @objc func addPriceEdit(_ sender: UITextField) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let commaRemovedPrice = addPriceField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let price = Int(commaRemovedPrice) else {
            userDefaults.set(0, forKey: "addPrice")
            addTotalPriceField.text = .none
            return
        }
        
        userDefaults.set(price, forKey: "addPrice")
        
        let currentPrice = userDefaults.integer(forKey: "currentPrice")
        let currentAmount = userDefaults.integer(forKey: "currentAmount")
        let addPrice = userDefaults.integer(forKey: "addPrice")
        let addAmount = userDefaults.integer(forKey: "addAmount")
        
        if addAmount == 0 {
            addTotalPriceField.text = .none
        } else {
            let formatString = numberFormatter.string(from: NSNumber(value: addPrice * addAmount))
            addTotalPriceField.text = formatString
        }
        
//        finalAmountField.text = String(currentAmount+addAmount)
    }
    
    @objc func addAmountEdit(_ sender: UITextField) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let commaRemovedAmount = addAmountField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let amount = Int(commaRemovedAmount) else {
            userDefaults.set(0, forKey: "addAmount")
            addTotalPriceField.text = .none
            return
        }
        
        userDefaults.set(amount, forKey: "addAmount")
        
        let currentPrice = userDefaults.integer(forKey: "currentPrice")
        let currentAmount = userDefaults.integer(forKey: "currentAmount")
        let addPrice = userDefaults.integer(forKey: "addPrice")
        let addAmount = userDefaults.integer(forKey: "addAmount")
        
        if addPrice == 0 {
            addTotalPriceField.text = .none
        } else {
            let formatString = numberFormatter.string(from: NSNumber(value: addPrice * addAmount))
            addTotalPriceField.text = formatString
        }
        
//        finalAmountField.text = String(currentAmount+addAmount)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let commaRemovedText = textField.text?.replacingOccurrences(of: ",", with: "") else {
            return false
        }
        
        var combinedText = commaRemovedText + string
        
        // backspace 입력받았을 때
        if string.isEmpty {
            // 마지막 하나만 남았을 경우
            if combinedText.count == 1 {
                textField.text = .none
                textField.sendActions(for: .editingChanged)
                return false
            }
            
            let lastIndex = combinedText.index(combinedText.endIndex, offsetBy: -1)
            combinedText = String(combinedText[..<lastIndex])
        }
        
        guard let formatNumber = numberFormatter.number(from: combinedText) else {
            return false
        }
        
        let formatString = numberFormatter.string(from: formatNumber)
        textField.text = formatString
        textField.sendActions(for: .editingChanged)
        return false
    }
}

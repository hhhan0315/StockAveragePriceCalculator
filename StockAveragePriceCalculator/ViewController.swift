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
        userDefaultsClear()
        
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
    
    func userDefaultsClear() {
        userDefaults.set(0, forKey: "currentPrice")
        userDefaults.set(0, forKey: "currentAmount")
        userDefaults.set(0, forKey: "addPrice")
        userDefaults.set(0, forKey: "addAmount")
    }
    
    @objc func currentPriceEdit(_ sender: UITextField) {
        guard let commaRemovedPrice = currentPriceField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let currentPrice = Int(commaRemovedPrice) else {
            userDefaults.set(0, forKey: "currentPrice")
            currentTotalPriceField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(currentPrice, forKey: "currentPrice")
        
        checkCurrentField()
        checkFinalField()
    }
    
    @objc func currentAmountEdit(_ sender: UITextField) {
        guard let commaRemovedAmount = currentAmountField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let currentAmount = Int(commaRemovedAmount) else {
            userDefaults.set(0, forKey: "currentAmount")
            currentTotalPriceField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(currentAmount, forKey: "currentAmount")
        
        checkCurrentField()
        checkFinalField()
    }
    
    @objc func addPriceEdit(_ sender: UITextField) {
        guard let commaRemovedPrice = addPriceField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let addPrice = Int(commaRemovedPrice) else {
            userDefaults.set(0, forKey: "addPrice")
            addTotalPriceField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(addPrice, forKey: "addPrice")

        checkAddField()
        checkFinalField()
    }
    
    @objc func addAmountEdit(_ sender: UITextField) {
        guard let commaRemovedAmount = addAmountField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let addAmount = Int(commaRemovedAmount) else {
            userDefaults.set(0, forKey: "addAmount")
            addTotalPriceField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(addAmount, forKey: "addAmount")
        
        checkAddField()
        checkFinalField()
    }
    
    func makeCommaString(num: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formatString = numberFormatter.string(from: NSNumber(value: num))
        return formatString
    }
    
    func checkCurrentField() {
        let currentPrice = userDefaults.integer(forKey: "currentPrice")
        let currentAmount = userDefaults.integer(forKey: "currentAmount")
        
        if currentPrice == 0 || currentAmount == 0 {
            currentTotalPriceField.text = .none
        } else {
            currentTotalPriceField.text = makeCommaString(num: currentPrice * currentAmount)
        }
    }
    
    func checkAddField() {
        let addPrice = userDefaults.integer(forKey: "addPrice")
        let addAmount = userDefaults.integer(forKey: "addAmount")
        
        if addPrice == 0 || addAmount == 0 {
            addTotalPriceField.text = .none
        } else {
            addTotalPriceField.text = makeCommaString(num: addPrice * addAmount)
        }
    }
    
    func checkFinalField() {
        let currentPrice = userDefaults.integer(forKey: "currentPrice")
        let currentAmount = userDefaults.integer(forKey: "currentAmount")
        let addPrice = userDefaults.integer(forKey: "addPrice")
        let addAmount = userDefaults.integer(forKey: "addAmount")
        
        if currentAmount == 0 || addAmount == 0 {
            finalAmountField.text = .none
        } else {
            finalAmountField.text = makeCommaString(num: currentAmount + addAmount)
        }
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

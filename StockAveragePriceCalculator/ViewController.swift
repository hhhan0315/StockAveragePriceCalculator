//
//  ViewController.swift
//  StockAveragePriceCalculator
//
//  Created by 한승래 on 2021/03/05.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentPriceField: UITextField!
    @IBOutlet weak var currentAmountField: UITextField!
    @IBOutlet weak var addPriceField: UITextField!
    @IBOutlet weak var addAmountField: UITextField!
    
    @IBOutlet weak var currentTotalPriceField: UITextField!
    @IBOutlet weak var addTotalPriceField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        
        currentPriceField.addTarget(self, action: #selector(currentTotalPriceEdit(_:)), for: .editingChanged)
        currentAmountField.addTarget(self, action: #selector(currentTotalPriceEdit(_:)), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setDelegate() {
        currentPriceField.delegate = self
        currentAmountField.delegate = self
        addPriceField.delegate = self
        addAmountField.delegate = self
    }
    
    @objc func currentTotalPriceEdit(_ sender: UITextField) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let currentPrice = currentPriceField.text?.replacingOccurrences(of: ",", with: ""),
              let currentAmount = currentAmountField.text?.replacingOccurrences(of: ",", with: "") else {
            return
        }
        
        guard let price = Int(currentPrice), let amount = Int(currentAmount) else {
            return
        }
        
        let formatString = numberFormatter.string(from: NSNumber(value: price*amount))
        currentTotalPriceField.text = formatString
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if let commaRemovedText = textField.text?.replacingOccurrences(of: ",", with: "")  {
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
        
        return true
    }
}

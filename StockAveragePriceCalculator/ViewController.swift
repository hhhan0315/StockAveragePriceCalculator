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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
    }
    
    func setDelegate() {
        currentPriceField.delegate = self
        currentAmountField.delegate = self
        addPriceField.delegate = self
        addAmountField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if let commaRemovedText = textField.text?.components(separatedBy: [","]).joined()  {
            var combinedText = commaRemovedText + string
            
            // backspace 입력받았을 때
            if string.isEmpty {
                // 마지막 하나만 남았을 경우
                if combinedText.count == 1 {
                    textField.text = .none
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
            return false
        }
        
        return true
    }
}

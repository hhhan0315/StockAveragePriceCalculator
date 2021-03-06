//
//  ViewController.swift
//  StockAveragePriceCalculator
//
//  Created by νμΉλ on 2021/03/05.
//

import UIKit

class ViewController: UIViewController {
        
    @IBOutlet weak var finalPriceField: UITextField!
    @IBOutlet weak var finalAmountField: UITextField!
    @IBOutlet weak var finalTotalPriceField: UITextField!
    @IBOutlet weak var finalPercentField: UITextField!
    
    @IBOutlet weak var currentPriceField: UITextField!
    @IBOutlet weak var currentAmountField: UITextField!
    @IBOutlet weak var currentTotalPriceField: UITextField!
    @IBOutlet weak var currentPercentField: UITextField!
    
    @IBOutlet weak var addPriceField: UITextField!
    @IBOutlet weak var addAmountField: UITextField!
    @IBOutlet weak var addTotalPriceField: UITextField!
    
    private var inputTextFields = [UITextField]()
    private var allTextFields = [UITextField]()
    
    private let userDefaults = UserDefaults.standard
    private let maxFractionDigits = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setTextField()
        userDefaultsClear()
        
        currentPriceField.addTarget(self, action: #selector(currentPriceEdit), for: .editingChanged)
        currentAmountField.addTarget(self, action: #selector(currentAmountEdit), for: .editingChanged)
        addPriceField.addTarget(self, action: #selector(addPriceEdit), for: .editingChanged)
        addAmountField.addTarget(self, action: #selector(addAmountEdit), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setTextField() {
        inputTextFields = [currentPriceField, currentAmountField, addPriceField, addAmountField]
        allTextFields = [finalPriceField, finalAmountField, finalTotalPriceField, finalPercentField, currentPriceField, currentAmountField, currentTotalPriceField, currentPercentField, addPriceField, addAmountField, addTotalPriceField]
        
        for textField in inputTextFields { // textField νλλ¦¬κ° λλ¬΄ μμ΄μ μ΄μ§ μ§νκ² λ§λ€μλ€.
            textField.delegate = self
            textField.layer.borderWidth = 0.7
            textField.layer.borderColor = UIColor.darkGray.cgColor
            textField.layer.cornerRadius = 5
        }
        
        for textField in allTextFields { // placeholder λ μμ΄ μμ΄μ λ³κ²½
            guard let placeholderText = textField.placeholder else {
                return
            }
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        }
        
        guard let finalPlaceholder = finalPriceField.placeholder else {
            return
        }
        finalPriceField.attributedPlaceholder = NSAttributedString(string: finalPlaceholder, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.systemIndigo])
        
        currentPriceField.tag = 2
        currentAmountField.tag = 3
        addPriceField.tag = 4
        addAmountField.tag = 5
        
        currentPriceField.addButton()
        currentAmountField.addButton()
        addPriceField.addButton()
        addAmountField.addButton()
    }
    
    func userDefaultsClear() {
        userDefaults.set(0, forKey: "currentPrice")
        userDefaults.set(0, forKey: "currentAmount")
        userDefaults.set(0, forKey: "addPrice")
        userDefaults.set(0, forKey: "addAmount")
        userDefaults.set(0, forKey: "currentSum")
        userDefaults.set(0, forKey: "addSum")
    }
    
    func makeCommaString(num: Double) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = maxFractionDigits
        let formatString = numberFormatter.string(from: NSNumber(value: num))
        return formatString
    }
    
    @objc func currentPriceEdit() {
        guard let commaRemovedPrice = currentPriceField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let currentPrice = Double(commaRemovedPrice) else {
            userDefaults.set(0, forKey: "currentPrice")
            currentTotalPriceField.text = .none
            currentPercentField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(currentPrice, forKey: "currentPrice")
        
        checkCurrentTotalField()
        checkCurrentPercentField()
        checkFinalField()
    }
    
    @objc func currentAmountEdit() {
        guard let commaRemovedAmount = currentAmountField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let currentAmount = Double(commaRemovedAmount) else {
            userDefaults.set(0, forKey: "currentAmount")
            currentTotalPriceField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(currentAmount, forKey: "currentAmount")
        
        checkCurrentTotalField()
        checkFinalField()
    }
    
    @objc func addPriceEdit() {
        guard let commaRemovedPrice = addPriceField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let addPrice = Double(commaRemovedPrice) else {
            userDefaults.set(0, forKey: "addPrice")
            addTotalPriceField.text = .none
            currentPercentField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(addPrice, forKey: "addPrice")
        
        checkAddTotalField()
        checkCurrentPercentField()
        checkFinalField()
    }
    
    @objc func addAmountEdit() {
        guard let commaRemovedAmount = addAmountField.text?.replacingOccurrences(of: ",", with: "") else { return }
        
        guard let addAmount = Double(commaRemovedAmount) else {
            userDefaults.set(0, forKey: "addAmount")
            addTotalPriceField.text = .none
            checkFinalField()
            return
        }
        
        userDefaults.set(addAmount, forKey: "addAmount")
        
        checkAddTotalField()
        checkFinalField()
    }
    
    func checkCurrentTotalField() {
        let currentPrice = userDefaults.double(forKey: "currentPrice")
        let currentAmount = userDefaults.double(forKey: "currentAmount")
        
        if currentPrice == 0 || currentAmount == 0 {
            currentTotalPriceField.text = .none
        } else {
            let currentSum = currentPrice * currentAmount
            userDefaults.set(currentSum, forKey: "currentSum")
            currentTotalPriceField.text = makeCommaString(num: currentSum)
        }
    }
    
    func checkAddTotalField() {
        let addPrice = userDefaults.double(forKey: "addPrice")
        let addAmount = userDefaults.double(forKey: "addAmount")
        
        if addPrice == 0 || addAmount == 0 {
            addTotalPriceField.text = .none
        } else {
            let addSum = addPrice * addAmount
            userDefaults.set(addSum, forKey: "addSum")
            addTotalPriceField.text = makeCommaString(num: addSum)
        }
    }
    
    func checkFinalField() {
        let currentPrice = userDefaults.double(forKey: "currentPrice")
        let currentAmount = userDefaults.double(forKey: "currentAmount")
        let addPrice = userDefaults.double(forKey: "addPrice")
        let addAmount = userDefaults.double(forKey: "addAmount")
        
        if currentPrice == 0 || addPrice == 0 || currentAmount == 0 || addAmount == 0 {
            finalPriceField.text = .none
            finalAmountField.text = .none
            finalTotalPriceField.text = .none
            finalPercentField.text = .none
        } else {
            let currentSum = userDefaults.double(forKey: "currentSum")
            let addSum = userDefaults.double(forKey: "addSum")
            let average = (currentSum + addSum) / (currentAmount + addAmount)
            let percent = ((addPrice / average) - 1) * 100
            finalTotalPriceField.text = makeCommaString(num: currentSum + addSum)
            finalAmountField.text = makeCommaString(num: currentAmount + addAmount)
            finalPriceField.text = makeCommaString(num: average)
            finalPercentField.text = makeCommaString(num: percent)
        }
    }
    
    func checkCurrentPercentField() {
        let currentPrice = userDefaults.double(forKey: "currentPrice")
        let addPrice = userDefaults.double(forKey: "addPrice")
        
        if currentPrice == 0 || addPrice == 0 {
            currentPercentField.text = .none
        } else {
            let percent = ((addPrice / currentPrice) - 1) * 100
            currentPercentField.text = makeCommaString(num: percent)
        }
    }
    
    @IBAction func touchClearButton(_ sender: UIBarButtonItem) {
        self.userDefaultsClear()
        finalPriceField.text = .none
        finalAmountField.text = .none
        finalTotalPriceField.text = .none
        finalPercentField.text = .none
        currentPriceField.text = .none
        currentAmountField.text = .none
        currentTotalPriceField.text = .none
        currentPercentField.text = .none
        addPriceField.text = .none
        addAmountField.text = .none
        addTotalPriceField.text = .none
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = maxFractionDigits
        
        guard let commaRemovedText = textField.text?.replacingOccurrences(of: ",", with: "") else {
            return false
        }
        
        var commaAfterCount = 0
        var commaSplitArray = [String]()
        var combinedText = commaRemovedText + string
        
        if combinedText.contains(".") {
            commaSplitArray = combinedText.components(separatedBy: ".")
            combinedText = commaSplitArray[0]
            commaAfterCount = commaSplitArray[1].count
        }
        
        // backspace μλ ₯
        if string.isEmpty || combinedText.count > (10 + commaAfterCount) || commaAfterCount > maxFractionDigits {
            // μμμ  μ΄νμ μ«μκ° μμ κ²½μ°
            if commaAfterCount > 0 {
                commaSplitArray[1].removeLast()
            } else {
                if combinedText.count == 1 {
                    textField.text = .none
                    textField.sendActions(for: .editingChanged)
                    return false
                }
                
                // μμμ  μ΄νμλ μ«μκ° μμ§λ§ . λ§ μμ κ²½μ°
                if commaSplitArray.count == 2 {
                    combinedText += "."
                    commaSplitArray.removeLast()
                }
                
                let lastIndex = combinedText.index(combinedText.endIndex, offsetBy: -1)
                combinedText = String(combinedText[..<lastIndex])
            }
        }
        
        guard let formatNumber = numberFormatter.number(from: combinedText) else {
            return false
        }
        
        guard var formatString = numberFormatter.string(from: formatNumber) else {
            return false
        }
        
        if commaSplitArray.count == 2 {
            formatString += ".\(commaSplitArray[1])"
        }

        textField.text = formatString
        textField.sendActions(for: .editingChanged)
        return false
    }
}

extension UITextField {
    
    func addButton() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        let up = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: #selector(goToPrevField))
        let down = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(goToNextField))
        
        toolbar.items = [up, down]
        self.inputAccessoryView = toolbar
    }
    
    @objc func goToPrevField() {
        let prevFieldTag = self.tag - 1
        if let prevField = self.superview?.superview?.viewWithTag(prevFieldTag)  {
            prevField.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
    }
    
    @objc func goToNextField() {
        let nextFieldTag = self.tag + 1
        if let nextField = self.superview?.superview?.viewWithTag(nextFieldTag) {
            nextField.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
    }
}

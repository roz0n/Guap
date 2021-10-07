//
//  CurrencyTextView.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class CurrencyTextView: UITextView {
  
  // MARK: - Properties
  
  var keyboardToolbar: UIToolbar? = nil
  var keyboardDoneButton: UIBarButtonItem? = nil
  var keyboardDoneCallback: (() -> Void)?
  
  // MARK: - Initializers
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    
    configureTextView()
    configureKeyboard()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  private func configureTextView() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 12
    backgroundColor = .systemGray6
    keyboardType = .decimalPad
    font = UIFont.monospacedSystemFont(ofSize: 24, weight: .bold)
  }
  
  private func configureKeyboard() {
    keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 35))
    keyboardDoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(tappedDoneButton))
    
    guard let keyboardToolbar = keyboardToolbar, let keyboardDoneButton = keyboardDoneButton else {
      return
    }
    
    keyboardToolbar.barStyle = .default
    keyboardToolbar.sizeToFit()
    keyboardToolbar.items = [keyboardDoneButton]
    keyboardToolbar.isUserInteractionEnabled = true
    
    inputAccessoryView = keyboardToolbar
  }
  
  // MARK: - Selectors
  
  @objc func tappedDoneButton() {
    endEditing(true)
    
    if let keyboardDoneCallback = keyboardDoneCallback {
      keyboardDoneCallback()
    }
  }
  
}

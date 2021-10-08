//
//  ConverterTextView.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class ConverterTextView: UITextField {
  
  // MARK: - Properties
  
  var keyboardToolbar: UIToolbar? = nil
  var keyboardDoneButton: UIBarButtonItem? = nil
  var keyboardDoneCallback: (() -> Void)?
  
  // MARK: - Initializers
  
//  override init(frame: CGRect, textContainer: NSTextContainer?) {
//    super.init(frame: frame, textContainer: textContainer)
//
//  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    configureTextView()
    configureKeyboard()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  private func configureTextView() {
    font = UIFont.monospacedSystemFont(ofSize: K.Sizes.xlText, weight: .bold)
    keyboardType = .decimalPad
    layer.cornerRadius = K.Sizes.mdRadius
    backgroundColor = .systemGray5
  }
  
  private func configureKeyboard() {
    keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: K.Sizes.keyboardToolbarHeight))
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

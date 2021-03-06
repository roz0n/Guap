//
//  ConverterTextField.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class ConverterTextField: UITextField {
  
  // MARK: - Properties
  
  var textFieldType: ConverterTextFields
  
  var keyboardToolbar: UIToolbar? = nil
  var keyboardDoneButton: UIBarButtonItem? = nil
  var keyboardCancelButton: UIBarButtonItem? = nil
  var keyboardDoneCallback: (() -> Void)?
  
  var textFieldLabelText: String {
    didSet {
      textFieldLabel.text = textFieldLabelText
    }
  }
  
  // MARK: -
  
  var textFieldLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK: - Initializers
  
  init(label: String, type: ConverterTextFields) {
    textFieldLabelText = label
    textFieldType = type
    
    super.init(frame: .zero)
    
    configureTextField()
    configureTextFieldLabel()
    configureKeyboard()
    
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  private func configureTextField() {
    translatesAutoresizingMaskIntoConstraints = false
    keyboardType = .decimalPad
    adjustsFontSizeToFitWidth = true
    autocorrectionType = .no
    
    
    setTextFieldAppearance()
  }
  
  private func configureTextFieldLabel() {
    textFieldLabel.text = textFieldLabelText.uppercased()
    textFieldLabel.font = UIFont.systemFont(ofSize: K.Sizes.xsText, weight: .bold)
    textFieldLabel.textColor = .white.withAlphaComponent(0.5)
  }
  
  private func configureKeyboard() {
    keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    keyboardDoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(tappedDoneButton))
    keyboardCancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tappedCancelButton))
    
    guard let toolbar = keyboardToolbar,
          let doneButton = keyboardDoneButton,
          let cancelButton = keyboardCancelButton else {
            return
          }
    
    toolbar.barStyle = .default
    toolbar.sizeToFit()
    toolbar.items = [cancelButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), doneButton]
    toolbar.isUserInteractionEnabled = true
    
    inputAccessoryView = toolbar
  }
  
  // MARK: - Selectors
  
  @objc func tappedDoneButton() {
    endEditing(true)
    
    if let keyboardDoneCallback = keyboardDoneCallback {
      keyboardDoneCallback()
    }
  }
  
  @objc func tappedCancelButton() {
    endEditing(true)
  }
  
  // MARK: - Helpers
  
  func setTextFieldLabel(_ text: String) {
    textFieldLabelText = text.uppercased()
  }
  
  func setTextFieldAppearance() {
    switch textFieldType {
      case .base:
        let placeholderString = NSAttributedString(string: "0.00", attributes: [.foregroundColor: UIColor.white])
        attributedPlaceholder = placeholderString
        
        backgroundColor = .clear
        layer.borderWidth = 4
        layer.borderColor = UIColor.white.cgColor
      case .target:
        placeholder = "0.00"
        backgroundColor = .systemGray5
    }
    
    font = UIFont.monospacedSystemFont(ofSize: K.Sizes.xlText, weight: .bold)
    layer.cornerRadius = K.Sizes.mdRadius
    
    leftView = UIView(frame: CGRect(x: 0, y: 0, width: K.Sizes.lgSpace, height: .leastNonzeroMagnitude))
    rightView = UIView(frame: CGRect(x: 0, y: 0, width: K.Sizes.lgSpace, height: .leastNonzeroMagnitude))
    leftViewMode = .always
    rightViewMode = .always
  }
  
}

// MARK: - Layout

private extension ConverterTextField {
  
  func applyLayouts() {
    layoutTextFieldContainers()
  }
  
  func layoutTextFieldContainers() {
    addSubview(textFieldLabel)
    
    NSLayoutConstraint.activate([
      textFieldLabel.topAnchor.constraint(equalTo: topAnchor, constant: -K.Sizes.lgSpace),
      textFieldLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      textFieldLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
  
}

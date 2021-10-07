//
//  CurrencyTextView.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class CurrencyTextView: UITextView {
  
  // MARK: - Properties
  
  let keyboardToolbar: UIToolbar
  
  // MARK: - Initializers
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    
    self.keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 35))
    super.init(frame: frame, textContainer: textContainer)
    
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 12
    backgroundColor = .systemGray6
    keyboardType = .decimalPad
    font = UIFont.monospacedSystemFont(ofSize: 24, weight: .bold)
    
    keyboardToolbar.barStyle = .default
    keyboardToolbar.sizeToFit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

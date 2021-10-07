//
//  CurrencyButton.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class CurrencyButton: UIButton {
  
  // MARK: - Initializers
  
  init(title: String, titleColor: UIColor, labelColor: UIColor) {
    super.init(frame: .zero)
    
    setTitle(title, for: .normal)
    setTitleColor(titleColor, for: .normal)
    setTitleColor(self.titleColor(for: .normal)?.withAlphaComponent(0.5), for: .highlighted)
    titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .bold)
    
    backgroundColor = labelColor
    layer.cornerRadius = 12
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

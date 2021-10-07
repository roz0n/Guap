//
//  OutputCurrencyLabel.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class OutputCurrencyLabel: UILabel {
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    configureLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  private func configureLabel() {
    font = UIFont.monospacedSystemFont(ofSize: K.Sizes.medText, weight: .bold)
    layer.cornerRadius = K.Sizes.medRadius
    backgroundColor = .clear
  }
  
}

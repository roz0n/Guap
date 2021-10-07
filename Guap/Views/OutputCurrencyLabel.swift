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
    font = UIFont.systemFont(ofSize: K.Sizes.mdText, weight: .bold)
    layer.cornerRadius = K.Sizes.mdRadius
    layer.masksToBounds = true
    // backgroundColor = .clear
    backgroundColor = .systemGray6.withAlphaComponent(0.5)
  }
  
}

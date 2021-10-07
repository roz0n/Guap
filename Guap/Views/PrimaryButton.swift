//
//  PrimaryButton.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class PrimaryButton: UIButton {
  
  // MARK: - Initializers
  
  init(title: String, color: UIColor, background: UIColor) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    
    configureButton(title: title, color: color, background: background)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  private func configureButton(title: String, color: UIColor, background: UIColor) {
    setTitle(title, for: .normal)
    setTitleColor(color, for: .normal)
    setTitleColor(self.titleColor(for: .normal)?.withAlphaComponent(0.5), for: .highlighted)
    titleLabel?.font = UIFont.monospacedSystemFont(ofSize: K.Sizes.smallText, weight: .bold)
    
    backgroundColor = background
    layer.cornerRadius = K.Sizes.medRadius
  }
  
}

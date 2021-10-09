//
//  PrimaryButton.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit
import Veximoji

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
    titleLabel?.font = UIFont.systemFont(ofSize: K.Sizes.mdText, weight: .bold)
    
    backgroundColor = background
    layer.cornerRadius = K.Sizes.mdRadius
  }
  
  // MARK: - Helpers
  
  func setButtonTitle(countryCode: String, currencyCode: String) {
    let spacer = "   "
    // It's safe to force-unwrap here
    setTitle("\(Veximoji.country(code: countryCode) ?? Veximoji.cultural(term: .white)!)\(spacer)\(currencyCode)", for: .normal)
  }
  
}

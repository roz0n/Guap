//
//  CurrencyTableViewCell.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/9/21.
//

import UIKit
import Veximoji

class CurrencyTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  
  static let reuseIdentifier = "currencyTableCell"
  var currencyData: FiatCurrency?
  
  // MARK: -
  
  var flagLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: K.Sizes.lgText, weight: .bold)
    return label
  }()
  
  var codeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: K.Sizes.mdText, weight: .bold)
    label.textColor = .white.withAlphaComponent(0.45)
    label.textAlignment = .center
    return label
  }()
  
  var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: K.Sizes.mdText, weight: .semibold)
    label.numberOfLines = 1
    return label
  }()
  
  // MARK: - Initializers
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  func setLabelText(flag: String, code: String, name: String) {
    flagLabel.text = flag
    codeLabel.text = code
    nameLabel.text = name
  }
  
}

// MARK: - Layout

private extension CurrencyTableViewCell {
  
  func applyLayouts() {
    layoutFlagLabel()
    layoutCodeLabel()
    layoutNameLabel()
  }
  
  func layoutFlagLabel() {
    contentView.addSubview(flagLabel)
    
    NSLayoutConstraint.activate([
      flagLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.Sizes.lgSpace),
      flagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.Sizes.mdSpace),
      flagLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(K.Sizes.lgSpace)),
      flagLabel.widthAnchor.constraint(equalToConstant: 52)
    ])
  }
  
  func layoutCodeLabel() {
    contentView.addSubview(codeLabel)
    
    NSLayoutConstraint.activate([
      codeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.Sizes.lgSpace),
      codeLabel.leadingAnchor.constraint(equalTo: flagLabel.trailingAnchor),
      codeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(K.Sizes.lgSpace)),
      codeLabel.widthAnchor.constraint(equalToConstant: 56)
    ])
  }
  
  func layoutNameLabel() {
    contentView.addSubview(nameLabel)
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.Sizes.lgSpace),
      nameLabel.leadingAnchor.constraint(equalTo: codeLabel.trailingAnchor, constant: K.Sizes.lgSpace),
      nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(K.Sizes.mdSpace)),
      nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(K.Sizes.lgSpace))
    ])
    
  }
  
}

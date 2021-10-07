//
//  ViewController.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  // MARK: - Views
  
  var baseCurrencyButton = CurrencyButton(title: "Base", titleColor: .white, labelColor: .systemGray6)
  var conversionCurrencyButton = CurrencyButton(title: "Conversion", titleColor: .white, labelColor: .systemGray6)
  var currencyTextView = CurrencyTextView()
  
  var currencyToolbarConversion: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = 12
    return stack
  }()
  
  // MARK: - Sizes
  
  let smallSpace: CGFloat = 8
  let medSpace: CGFloat = 12
  let largeSpace: CGFloat = 24
  let toolbarHeight: CGFloat = 72
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGray5
    applyLayouts()
  }
  
}


// MARK: - Layout

fileprivate extension ViewController {
  
  func applyLayouts() {
    layoutToolbarContainer()
    layoutToolbarButtons()
    layoutTextField()
  }
  
  // MARK: - Toolbar
  
  func layoutToolbarContainer() {
    view.addSubview(currencyToolbarConversion)

    NSLayoutConstraint.activate([
      currencyToolbarConversion.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: medSpace),
      currencyToolbarConversion.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: medSpace),
      currencyToolbarConversion.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -medSpace),
      currencyToolbarConversion.heightAnchor.constraint(equalToConstant: toolbarHeight)
    ])
  }
  
  func layoutToolbarButtons() {
    currencyToolbarConversion.addArrangedSubview(baseCurrencyButton)
    currencyToolbarConversion.addArrangedSubview(conversionCurrencyButton)
  }
  
  // MARK: - Text Field
  
  func layoutTextField() {
    view.addSubview(currencyTextView)
    
    NSLayoutConstraint.activate([
      currencyTextView.topAnchor.constraint(equalTo: currencyToolbarConversion.bottomAnchor, constant: medSpace),
      currencyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: medSpace),
      currencyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -medSpace),
      currencyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -largeSpace)
    ])
  }
  
}

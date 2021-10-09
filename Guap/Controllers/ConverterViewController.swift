//
//  ConverterViewController.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit
import Veximoji

class ConverterViewController: UIViewController {
  
  // MARK: - Properties
  
  let dataManager = FiatCurrencyDataManager()
  var currencies: [FiatCurrency]?
  
  var baseCurrencyButton = PrimaryButton(title: "...", color: .white, background: .systemGray6)
  var targetCurrencyButton = PrimaryButton(title: "...", color: .white, background: .systemGray6)
  var convertButton = PrimaryButton(title: K.Labels.convertButton, color: .white, background: .systemGreen)
  
  var baseValueTextView = ConverterTextField(label: "Convert from: ")
  var targetValueTextView = ConverterTextField(label: "Convert to: ")
  
  var baseCurrencyData: FiatCurrency? {
    didSet {
      if let countryCode = baseCurrencyData?.iso31661,
         let currencyCode = baseCurrencyData?.iso4217,
         let currencyName = baseCurrencyData?.currencyName {
        baseCurrencyButton.setButtonTitle(countryCode: countryCode, currencyCode: currencyCode)
        baseValueTextView.setTextFieldLabel("Convert from: \(currencyName)")
      }
    }
  }
  
  var targetCurrencyData: FiatCurrency? {
    didSet {
      if let countryCode = targetCurrencyData?.iso31661,
         let currencyCode = targetCurrencyData?.iso4217,
         let currencyName = targetCurrencyData?.currencyName {
        targetCurrencyButton.setButtonTitle(countryCode: countryCode, currencyCode: currencyCode)
        targetValueTextView.setTextFieldLabel("Convert to: \(currencyName)")
      }
    }
  }
  
  // MARK: -
  
  var toolbarContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = K.Sizes.mdSpace
    return stack
  }()
  
  var textFieldsContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchFiatCurrencies()
    configureViewController()
    configureTargetButton()
    applyLayouts()
    applyGestures()
  }
  
  // MARK: - Configurations
  
  private func configureViewController() {
    view.backgroundColor = .black.withAlphaComponent(0.75)
  }
  
  private func configureTargetButton() {
    targetValueTextView.isUserInteractionEnabled = false
    
  }
  
  // MARK: - Gestures
  
  private func applyGestures() {
    addConvertButtonGesture()
    addCurrencySelectionGestures()
  }
  
  private func addConvertButtonGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedConvertButton))
    convertButton.addGestureRecognizer(tapGesture)
  }
  
  private func addCurrencySelectionGestures() {
    let tapBaseGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBaseButton))
    let tapTargetGesture = UITapGestureRecognizer(target: self, action: #selector(tappedTargetButton))
    
    baseCurrencyButton.addGestureRecognizer(tapBaseGesture)
    targetCurrencyButton.addGestureRecognizer(tapTargetGesture)
  }
  
  // MARK: - Selectors
  
  @objc func tappedConvertButton() {
    print("Convert button tapped")
  }
  
  @objc func tappedBaseButton() {
    present(createCurrencySelector(title: "Select Base Currency", type: .base), animated: true)
  }
  
  @objc func tappedTargetButton() {
    present(createCurrencySelector(title: "Select Target Currency", type: .target), animated: true)
  }
  
  // MARK: - Helpers
  
  private func createCurrencySelector(title: String, type: ConverterParameter) -> UINavigationController {
    let rootViewController = CurrencyTableViewController(selectionHandler: handleCurrencySelection(_:_:), type: type)
    rootViewController.title = title
    
    return UINavigationController(rootViewController: rootViewController)
  }
  
  func handleCurrencySelection(_ data: FiatCurrency?, _ type: ConverterParameter?) {
    guard let type = type else {
      return
    }
    
    switch type {
      case .base:
        baseCurrencyData = data
      case .target:
        targetCurrencyData = data
    }
  }
  
}

// MARK: - UITextViewDelegate

extension ConverterViewController: UITextViewDelegate {
  // TODO: Determine if this is needed
}


// MARK: - Layout

private extension ConverterViewController {
  
  func applyLayouts() {
    layoutToolbarContainer()
    layoutToolbarButtons()
    layoutTextFieldsContainer()
    layoutTextFields()
    layoutConvertButton()
  }
  
  // MARK: - Toolbar
  
  func layoutToolbarContainer() {
    view.addSubview(toolbarContainer)
    
    NSLayoutConstraint.activate([
      toolbarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: K.Sizes.mdSpace),
      toolbarContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: K.Sizes.mdSpace),
      toolbarContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(K.Sizes.mdSpace)),
      toolbarContainer.heightAnchor.constraint(equalToConstant: K.Sizes.primaryToolbarHeight)
    ])
  }
  
  func layoutToolbarButtons() {
    toolbarContainer.addArrangedSubview(baseCurrencyButton)
    toolbarContainer.addArrangedSubview(targetCurrencyButton)
  }
  
  // MARK: - Text Views
  
  func layoutTextFieldsContainer() {
    view.addSubview(textFieldsContainer)
    
    NSLayoutConstraint.activate([
      textFieldsContainer.topAnchor.constraint(equalTo: toolbarContainer.bottomAnchor, constant: (K.Sizes.lgSpace * 2)),
      textFieldsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: K.Sizes.mdSpace),
      textFieldsContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(K.Sizes.mdSpace)),
      textFieldsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(K.Sizes.convertButtonHeight + K.Sizes.lgSpace))
    ])
  }
  
  func layoutTextFields() {
    textFieldsContainer.addSubview(baseValueTextView)
    textFieldsContainer.addSubview(targetValueTextView)
    
    NSLayoutConstraint.activate([
      baseValueTextView.heightAnchor.constraint(equalToConstant: K.Sizes.inputTextViewHeight),
      baseValueTextView.widthAnchor.constraint(equalTo: textFieldsContainer.widthAnchor),
      baseValueTextView.topAnchor.constraint(equalTo: textFieldsContainer.topAnchor),
      
      targetValueTextView.heightAnchor.constraint(equalToConstant: K.Sizes.inputTextViewHeight),
      targetValueTextView.widthAnchor.constraint(equalTo: textFieldsContainer.widthAnchor),
      targetValueTextView.topAnchor.constraint(equalTo: baseValueTextView.bottomAnchor, constant: (K.Sizes.lgSpace * 2)),
    ])
  }
  
  // MARK: - Convert Button
  
  func layoutConvertButton() {
    view.addSubview(convertButton)
    
    NSLayoutConstraint.activate([
      convertButton.heightAnchor.constraint(equalToConstant: K.Sizes.convertButtonHeight),
      convertButton.leadingAnchor.constraint(equalTo: toolbarContainer.leadingAnchor),
      convertButton.trailingAnchor.constraint(equalTo: toolbarContainer.trailingAnchor),
      convertButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
}

// MARK: - Data Fetching

private extension ConverterViewController {
  
  func fetchFiatCurrencies() {
    guard currencies == nil else {
      return
    }
    
    dataManager.getCurrenciesList { [weak self] data in
      // TODO: Perform O(1) lookup here with a Set instead of using .first
      self?.baseCurrencyData = data?.first(where: { currencyData in currencyData.iso4217 == "USD" })
      self?.targetCurrencyData = data?.first(where: { currencyData in currencyData.iso4217 == "JPY" })
      self?.currencies = data
    }
  }
  
}

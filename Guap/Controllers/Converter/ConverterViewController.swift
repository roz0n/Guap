//
//  ConverterViewController.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class ConverterViewController: UIViewController {
  
  // MARK: - Properties
  
  let currentLocale = Locale.current
  private lazy var localeCache: [String: Locale]? = [:]
  
  let defaultBaseCurrency = "USD"
  let defaultTargetCurrency = "JPY"
  
  var baseCurrencyButton = PrimaryButton(title: "Base", color: .white, background: .systemGray6)
  var targetCurrencyButton = PrimaryButton(title: "Target", color: .white, background: .systemGray6)
  var convertButton = PrimaryButton(title: K.Labels.convertButton, color: .white, background: .systemGreen)
  
  var baseValueTextField = ConverterTextField(label: "Convert from: ")
  var targetValueTextField = ConverterTextField(label: "Convert to: ")
  
  var currencies: [FiatCurrency]?
  let fiatDataManager = FiatCurrencyNetworkManager()
  var fiatPairExchangeRateData: FiatExchangeRateResponse?
  
  var baseCurrencyData: FiatCurrency? {
    didSet {
      if let countryCode = baseCurrencyData?.iso31661,
         let currencyCode = baseCurrencyData?.iso4217,
         let currencyName = baseCurrencyData?.currencyName {
        baseCurrencyButton.setButtonTitle(countryCode: countryCode, currencyCode: currencyCode)
        baseValueTextField.setTextFieldLabel("Convert from: \(currencyName)")
      }
    }
  }
  
  var targetCurrencyData: FiatCurrency? {
    didSet {
      if let countryCode = targetCurrencyData?.iso31661,
         let currencyCode = targetCurrencyData?.iso4217,
         let currencyName = targetCurrencyData?.currencyName {
        targetCurrencyButton.setButtonTitle(countryCode: countryCode, currencyCode: currencyCode)
        targetValueTextField.setTextFieldLabel("Convert to: \(currencyName)")
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
    
    configureViewController()
    configureTargetButton()
    applyLayouts()
    applyGestures()
    
    fetchInitialFiatData()
  }
  
  // MARK: - Configurations
  
  private func configureViewController() {
    view.backgroundColor = .black.withAlphaComponent(0.75)
  }
  
  private func configureTargetButton() {
    targetValueTextField.isUserInteractionEnabled = false
    
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
    guard let baseValueText = baseValueTextField.text else { return }
    
    guard let baseValue = Double(baseValueText),
          let exchangeRate = fiatPairExchangeRateData?.data.conversionRate else { return }
    
    // Obtain conversion value, in other words, the target value
    let conversionResult: Double = (baseValue * exchangeRate)
    
    // At this point we either a) obtain Locales for each currency and render them as Locale-formatted strings or b) fallback to rendering the Double as a String
    // Locales require currency codes, so check if those exist (they always should) and fallback to "b" if they don't
    // This check isn't needed as it's probably safe to force-unwrap the currency data since it's coming from a static JSON, but it's best to play it safe regardless
    guard let baseCurrencyCode = baseCurrencyData?.iso4217,
          let targetCurrencyCode = targetCurrencyData?.iso4217 else {
            targetValueTextField.text = String(conversionResult)
            return
          }
    
    // Create the designated Locale objects
    // If unsuccessful, fallback to "b" again
    guard let baseLocale = currentLocale.fromCurrencyCode(baseCurrencyCode, cache: &localeCache),
          let targetLocale = currentLocale.fromCurrencyCode(targetCurrencyCode, cache: &localeCache) else {
            targetValueTextField.text = String(conversionResult)
            return
          }
    
    // At this point, the Locales have been created successfully, so we can render the Locale-formatted strings
    baseValueTextField.text = baseValue.asCurrencyString(with: baseLocale)
    targetValueTextField.text = conversionResult.asCurrencyString(with: targetLocale)
    
    // TODO: For some reason we're losing target value decimals upon conversion. Find out why.
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

// MARK: - Data Fetching

private extension ConverterViewController {
  
  func fetchInitialFiatData() {
    // This will fetch the initial list of fiat currencies and the exchange rate of the default pair
    fetchFiatCurrencies()
    fetchFiatExchangeRate(baseCode: defaultBaseCurrency, targetCode: defaultTargetCurrency)
  }
  
  func fetchFiatCurrencies() {
    guard currencies == nil else {
      return
    }
    
    fiatDataManager.getCurrenciesList { [weak self] data in
      // TODO: Perform O(1) lookup here with a Set instead of using .first
      self?.baseCurrencyData = data?.first(where: { [weak self] currencyData in currencyData.iso4217 == self?.defaultBaseCurrency })
      self?.targetCurrencyData = data?.first(where: { [weak self] currencyData in currencyData.iso4217 == self?.defaultTargetCurrency })
      self?.currencies = data
    }
  }
  
  func fetchFiatExchangeRate(baseCode: String, targetCode: String) {
    fiatDataManager.fetchPairExchangeRate(baseCode: baseCode, targetCode: targetCode) { [weak self] result in
      switch result {
        case .success(let responseData):
          self?.fiatPairExchangeRateData = responseData
        case .failure(let error):
          print("Error fetching fiat pair exchange rate:")
          print(error)
      }
    }
  }
  
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
    textFieldsContainer.addSubview(baseValueTextField)
    textFieldsContainer.addSubview(targetValueTextField)
    
    NSLayoutConstraint.activate([
      baseValueTextField.heightAnchor.constraint(equalToConstant: K.Sizes.inputTextViewHeight),
      baseValueTextField.widthAnchor.constraint(equalTo: textFieldsContainer.widthAnchor),
      baseValueTextField.topAnchor.constraint(equalTo: textFieldsContainer.topAnchor),
      
      targetValueTextField.heightAnchor.constraint(equalToConstant: K.Sizes.inputTextViewHeight),
      targetValueTextField.widthAnchor.constraint(equalTo: textFieldsContainer.widthAnchor),
      targetValueTextField.topAnchor.constraint(equalTo: baseValueTextField.bottomAnchor, constant: (K.Sizes.lgSpace * 2)),
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

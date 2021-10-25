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
  
  var currencyTableDismissHandler: (() -> Void)?
  
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
  
  var contentContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
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
  
  var chartContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemGray6.withAlphaComponent(0.5)
    view.layer.cornerRadius = K.Sizes.mdRadius
    return view
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    configureBlocks()
    configureTargetButton()
    configureConverterTextField()
    
    applyLayouts()
    applyGestures()
    
    fetchInitialFiatData()
  }
  
  // MARK: - Configurations
  
  private func configureViewController() {
    view.backgroundColor = .black.withAlphaComponent(0.75)
  }
  
  private func configureBlocks() {
    configureCurrencyTableDismissHandler()
  }
  
  private func configureTargetButton() {
    targetValueTextField.isUserInteractionEnabled = false
  }
  
  private func configureConverterTextField() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShown), name: UIResponder.keyboardDidShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
  }
  
  private func configureCurrencyTableDismissHandler() {
    currencyTableDismissHandler = { [weak self] in
      guard let baseCurrencyData = self?.baseCurrencyData, let targetCurrencyData = self?.targetCurrencyData else {
        return
      }
      
      self?.fetchFiatExchangeRate(baseCode: baseCurrencyData.iso4217, targetCode: targetCurrencyData.iso4217)
      
      print("Dismissed vc")
    }
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
  
  @objc func handleKeyboardShown(notification: NSNotification) {
    print("Keyboard shown")
  }
  
  @objc func handleKeyboardHidden(notification: NSNotification) {
    print("Keyboard hidden")
  }
  
  @objc func tappedConvertButton() {
    // Obtain the user-input base currency value from the text field (which is a String)
    guard let baseValueText = baseValueTextField.text else { return }
    
    // Convert the String to a decimal safely, that might fail so the result is Decimal?
    guard let baseValue = baseValueText.asDecimal() else {
      return
    }
    
    // Convert the exchange rate, which is a Double, to a Decimal safely
    guard let exchangeRateDouble = fiatPairExchangeRateData?.data.conversionRate else {
      return
    }
    
    let exchangeRate: Decimal = NSNumber(floatLiteral: exchangeRateDouble).decimalValue
    
    // Obtain conversion value, in other words, the target value
    let conversionResult: Decimal = (baseValue * exchangeRate)
    
    // At this point we either a) obtain Locales for each currency and render them as Locale-formatted strings or b) fallback to rendering the Decimal as a String
    // Locales require currency codes, so check if those exist (they always should) and fallback to "b" if they don't
    // This check isn't needed as it's probably safe to force-unwrap the currency data since it's coming from a static JSON, but it's best to play it safe regardless
    guard let baseCurrencyCode = baseCurrencyData?.iso4217,
          let targetCurrencyCode = targetCurrencyData?.iso4217 else {
            targetValueTextField.text = conversionResult.asCurrencyString(with: Locale.current)
            return
          }
    
    // Create the designated Locale objects
    // If unsuccessful, fallback to "b" again
    guard let baseLocale = currentLocale.fromCurrencyCode(baseCurrencyCode, cache: &localeCache),
          let targetLocale = currentLocale.fromCurrencyCode(targetCurrencyCode, cache: &localeCache) else {
            targetValueTextField.text = conversionResult.asCurrencyString(with: Locale.current)
            return
          }
    
    // At this point, the Locales have been created successfully, so we can render the Locale-formatted strings
    baseValueTextField.text = baseValue.asCurrencyString(with: baseLocale)
    targetValueTextField.text = conversionResult.asCurrencyString(with: targetLocale)
  }
  
  @objc func tappedBaseButton() {
    let selectorViewController = createCurrencySelector(title: "Select Base Currency", type: .base, dismiss: currencyTableDismissHandler)
    present(selectorViewController, animated: true)
  }
  
  @objc func tappedTargetButton() {
    let selectorViewController = createCurrencySelector(title: "Select Target Currency", type: .target, dismiss: currencyTableDismissHandler)
    present(selectorViewController, animated: true)
  }
  
  // MARK: - Helpers
  
  private func createCurrencySelector(title: String, type: ConverterParameter, dismiss dismissHandler: (() -> Void)?) -> UINavigationController {
    let rootViewController = CurrencyTableViewController(selectionHandler: handleCurrencySelection(_:_:), type: type)
    rootViewController.title = title
    
    if let dismissHandler = dismissHandler {
      rootViewController.dismissHandler = dismissHandler
    }
    
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
    layoutContentContainer()
    layoutToolbarContainer()
    layoutToolbarButtons()
    layoutTextFieldsContainer()
    layoutTextFields()
    //    layoutConvertButton()
    layoutChartContainer()
  }
  
  // MARK: - Toolbar
  
  func layoutContentContainer() {
    view.addSubview(contentContainer)
    
    NSLayoutConstraint.activate([
      contentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      contentContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      contentContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      contentContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ])
  }
  
  
  func layoutToolbarContainer() {
    contentContainer.addSubview(toolbarContainer)
    
    NSLayoutConstraint.activate([
      toolbarContainer.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: K.Sizes.mdSpace),
      toolbarContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: K.Sizes.mdSpace),
      toolbarContainer.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -(K.Sizes.mdSpace)),
      toolbarContainer.heightAnchor.constraint(equalToConstant: K.Sizes.primaryToolbarHeight)
    ])
  }
  
  func layoutToolbarButtons() {
    toolbarContainer.addArrangedSubview(baseCurrencyButton)
    toolbarContainer.addArrangedSubview(targetCurrencyButton)
  }
  
  // MARK: - Text Views
  
  func layoutTextFieldsContainer() {
    contentContainer.addSubview(textFieldsContainer)
    
    NSLayoutConstraint.activate([
      textFieldsContainer.topAnchor.constraint(equalTo: toolbarContainer.bottomAnchor, constant: (K.Sizes.lgSpace * 2)),
      textFieldsContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: K.Sizes.mdSpace),
      textFieldsContainer.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -(K.Sizes.mdSpace)),
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
      
      textFieldsContainer.bottomAnchor.constraint(equalTo: targetValueTextField.bottomAnchor)
    ])
  }
  
  func layoutChartContainer() {
    contentContainer.addSubview(chartContainer)
    
    NSLayoutConstraint.activate([
      chartContainer.topAnchor.constraint(equalTo: textFieldsContainer.bottomAnchor, constant: K.Sizes.lgSpace),
      chartContainer.leadingAnchor.constraint(equalTo: textFieldsContainer.leadingAnchor),
      chartContainer.trailingAnchor.constraint(equalTo: textFieldsContainer.trailingAnchor),
      chartContainer.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -(K.Sizes.lgSpace))
    ])
  }
  
  // MARK: - Convert Button
  
  func layoutConvertButton() {
    contentContainer.addSubview(convertButton)
    
    NSLayoutConstraint.activate([
      convertButton.heightAnchor.constraint(equalToConstant: K.Sizes.convertButtonHeight),
      convertButton.leadingAnchor.constraint(equalTo: toolbarContainer.leadingAnchor),
      convertButton.trailingAnchor.constraint(equalTo: toolbarContainer.trailingAnchor),
      convertButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
    ])
  }
  
}

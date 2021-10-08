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
  
  var baseCurrencyButton = PrimaryButton(title: "\(Veximoji.country(code: "US")!)   USD", color: .white, background: .systemGray6)
  var targetCurrencyButton = PrimaryButton(title: "\(Veximoji.country(code: "JP")!)   JPY", color: .white, background: .systemGray6)
  var convertButton = PrimaryButton(title: K.Labels.convertButton, color: .white, background: .systemGreen)
  var baseValueTextView = ConverterTextView()
  var targetValueTextView = ConverterTextView()
  
  // MARK: -
  
  var toolbarContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = K.Sizes.mdSpace
    return stack
  }()
  
  var conversionContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black.withAlphaComponent(0.75)
    
    applyLayouts()
    applyGestures()
  }
  
  // MARK: - Configurations
  
  private func configureTextView() {
    //    baseValueTextView.delegate = self
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
    let tappedTargetGesture = UITapGestureRecognizer(target: self, action: #selector(tappedTargetButton))
    
    baseCurrencyButton.addGestureRecognizer(tapBaseGesture)
    targetCurrencyButton.addGestureRecognizer(tappedTargetGesture)
  }
  
  // MARK: - Selectors
  
  @objc func tappedConvertButton() {
    print("Convert button tapped")
  }
  
  @objc func tappedBaseButton() {
    present(createCurrencySelector(title: "Select Base Currency", type: .base), animated: true) {
      print("Presented currency selector: input")
    }
  }
  
  @objc func tappedTargetButton() {
    present(createCurrencySelector(title: "Select Target Currency", type: .target), animated: true) {
      print("Presented currency selector: output")
    }
  }
  
  // MARK: - Helpers
  
  private func createCurrencySelector(title: String, type: ConversionParameter) -> UINavigationController {
    let rootViewController = CurrencySelectorViewController(selectionHandler: handleCurrencySelection(_:_:), type: type)
    rootViewController.title = title
    
    return UINavigationController(rootViewController: rootViewController)
  }
  
  func handleCurrencySelection(_ data: FiatCurrency?, _ type: ConversionParameter?) {
    print("Selected currency \(data) for \(type)")
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
    layoutConversionContainer()
    layoutConversionTextViews()
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
  
  func layoutConversionContainer() {
    view.addSubview(conversionContainer)
    
    NSLayoutConstraint.activate([
      conversionContainer.topAnchor.constraint(equalTo: toolbarContainer.bottomAnchor, constant: K.Sizes.lgSpace),
      conversionContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: K.Sizes.mdSpace),
      conversionContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(K.Sizes.mdSpace)),
      conversionContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(K.Sizes.convertButtonHeight + K.Sizes.lgSpace))
    ])
  }
  
  func layoutConversionTextViews() {
    conversionContainer.addSubview(baseValueTextView)
    conversionContainer.addSubview(targetValueTextView)
    
    NSLayoutConstraint.activate([
      baseValueTextView.heightAnchor.constraint(equalToConstant: K.Sizes.inputTextViewHeight),
      baseValueTextView.widthAnchor.constraint(equalTo: conversionContainer.widthAnchor),
      baseValueTextView.topAnchor.constraint(equalTo: conversionContainer.topAnchor),
      
      targetValueTextView.heightAnchor.constraint(equalToConstant: K.Sizes.inputTextViewHeight),
      targetValueTextView.widthAnchor.constraint(equalTo: conversionContainer.widthAnchor),
      targetValueTextView.topAnchor.constraint(equalTo: baseValueTextView.bottomAnchor, constant: K.Sizes.mdSpace),
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

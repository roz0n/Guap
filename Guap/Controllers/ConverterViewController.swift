//
//  ConverterViewController.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class ConverterViewController: UIViewController {
  
  // MARK: - Properties
  
  var currencySelector = CurrencySelectorViewController()
  var inputButton = PrimaryButton(title: K.Labels.inputButton, color: .white, background: .systemBlue)
  var outputButton = PrimaryButton(title: K.Labels.outputButton, color: .white, background: .systemRed)
  var convertButton = PrimaryButton(title: K.Labels.convertButton, color: .white, background: .systemGreen)
  var inputTextView = ConverterTextView()
  var outputTextView = ConverterTextView()
  
  // MARK: - Views
  
  var toolbarContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = K.Sizes.mdSpace
    return stack
  }()
  
  var conversionContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .fillEqually
    stack.spacing = K.Sizes.mdSpace
    return stack
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGray5
    
    applyLayouts()
    applyGestures()
  }
  
  // MARK: - Configurations
  
  private func configureTextView() {
    inputTextView.delegate = self
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
    let tapInputGesture = UITapGestureRecognizer(target: self, action: #selector(tappedInputButton))
    let tapOutputGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOutputButton))
    
    inputButton.addGestureRecognizer(tapInputGesture)
    outputButton.addGestureRecognizer(tapOutputGesture)
  }
  
  // MARK: - Selectors
  
  @objc func tappedConvertButton() {
    print("Convert button tapped")
    updateOutputLabel()
  }
  
  @objc func tappedInputButton() {
    present(currencySelector, animated: true) {
      print("Presented currency selector: input")
    }
  }
  
  @objc func tappedOutputButton() {
    present(currencySelector, animated: true) {
      print("Presented currency selector: output")
    }
  }
  
  // MARK: - Helpers
  
  private func updateOutputLabel() {
    //    outputLabel.text = "53453.00"
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
    toolbarContainer.addArrangedSubview(inputButton)
    toolbarContainer.addArrangedSubview(outputButton)
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
    conversionContainer.addArrangedSubview(inputTextView)
    conversionContainer.addArrangedSubview(outputTextView)
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

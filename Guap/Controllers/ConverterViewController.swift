//
//  ConverterViewController.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class ConverterViewController: UIViewController {
  
  // MARK: - Properties
  
  var inputButton = PrimaryButton(title: K.Labels.inputButton, color: .white, background: .systemBlue)
  var outputButton = PrimaryButton(title: K.Labels.outputButton, color: .white, background: .systemRed)
  var convertButton = PrimaryButton(title: K.Labels.convertButton, color: .white, background: .systemGreen)
  var inputTextView = InputCurrencyTextView()
  var outputLabel = OutputCurrencyLabel()
  
  // MARK: - Views
  
  var toolbarContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
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
  }
  
  private func addConvertButtonGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedConvertButton))
    convertButton.addGestureRecognizer(tapGesture)
  }
  
  // MARK: - Selectors
  
  @objc func tappedConvertButton() {
    print("Convert button tapped")
    updateOutputLabel()
  }
  
  // MARK: - Helpers
  
  private func updateOutputLabel() {
    outputLabel.text = "53453.00"
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
    layoutInputTextView()
    layoutConvertButton()
    layoutOutputLabel()
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
  
  // MARK: - Text Fields
  
  func layoutInputTextView() {
    view.addSubview(inputTextView)
    
    NSLayoutConstraint.activate([
      inputTextView.topAnchor.constraint(equalTo: toolbarContainer.bottomAnchor, constant: K.Sizes.lgSpace),
      inputTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: K.Sizes.mdSpace),
      inputTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(K.Sizes.mdSpace)),
      inputTextView.heightAnchor.constraint(equalToConstant: K.Sizes.inputTextViewHeight)
    ])
  }
  
  func layoutOutputLabel() {
    view.addSubview(outputLabel)
    
    NSLayoutConstraint.activate([
      outputLabel.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: K.Sizes.mdSpace),
      outputLabel.leadingAnchor.constraint(equalTo: inputTextView.leadingAnchor),
      outputLabel.trailingAnchor.constraint(equalTo: inputTextView.trailingAnchor),
      outputLabel.bottomAnchor.constraint(equalTo: convertButton.topAnchor, constant: -(K.Sizes.lgSpace))
    ])
  }
  
  // MARK: - Conversion Button
  
  func layoutConvertButton() {
    view.addSubview(convertButton)
    
    NSLayoutConstraint.activate([
      convertButton.heightAnchor.constraint(equalToConstant: K.Sizes.convertButtonHeight),
      convertButton.leadingAnchor.constraint(equalTo: inputTextView.leadingAnchor),
      convertButton.trailingAnchor.constraint(equalTo: inputTextView.trailingAnchor),
      convertButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
}

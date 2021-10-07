//
//  ViewController.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import UIKit

class ViewController: UIViewController {
  
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
    stack.spacing = K.Sizes.medSpace
    return stack
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGray5
    
    applyLayouts()
  }
  
  // MARK: - Configurations
  
  private func configureTextView() {
    inputTextView.delegate = self
  }
  
}

// MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
  // TODO: Determine if this is needed
}


// MARK: - Layout

private extension ViewController {
  
  func applyLayouts() {
    layoutToolbarContainer()
    layoutToolbarButtons()
    layoutTextField()
    layoutConvertButton()
  }
  
  // MARK: - Toolbar
  
  func layoutToolbarContainer() {
    view.addSubview(toolbarContainer)
    
    NSLayoutConstraint.activate([
      toolbarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: K.Sizes.medSpace),
      toolbarContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: K.Sizes.medSpace),
      toolbarContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(K.Sizes.medSpace)),
      toolbarContainer.heightAnchor.constraint(equalToConstant: K.Sizes.primaryToolbarHeight)
    ])
  }
  
  func layoutToolbarButtons() {
    toolbarContainer.addArrangedSubview(inputButton)
    toolbarContainer.addArrangedSubview(outputButton)
  }
  
  // MARK: - Text Fields
  
  func layoutTextField() {
    view.addSubview(inputTextView)
    
    NSLayoutConstraint.activate([
      inputTextView.topAnchor.constraint(equalTo: toolbarContainer.bottomAnchor, constant: K.Sizes.medSpace),
      inputTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: K.Sizes.medSpace),
      inputTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(K.Sizes.medSpace)),
      inputTextView.heightAnchor.constraint(equalToConstant: K.Sizes.inputTextViewHeight)
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

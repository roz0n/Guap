//
//  CurrencySelectorViewController.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/7/21.
//

import UIKit
import Veximoji

class CurrencySelectorViewController: UITableViewController {
  
  // MARK: - Properties
  
  static let reuseIdentifier = "currencySelectorCell"
  
  let dataManager = FiatCurrencyDataManager()
  var selectionHandler: ((_: FiatCurrency?, _ type: ConversionParameter?) -> Void)
  var selectionType: ConversionParameter
  var currencies: [FiatCurrency]?
  
  // MARK: - Initializers
  
  init(selectionHandler: @escaping ((_: FiatCurrency?, _ type: ConversionParameter?) -> Void), type selectionType: ConversionParameter) {
    self.selectionHandler = selectionHandler
    self.selectionType = selectionType
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTableView()
    fetchCurrenciesList()
  }
  
  // MARK: - Configurations
  
  private func configureTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: CurrencySelectorViewController.reuseIdentifier)
  }
  
}

// MARK: - Table view data source

extension CurrencySelectorViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currencies?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CurrencySelectorViewController.reuseIdentifier, for: indexPath) as UITableViewCell
    let data = currencies?[indexPath.row]
    let flag = Veximoji.country(code: data?.iso31661) ?? Veximoji.cultural(term: .white)
    
    if let data = data {
      cell.textLabel?.text = "\(flag!)\t \t \(data.iso4217) \t \(data.currencyName)"
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = currencies?[indexPath.row]
    
    dismiss(animated: true) { [weak self] in
      self?.selectionHandler(data, self?.selectionType)
    }
  }
  
}

// MARK: - Networking

private extension CurrencySelectorViewController {
  
  func fetchCurrenciesList() {
    guard currencies == nil else {
      return
    }
    
    dataManager.getCurrenciesList { [weak self] data in
      self?.currencies = data
    }
  }
  
}

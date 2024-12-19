//
//  BitcoinPriceViewController.swift
//  BitcoinExchange
//
//  Created by Jose Bolivar on 19/12/24.
//

import UIKit


/*
 TODO: - Remaining things to implement

 1. Current Price
    - UIView on top of the table view.
    - To avoid complexity it won't be included in the same array as the history
    - Attached to RunLoop timer to update UI every 60 seconds (also maybe a refreshControl)

2. Detail View & Navigation
    - For this project I would like to implement the COORDINATOR PATTERN.
    - Instead of suegues, it would use the coordinator to navigate to the detail view.



3. Detail View
    - Regarding this, only major work would be creating the UI.
    - The datasource already contains the different currencies.


4. Error handling
    - Polish the different error cases, its handling and possible custom alerts

5. Unit tests
    - Specially Viewmodel & API testing.

6. Extra:
    - Improve general UI - loading indicators - ...
 */


class BitcoinPriceViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    // Ideally this would be inyected by a coordinator
    private let viewModel = BitcoinPriceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.activityIndicator.startAnimating()
        self.setupDataBinds()
    }

    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    // Set up the communication with the View Model
    func setupDataBinds() {
        self.viewModel.onPricesUpdated = { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
        self.viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
        self.viewModel.fetchPrices()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource extension
extension BitcoinPriceViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bitcoinPrices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BitcoinPriceCell", for: indexPath) as? BitcoinPriceCell else {
            return UITableViewCell()
        }

        let bitcoinPrice = viewModel.bitcoinPrices[indexPath.row]
        cell.configure(with: bitcoinPrice)

        return cell
    }
}

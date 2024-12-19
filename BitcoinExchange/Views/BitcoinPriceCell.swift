//
//  BitcoinPriceCell.swift
//  BitcoinExchange
//
//  Created by Jose Bolivar on 19/12/24.
//

import UIKit

class BitcoinPriceCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var eurPriceLabel: UILabel!

    func configure(with bitcoinPrice: BitcoinPrice) {
        dateLabel.text = bitcoinPrice.date
        eurPriceLabel.text = String(format: "€%.2f", bitcoinPrice.eurPrice)
    }
}

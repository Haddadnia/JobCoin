import Foundation
import UIKit

let TRANSACTION_CELL = "transaction.cell"

class TransactionTableView: UITableView {

    // In production I would allow adding 1 transaction at a time and animating
    // Here I'll just blow out the whole array and start fresh
    var transactions = [Transaction]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        }
    }

    init(transactions: [Transaction]) {
        super.init(frame: .zero, style: .plain)
        register(TransactionCell.self, forCellReuseIdentifier: TRANSACTION_CELL)
        self.transactions = transactions
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        rowHeight = 55
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TransactionTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactions[indexPath.row]
        if let cell = dequeueReusableCell(withIdentifier: TRANSACTION_CELL) as? TransactionCell {
            cell.amountLabel.text = transaction.amount
            cell.balanceLabel.text = transaction.balance != nil ? "Balance: " + transaction.balance! : nil
            cell.addressLabel.text = (transaction.fromAddress ?? "(GEN)") + " > " + transaction.toAddress
            return cell
        } else {
            return UITableViewCell()
        }

    }

}

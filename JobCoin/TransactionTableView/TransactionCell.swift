import Foundation
import UIKit

class TransactionCell: UITableViewCell {

    let balanceLabel = makeLabel()
    let addressLabel = makeLabel()
    let amountLabel = makeLabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        contentView.addSubview(balanceLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(amountLabel)

        addressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        balanceLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 4).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        balanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        balanceLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

    }
    private static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

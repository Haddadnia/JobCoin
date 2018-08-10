import Foundation
import UIKit

class PortalViewController: UIViewController {

    let address: String
    var tableView = TransactionTableView(transactions: [])

    // MARK: - Initializers
    
    init(address: String, profile: UserProfile) {
        self.address = address
        super.init(nibName: nil, bundle: nil)
        title = address
        display(profile: profile)
        getTransactions()
        setupSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - User Interaction and Network

    func getTransactions() {
        Networker.getTransactions { [weak self] (transactionsArray, error) in
            guard let transactions = transactionsArray else {
                return
            }
            let userSpecificTransactions = transactions.filter({ $0.toAddress == self?.address || $0.fromAddress == self?.address })
            self?.tableView.transactions = userSpecificTransactions
        }
    }
    func updateProfile(_ user: String? = nil) {
        Networker.getAddress(user ?? address, completion: { [weak self] profile, error in
            if let profile = profile {
                self?.display(profile: profile)
            } else {
                // DISPLAY ERROR
                self?.addressEntryTextField.text = "ERROR"
            }
        })
    }
    func display(profile userProfile: UserProfile) {
        DispatchQueue.main.async { [weak self] in
            self?.balanceLabel.text = userProfile.balance
        }
    }
    @objc func userDidTapSend() {
        guard let amount = amountEntryTextField.text,
            amount != "",
            let recipient = addressEntryTextField.text,
            recipient != "" else {
            // Show an inline error in the fields which are not properly filled out
            return
        }
        Networker.postTransaction(amount: amount, fromAddress: address, recipient: recipient) { [weak self] (success) in
            self?.updateProfile()
            self?.getTransactions()
        }
    }
    // MARK: - UI Elements

    private lazy var balanceDescriptorLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.balance
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.brand
        button.setTitleColor(UIColor.gray, for: .selected)
        button.setTitle(Strings.send, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(userDidTapSend), for: .touchUpInside)
        return button
    }()

    private lazy var addressEntryTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = Strings.sendToAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private lazy var amountEntryTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = Strings.enterAmount
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    func setupSubviews() {
        view.backgroundColor = UIColor.white

        let views = [balanceDescriptorLabel, balanceLabel, sendButton, addressEntryTextField, amountEntryTextField, tableView]
        _ = views.map({
            view.addSubview($0)
        })

        // Balance
        balanceDescriptorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        balanceDescriptorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        balanceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        balanceLabel.leadingAnchor.constraint(equalTo: balanceDescriptorLabel.trailingAnchor, constant: 10).isActive = true

        // Note - In production I'd break this sending module out into its own subclass of UIView
        // Sending
        amountEntryTextField.topAnchor.constraint(equalTo: balanceDescriptorLabel.bottomAnchor, constant: 20).isActive = true
        amountEntryTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
        amountEntryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        addressEntryTextField.topAnchor.constraint(equalTo: balanceDescriptorLabel.bottomAnchor, constant: 20).isActive = true
        addressEntryTextField.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        addressEntryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true

        sendButton.topAnchor.constraint(equalTo: addressEntryTextField.bottomAnchor, constant: 10).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        // Table view
        tableView.delegate = self
        tableView.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        //This would need to update when the keyboard goes up/down
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension PortalViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        addressEntryTextField.resignFirstResponder()
        amountEntryTextField.resignFirstResponder()
    }
}

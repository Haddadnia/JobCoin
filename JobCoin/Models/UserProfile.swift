import Foundation

class UserProfile {
    let balance: String
    var transactions: [Transaction] = []

    public init(balance: String, transactions: [Transaction]) {
        self.balance = balance
        self.transactions = transactions
    }

    public init?(dictionary: JSONDictionary) {
        guard let balance = dictionary["balance"] as? String,
            let jsonTransactions = (dictionary["transactions"] as? [JSONDictionary]) else { return nil }
        let transactions = jsonTransactions.compactMap(Transaction.init)

        self.balance = balance
        self.transactions = transactions
    }
}


import Foundation

public struct Transaction {
    let timeStamp: String
    let toAddress: String
    let fromAddress: String?
    let amount: String
    var balance: String?

    public init?(dictionary: JSONDictionary) {
        guard let timeStamp = dictionary["timestamp"] as? String,
            let toAddress = dictionary["toAddress"] as? String,
            let amount = dictionary["amount"] as? String else {
                assertionFailure("Failed to initalize Transaction from JSON")
                return nil
        }
        let fromAddress = dictionary["fromAddress"] as? String

        self.timeStamp = timeStamp
        self.toAddress = toAddress
        self.fromAddress = fromAddress
        self.amount = amount
        self.balance = nil
    }
}

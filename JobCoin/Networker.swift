import Foundation

public typealias JSONDictionary = [String: Any]

public struct Networker {
    private static let getAddressURL = "http://jobcoin.gemini.com/snowfield/api/addresses/"
    private static let getTransactionsURL = URL(string:"http://jobcoin.gemini.com/snowfield/api/transactions")
    private static let postTransactionsURL = URL(string:"http://jobcoin.gemini.com/snowfield/api/transactions")

    static func getAddress(_ address: String, completion: @escaping (UserProfile?, Error?) -> Void) {
        guard let url = URL(string:Networker.getAddressURL + address) else {
            assertionFailure("Something happened to your address url")
            return
        }
        makeGetRequest(url: url) { (json, array, error) in
            guard let json = json else {
                completion(nil, error)
                return
            }
            completion(UserProfile(dictionary: json), nil)
        }
    }
    static func getTransactions(completion: @escaping ([Transaction]?, Error?) -> Void) {
        guard let url = Networker.getTransactionsURL else {
            assertionFailure("Something happened to your get transactions url")
            return
        }
        makeGetRequest(url: url) { (json, array, error) in
            guard let responseArray = array else {
                completion(nil, error)
                return
            }
            let transactions = responseArray.compactMap(Transaction.init)
            completion(transactions, nil)
        }
    }
    static func postTransaction(amount: String, fromAddress: String, recipient: String, completion: @escaping (Bool) -> Void) {
        guard let url = Networker.postTransactionsURL else {
            assertionFailure("Something happened to your post transaction url")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "amount=" + amount + "&toAddress=" + recipient + "&fromAddress=" + fromAddress
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            // check for HTTP errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(false)
            }
            let _ = String(data: data, encoding: .utf8)
            completion(true)
        }
        task.resume()
    }

    static private func makeGetRequest(url: URL, completion: @escaping (JSONDictionary?, [JSONDictionary]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(json as? [String : Any], json as? [JSONDictionary], error)
                }  catch let error as NSError {
                    print(error.localizedDescription)
                    completion(nil, nil, error)

                }
            } else if let error = error {
                print(error.localizedDescription)
                completion(nil, nil, error)
            }
        }
        task.resume()
    }
}


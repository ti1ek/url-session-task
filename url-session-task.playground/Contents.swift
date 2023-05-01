import UIKit
import CryptoKit

//MARK: - URL

struct MarvelURL {
    private var components = URLComponents()
    
    private let scheme = "https"
    private let host = "gateway.marvel.com"
    private let path = "/v1/public/characters"
    
    private let ts = String(Int.random(in: 1...99))
    private let publicKey = "4b38cdf838b8c67ad1e7392b5ea095f6"
    private let privateKey = "e57215b819bba0de867f2c626a3b231adacf930b"
    
    private var hash: String {
        MD5(string: ts + privateKey + publicKey)
    }
    
    init() {
        setURL()
    }
    
    private mutating func setURL() {
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [URLQueryItem(name: "name", value: "LOKI"),
                                 URLQueryItem(name: "ts", value: ts),
                                 URLQueryItem(name: "apikey", value: publicKey),
                                 URLQueryItem(name: "hash", value: hash)]
    }
    
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))
        
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    public func getStringUrl() -> String {
        components.string ?? "Error"
    }
}

//MARK: - Parsing

func getData(urlRequest: String) {
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
        if error != nil {
            print("Error: \(String(describing: error)) \n ---------------------- \n")
        } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            print("Response = \(response.statusCode) \n ---------------------- \n")
            guard let data = data else { return }
            let dataAsString = String(data: data, encoding: .utf8)
            print("Data printing \n ---------------------- \n\(String(describing: dataAsString))")
        }
    }.resume()
}

//MARK: - Execute

let marvelURL = MarvelURL()
getData(urlRequest: marvelURL.getStringUrl())

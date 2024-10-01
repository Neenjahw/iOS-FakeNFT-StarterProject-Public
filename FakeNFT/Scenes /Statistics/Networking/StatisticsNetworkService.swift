import Foundation

final class StatisticsNetworkService {
    
    static let shared = StatisticsNetworkService()
    private init() {}
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        performRequest(
            endpoint: "/api/v1/users",
            completion: completion
        )
    }
    
    func fetchNFT(completion: @escaping (Result<[NFTModel], Error>) -> Void) {
        performRequest(
            endpoint: "/api/v1/nft",
            completion: completion
        )
    }
    
    private func performRequest<T: Decodable>(
        endpoint: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        assert(Thread.isMainThread, "Must be called on the main thread")
        
        guard let request = URLRequest.makeHTTPRequest(
            path: endpoint,
            httpMethod: "GET",
            baseURL: URL(string: RequestConstants.baseURL)
        ) else {
            assertionFailure("Invalid request for endpoint: \(endpoint)")
            return
        }
        
        URLSession.shared.objectTask(for: request) { (response: Result<T, Error>) in
            switch response {
            case .success(let body):
                completion(.success(body))
            case .failure(let error):
                print("[NetworkService]: \(error.localizedDescription) Request: \(request)")
                completion(.failure(error))
            }
        }
    }
}

extension URLSession {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                if 200..<300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(result))
                    } catch {
                        print("Decoding error: \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "")")
                        fulfillCompletion(.failure(NetworkError.serviceError))
                    }
                } else {
                    print("HTTP error: \(statusCode)")
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("URLSession error: \(error.localizedDescription)")
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Unknown error")
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        
        task.resume()
    }
}

extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL?
    ) -> URLRequest? {
        guard let requestURL = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case serviceError
}

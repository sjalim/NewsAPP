//
//  APIRequest.swift
//  NewsApp
//
//  Created by bjit on 14/1/23.
//

import Foundation
enum APIError: Error {
    case invalidUrl
    case errorDecode
    case failed(error: Error)
    case unknownError
}
class APIRequestManager{
    
    static let shared = APIRequestManager()
    
    private init() {}
    
    var totalSize = 0
    
    
    
    func fetchData(category: String,  completion: @escaping (Result<ApiResposeModel, APIError>) -> Void){
            
        
        var components = URLComponents(string: Constants.newsApiUrlString)!
        
        components.queryItems = [
        
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "category", value: category),
            URLQueryItem(name: "apiKey", value: "b2565b42cdba4b8aa5f687bfc6e79a5c"),
            URLQueryItem(name: "pageSize", value: "20")
            
        ]
        
        guard let url = components.url else{ return }
//
//      let urlString = Constants.shared.newsCategoryApiUrlString(cateogy: category)
//        guard let url =  URL(string: urlString)  else {
//                   completion(.failure(.invalidUrl))
//                   return
//               }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error  in
                    if error != nil {
                        print("dataTask error: \(error!.localizedDescription)")
                        completion(.failure(.failed(error: error!)))
                    } else if let data = data {
                        // Success request
                        do {
                            // 4. Decode json into array of User
                            let getRespose = try JSONDecoder().decode(ApiResposeModel.self, from: data)
                            print("success")
                            self.totalSize += getRespose.totalResults
                            completion(.success(getRespose))
                        } catch {
                            // Send error when decoding
                            print("decoding error")
                            completion(.failure(.errorDecode))
                        }
                    } else {
                        print("unknown dataTask error")
                        completion(.failure(.unknownError))
                    }
                }
                .resume()
    }
    
    
    func fetchAllData(){
        
        guard let url = URL(string: Constants.newsApiUrlString) else{
            return
        }

        URLSession.shared.dataTask(with: url)
        {
            data, response, error in
            
            if let error = error {
                print("There was an error:\(error.localizedDescription)")
            }
            else{
                
                let decoder = JSONDecoder()
                
                guard let data = data else{
                    print("Error: data not found")
                    return
                }
                
                let respose = try? decoder.decode(ApiResposeModel.self, from: data)
            }
        }.resume()
    }
}

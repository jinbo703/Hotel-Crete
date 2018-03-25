//
//  WebService.swift
//  HotelCrete
//
//  Created by John Nik on 23/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation
import SVProgressHUD

struct WebService {
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    private func dismissHud() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    func urlSession<U, T>(urlString: String, model: U, completion: @escaping (Result<T>) -> ()) where T: Codable, U: Codable {
        
        guard let url = GlobalFunction.getUrlFromString(urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(model)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        SVProgressHUD.show()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.dismissHud()
            
            if let error = error {
                print("Error for get post: ", error.localizedDescription)
                completion(.failure(error))
                return
            }
            guard let data = data else {
                return
            }
            
//            let jsonString = String(data: data, encoding: .utf8)
//            print("json: ", jsonString ?? "")
            
            do {
                
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
                
            } catch let jsonErr {
                print("Error serializing get post: ", jsonErr)
                completion(.failure(jsonErr))
                return
            }
            
        }
        
        
        task.resume()
    }
    
    func urlSession<T>(urlString: String, dictionary: [String: Any], completionHandler: @escaping (Result<T>) -> Void) where T: Codable {
        
        
        guard let url = GlobalFunction.getUrlFromString(urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
            request.httpBody = jsonData
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        SVProgressHUD.show()
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            self.dismissHud()
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            DispatchQueue.main.async { // Correct
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                let decoder = JSONDecoder()
//                let jsonString = String(data: responseData, encoding: .utf8)
//                print("json: ", jsonString ?? "")
                do {
                    let todo = try decoder.decode(T.self, from: responseData)
                    completionHandler(.success(todo))
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                    completionHandler(.failure(error))
                }
            }
        })
        task.resume()
    }
    
    func urlSessionUrlencoded<T>(urlString: String, dictionary: [String: Any], completionHandler: @escaping (Result<T>) -> Void) where T: Codable {
        
        
        guard let url = GlobalFunction.getUrlFromString(urlString) else {
            return
        }
        var post = ""
        for (key, value) in dictionary {
            if post.count > 0 {
                post += "&"
            }
            post += key + "=" + String(describing: value)
        }
        print("post string", post)
        let postData = post.data(using: .utf8)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        SVProgressHUD.show()
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            self.dismissHud()
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            DispatchQueue.main.async { // Correct
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                let decoder = JSONDecoder()
//                let jsonString = String(data: responseData, encoding: .utf8)
//                print("json: ", jsonString ?? "")
                do {
                    let todo = try decoder.decode(T.self, from: responseData)
                    completionHandler(.success(todo))
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                    completionHandler(.failure(error))
                }
            }
        })
        task.resume()
    }
    
    func urlSession<T>(method: String? = nil, urlString: String, data: Data? = nil, completionHandler: @escaping (Result<T>) -> Void) where T: Codable {
        
        guard let url = GlobalFunction.getUrlFromString(urlString) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        if method == "POST" {
            urlRequest.httpMethod = "POST";
            urlRequest.httpBody = data
        }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        // vs let session = URLSession.shared
        SVProgressHUD.show()
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            self.dismissHud()
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            DispatchQueue.main.async { // Correct
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                let decoder = JSONDecoder()
//                print(String(data: responseData, encoding: .utf8) ?? "")
                do {
                    let todo = try decoder.decode(T.self, from: responseData)
                    completionHandler(.success(todo))
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                    completionHandler(.failure(error))
                }
            }
        })
        task.resume()
    }
}

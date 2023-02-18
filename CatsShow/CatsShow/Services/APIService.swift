//
//  CatShowAPIService.swift
//  CatsShow
//
//  Created by Tanzeem Ahamad.


import Foundation
import UIKit

class APIService : APIServiceProtocol{
    var fetchResult: DataResult?
    
    func fetchRequest(urlStr:String?,completion: @escaping (DataResult) -> Void) {
   
        if !(urlStr!.isValidURL){
            self.fetchResult = .failure(.invalidURL)
            completion(self.fetchResult!)
            return
        }

        let url = URL(string: urlStr!)!
        URLSession.shared.dataTask(with: url) {  data, response, error in
            
            if let error{
                self.fetchResult = .failure(.errorString(errString: error.localizedDescription))
                completion(self.fetchResult!)
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                self.fetchResult = .failure(.serverError(statusCode: response.statusCode))
                completion(self.fetchResult!)
                return
            }
            
            if let data = data{
                self.fetchResult = .success(data)
        
            }
            else {
                self.fetchResult = .failure(.noData)
            }
            
            completion(self.fetchResult!)
        }.resume()
    }
}

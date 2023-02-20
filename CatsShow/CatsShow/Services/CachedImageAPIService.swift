//
//  CatShowAPIService.swift
//  CatsShow
//
//  Created by Tanzeem Ahamad.


import Foundation
import UIKit

class CachedImageAPIService {
    
    func fetchRequest(url: URL,number:Int, toFile file: URL, completion: @escaping (Error?) -> Void) {
        
        URLSession.shared.downloadTask(with: url) {
            (tempURL, response, error) in
            
            if let error{
                 completion(error)
                return
            }
            
            let filePath = CatUtility.getCacheImageFilePath(num:number)
            
            do {
                try FileManager.default.copyItem(at: tempURL!,to: filePath)
                print("File saved : \(String(describing: filePath.path))")
            }
            catch(let error){
              completion(error)
                return
            }
            
            completion(nil)
        
        }.resume()
    }
}

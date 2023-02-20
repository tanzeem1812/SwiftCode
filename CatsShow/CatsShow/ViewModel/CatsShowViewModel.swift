//
//  CatsShowViewModel.swift
//  CatsShow
//
//  Created by Tanzeem Ahamad.


import Foundation
import UIKit
import Kingfisher

class CatsShowViewModel{
    weak var catImageUrlOutput : CatsShowViewModelImageURLOutput?
    weak var catImageOutput : CatsShowViewModelImageOutput?
    weak var catDataOutput: CatsShowViewModelFactDataOutput?
    
    var apiService:APIServiceProtocol?
    var cachedImageAPIService:CachedImageAPIService?
    
    init(apiService:APIServiceProtocol? = nil){
        self.apiService = apiService
        self.cachedImageAPIService = CachedImageAPIService()
    }
    
    func fetchCatImageRequestUsingCache(completion: ((Result<URL,ErrorCodes>)->Void)? = nil) {
        var fetchResult : Result<URL, ErrorCodes>?
        let urlStr = CatUtility.randomNumberForCatImageURLString(from:1,to:16)
        if urlStr.isValidURL{
            let imageUrl = URL(string: urlStr)
            //catImageUrlOutput?.updateImageViewFromURL(catImageUrl:imageUrl!)
            fetchResult = .success(imageUrl!)
        }
        else{
            fetchResult = .failure(.invalidURL)
            //catImageUrlOutput?.handleError(error:.invalidURL)
        }
        completion?(fetchResult!)
    }

    func fetchCachedCatImageRequest(completion:((Data?, Error?)->Void)? = nil){
        let (imageStr,number) = CatUtility.randomNumberAndCatImageURLString(from: 1, to: 16)
        let url = URL(string: imageStr)!
        
        
        let filePath = CatUtility.getCacheImageFilePath(num:number)
        if let data = try? Data(contentsOf: filePath) {
            print("File already exist :\(filePath.path)")
            completion?(data, nil)
            return
        }
        
        
        // If the image does not exist in the cache, download the image to the cache
        cachedImageAPIService?.fetchRequest(url: url, number:number, toFile: filePath) { (error) in
            let data = try? Data(contentsOf: filePath)
            completion?(data, error)
        }
    }
    
    
    func fetchCatImageRequest(completion: ((Result<UIImage,ErrorCodes>)->Void)? = nil){
        var fetchResult : Result<UIImage, ErrorCodes>?
        let urlStr = Constants.catImagesBaseUrl
        apiService?.fetchRequest(urlStr:urlStr,completion: {[weak self] result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data){
                    fetchResult = .success(image)
                    self?.catImageOutput?.updateImageView(image: image)
                }
                else {
                    fetchResult = .failure(.badImage)
                    self?.handleError(error: .badImage)
                }
            case .failure(let error):
                fetchResult = .failure(error)
                self?.handleError(error: error)
            }
            completion?(fetchResult!)
        })
    }
    
    func fetchCatDataRequest(completion: ((Result<CatDataModel,ErrorCodes>)->Void)? = nil){
        var fetchResult : Result<CatDataModel, ErrorCodes>?
        let urlStr = Constants.catFactsBaseUrl
        apiService?.fetchRequest(urlStr:urlStr, completion:{[weak self] result in
            switch result {
            case .success(let data):
                do {
                    let data = try JSONDecoder().decode(CatDataModel.self, from: data)
                    fetchResult = .success(data)
                    //self?.catDataOutput?.updateFactView(dataModel: data)
                } catch {
                    self?.handleError(error: .decodingError)
                    fetchResult = .failure(.decodingError)
                }
            case .failure(let error):
                self?.handleError(error: error)
                fetchResult = .failure(error)
            }
            completion?(fetchResult!)
        })
    }
    
    func handleError(error:ErrorCodes){
        self.catImageOutput?.handleError(error:error)
    }
}

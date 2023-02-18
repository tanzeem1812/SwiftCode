//
//  Utility.swift
//  CatsShow
//
//  Created by Tanzeem Ahamad.

enum ErrorCodes: Error,Equatable {
    case serverError(statusCode: Int)
    case errorString(errString:String)
    case noData
    case invalidURL
    case decodingError
    case encodingError
    case badImage
}

enum Constants {
    
#if DEVELOPMENT
    static let catImagesBaseUrl_random = "https://placekitten.com/200/300"
    static let catImagesBaseUrl = "https://cataas.com/cat"
    static let catFactsBaseUrl = "https://meowfacts.herokuapp.com"
#else
    static let catImagesBaseUrl_random = "https://placekitten.com/200/300"
    static let catImagesBaseUrl = "https://thecatapi.com/api/images/get"
    static let catFactsBaseUrl = "https://meowfacts.herokuapp.com"
#endif
    
}








//
//  Utility.swift
//  CatsShow
//
//  Created by Tanzeem Ahamad 
//
import Foundation

struct CatUtility{

    static func randomNumberForCatImageURLString(from:Int,to:Int)->String{
        let randomNumber = Int.random(in: from..<to)
        let baseUrlStr = Constants.catImagesBaseUrl_random
        let urlStr = "\(baseUrlStr)?image=\(randomNumber)"
        return urlStr
    }
}

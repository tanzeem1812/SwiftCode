//
//  Utility.swift
//  CatsShow
//
//  Created by Tanzeem Ahamad 
//
import Foundation

struct CatUtility{

  
    static func randomNumberAndCatImageURLString(from:Int,to:Int)->(String,Int){
        let randomNumber = Int.random(in: from..<to+1)
        let baseUrlStr = Constants.catImagesBaseUrl_random
        let urlStr = "\(baseUrlStr)?image=\(randomNumber)"
        return (urlStr,randomNumber)
    }
    
    static func getCacheImageFilePath(num:Int)->URL{
        let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let filePath = directory!.appendingPathComponent("image"+"\(num)")
        return filePath
    }
}

//
//  CatModel.swift
//  CatsShow
//
//  Created by Tanzeem Ahamad.

import UIKit

struct CatDataModel:Decodable{
    let facts:[String]
    
    private enum CodingKeys:String,CodingKey{
        case facts = "data"
    }
}




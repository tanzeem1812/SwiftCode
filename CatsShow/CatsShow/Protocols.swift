//
//  Protocols.swift
//  CatsShow
//
//  Created by Tanzeem Ahamad
//

import Foundation
import UIKit

protocol APIServiceProtocol{
    typealias DataResult = Result<Data, ErrorCodes>
    var fetchResult: DataResult? { get set}
    func fetchRequest(urlStr:String?,completion:@escaping(DataResult)->Void)
}

protocol CatsShowViewModelImageURLOutput:AnyObject{
    func updateImageViewFromURL(catImageUrl:URL)
    func handleError(error:ErrorCodes)
}

protocol CatsShowViewModelImageOutput:AnyObject{
    func updateImageView(image:UIImage?)
    func handleError(error:ErrorCodes)
}

protocol CatsShowViewModelFactDataOutput :AnyObject{
    func updateFactView(dataModel:CatDataModel)
    func handleError(error:ErrorCodes)
}

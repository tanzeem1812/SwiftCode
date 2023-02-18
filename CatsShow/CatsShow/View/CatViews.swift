//
//  CatImageView.swift
//  CatsShow
//
//  Created by Tanzeem Ahamad 
//

import Foundation
import UIKit
    
class CatLabel{
    let label : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        return label
    }()
}

class CatTextView{
     let textView :UITextView = {
        let textView = UITextView()
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.white
        textView.font = .systemFont(ofSize: 20)
        textView.backgroundColor = UIColor.lightGray
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.layer.borderWidth = 2
        textView.isEditable = false
        return textView
    }()
}

class CatImageView{
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
}

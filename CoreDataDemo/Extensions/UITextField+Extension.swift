//
//  UITextField+Extension.swift
//  CoreDataDemo
//
//  Created by Sebastian Strus on 2022-01-30.
//

import UIKit

extension UITextField {
    
    public convenience init(placeholder: String) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.preferredFont(forTextStyle: .body)
        layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        backgroundColor = .white
        layer.borderColor = UIColor.white.cgColor
        autocorrectionType = .no
        layer.borderWidth = 1
        layer.cornerRadius = 5
        self.placeholder = placeholder
    }
    


    
}

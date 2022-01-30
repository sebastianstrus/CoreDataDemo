//
//  UIButton+Extension.swift
//  CoreDataDemo
//
//  Created by Sebastian Strus on 2022-01-30.
//

import UIKit

extension UIButton {
    
    public convenience init(title: String) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        backgroundColor = .systemBlue
        layer.cornerRadius = 5
        setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
    }
    


    
}

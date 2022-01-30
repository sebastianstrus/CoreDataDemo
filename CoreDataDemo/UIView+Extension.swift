//
//  UIView+Extension.swift
//  CoreDataDemo
//
//  Created by Sebastian Strus on 2022-01-30.
//


import UIKit

extension UIView {
    func setAnchor(width: CGFloat, height: CGFloat) {
        self.setAnchor(top: nil,
                       leading: nil,
                       bottom: nil,
                       trailing: nil,
                       paddingTop: 0,
                       paddingLeft: 0,
                       paddingBottom: 0,
                       paddingRight: 0,
                       width: width,
                       height: height)
    }
    
    func setAnchor(top: NSLayoutYAxisAnchor?,
                   leading: NSLayoutXAxisAnchor?,
                   bottom: NSLayoutYAxisAnchor?,
                   trailing: NSLayoutXAxisAnchor?,
                   paddingTop: CGFloat,
                   paddingLeft: CGFloat,
                   paddingBottom: CGFloat,
                   paddingRight: CGFloat,
                   width: CGFloat = 0,
                   height: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        }
        return leadingAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        }
        return trailingAnchor
    }
    
    func pinToEdges(view: UIView, safe: Bool) {
        setAnchor(top: safe ? view.safeTopAnchor : view.topAnchor,
                  leading: view.leadingAnchor,
                  bottom: safe ? view.safeBottomAnchor : view.bottomAnchor,
                  trailing: view.trailingAnchor,
                  paddingTop: 0,
                  paddingLeft: 0,
                  paddingBottom: 0,
                  paddingRight: 0)
    }
    

}

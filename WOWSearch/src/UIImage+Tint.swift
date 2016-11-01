//
//  UIImage+Tint.swift
//  WOWSearch
//
//  Created by Zhou Hao on 01/11/16.
//  Copyright © 2016年 Zhou Hao. All rights reserved.
//

import UIKit

extension UIImage {
    
    func tint(color: UIColor) -> UIImage {
        let size = self.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        self.draw(at: CGPoint(x:0,y:0), blendMode: CGBlendMode.normal, alpha: 1.0)
        
        context!.setFillColor(color.cgColor)
        context!.setBlendMode(CGBlendMode.sourceIn)
        context!.setAlpha(1.0)
        
        let rect = CGRect(
            origin: CGPoint(x:0,y:0),
            size: CGSize(width:self.size.width,height:self.size.height))
        UIGraphicsGetCurrentContext()!.fill(rect)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage!
    }
}

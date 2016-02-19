//
//  ImageRotation.swift
//  NutriWeekApp
//
//  Created by Gabriel Maciel Bueno Luna Freire on 24/11/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

//ImageRotation.swift

import UIKit

extension UIImage {
    public func rotate(radian: CGFloat, flip: Bool, invertSize: Bool) -> UIImage {
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(radian);
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, radian);
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        if invertSize {
            CGContextDrawImage(bitmap, CGRectMake(-size.height / 2, -size.width / 2, size.height, size.width), CGImage)
        }
        else {
            CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
//    public func resize(newSize: CGSize) -> UIImage {
//        UIGraphicsBeginImageContext( newSize );
//        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        return newImage
//    }
}
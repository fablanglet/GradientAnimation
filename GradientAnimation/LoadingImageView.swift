//
//  LoadImageView.swift
//  GradientAnimation
//
//  Created by Fabian Langlet on 5/24/16.
//  Copyright © 2016 Larry Natalicio. All rights reserved.
//

import UIKit


class LoadingImageView: UIImageView {
    
    // MARK: - Properties
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        
        // Configure gradient.
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        UIColor.grayColor()
        let grey = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.7)
        let greyO = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
        let white = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let colors = [white.CGColor, grey.CGColor, grey.CGColor, white.CGColor]
        gradientLayer.colors = colors
        
        let locations = [0.2, 0.4, 0.6, 0.8]
        gradientLayer.locations = locations
        
        return gradientLayer
    }()
    
    // MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyMask()
    }
    
    override init(image: UIImage?) {
        super.init(image:image)
        applyMask()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        applyMask()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyMask()
    }
    
    
    override func layoutSubviews() {
        gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y, width: 2 * bounds.size.width, height: bounds.size.height)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        layer.addSublayer(gradientLayer)
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25, 0.5]
        gradientAnimation.toValue = [0.75, 1.0, 1.0, 1.0]
        gradientAnimation.duration = 1.2
        gradientAnimation.repeatCount = Float.infinity
        gradientAnimation.removedOnCompletion = false
        gradientAnimation.fillMode = kCAFillModeForwards
        
        gradientLayer.addAnimation(gradientAnimation, forKey: nil)
    }
    
    
    private func applyMask(){
        setNeedsDisplay()
        
        // Create a temporary graphic context in order to render the text as an image.
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        //text.drawInRect(bounds, withAttributes: textAttributes)
        self.image?.drawInRect(bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Use image to create a mask on the gradient layer.
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.clearColor().CGColor
        maskLayer.frame = CGRectOffset(bounds, bounds.size.width, 0)
        maskLayer.contents = image.CGImage
        
        gradientLayer.mask = maskLayer
        
    }

    
}
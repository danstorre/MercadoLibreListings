//
//  ImageViewWithTitleTableViewCell.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class ImageViewWithTitleTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!

    @IBOutlet var cellContentView: UIView!
    
    var gradientLayer : CAGradientLayer!
    var startLocations : [NSNumber] = [-1.0,-0.5, 0.0]
    var endLocations : [NSNumber] = [1.0,1.5, 2.0]
    var gradientBackgroundColor : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    var gradientMovingColor : CGColor = UIColor(white: 0.75, alpha: 1.0).cgColor
    var movingAnimationDuration : CFTimeInterval = 0.8
    var delayBetweenAnimationLoops : CFTimeInterval = 1.0
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("ImageViewWithTitleTableViewCell", owner: self, options: nil)
        addSubview(cellContentView)
        cellContentView.frame = self.bounds
        cellContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [UIColor.green.cgColor, UIColor.blue.cgColor]
        
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        gradientLayer.locations = self.startLocations
        
        let animation = CABasicAnimation(keyPath: "fadingImage")
        animation.fromValue = self.startLocations
        animation.toValue = self.endLocations
        animation.duration = 0.6
        animation.repeatCount = .infinity
        
        self.gradientLayer.add(animation, forKey: animation.keyPath)
        
        self.gradientLayer.colors = [
           self.gradientBackgroundColor,
           self.gradientMovingColor,
           self.gradientBackgroundColor
        ]
    }
    
    func setUpImageView(with image: UIImage) {
        thumbnailImageView.image = image
        stopAnimating()
    }
    
    func animate(){
        gradientLayer.frame = self.thumbnailImageView.bounds
        thumbnailImageView.layer.addSublayer(self.gradientLayer)
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = self.startLocations
        animation.toValue = self.endLocations
        animation.duration = self.movingAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = self.movingAnimationDuration + self.delayBetweenAnimationLoops
        animationGroup.animations = [animation]
        animationGroup.repeatCount = .infinity
        self.gradientLayer.add(animationGroup, forKey: animation.keyPath)
    }
    
    func stopAnimating() {
        self.gradientLayer.removeAllAnimations()
        self.gradientLayer.removeFromSuperlayer()
    }
}

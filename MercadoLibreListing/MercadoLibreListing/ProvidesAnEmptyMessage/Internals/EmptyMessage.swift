//
//  EmptyMessage.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/13/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol EmptyMessageProtocol {
    func setMessage(with: String, and: UIImage?)
}

class EmptyMessage: UIView, EmptyMessageProtocol{
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("EmptyMessage", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    ///only admits images from sf symbols.
    func setMessage(with message: String, and image: UIImage? = nil) {
        //attributed title
        messageLabel.attributedText = attributedTitle(with: message)
        messageLabel.textAlignment = .center
        
        if let image = image {
            setImage(with: image)
        }
    }
    
    private func setImage(with image: UIImage){
        let config = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize, weight: .medium, scale: .small)
        iconImageView.image = image
        iconImageView.preferredSymbolConfiguration = config
        iconImageView.tintColor = UIColor.lightGray
    }
    
    
    private func attributedTitle(with text: String) -> NSAttributedString{
        let mutuableAttString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.11
        
        let attributes = [NSAttributedString.Key.kern: 0.41,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.foregroundColor: UIColor(named: "Text")!,
                          NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 17)!] as [NSAttributedString.Key : Any]
        
        mutuableAttString.addAttributes(attributes, range: NSRange(location: 0,
                                                                   length: text.count))
        return mutuableAttString
    }
    
    func toggle(on: Bool){
        messageLabel.isHidden = !on
        iconImageView.isHidden = !on
    }
}

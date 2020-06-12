//
//  ProductListPresenter.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class ListOfProductsPrensenter: ListOfProductsPrensenterProtocol{
    var modelList: ListOfProductsPrensenterModelProtocol
    var presentableView: ListsOfViewDataProducts
    
    init(with prensentableModel: ListOfProductsPrensenterModelProtocol,
         and presentableView: ListsOfViewDataProducts){
        self.modelList = prensentableModel
        self.presentableView = presentableView
    }
    
    func prepareListOfProductsViewData(with dataProducts: [ProductProtocol]) {
        //PREPARE VIEW DATA
        DispatchQueue.global().async { [weak self] in
            //create an array of ViewDataProductProtocol
            var viewDataProducts = [ProductCellViewData]()
    
            for (index, productData) in dataProducts.enumerated(){
                //search for image if needed
                self?.getImage(from: productData, at: index)
                
                //prepare an attributed string.
                let viewDataTile = ListOfProductsPrensenter.attributedTitle(with: productData.title)
                
                let viewData = ProductCellViewData(imageThumnail: nil,
                                                   attributeTitleProduct: viewDataTile)
                viewDataProducts.append(viewData)
            }
            DispatchQueue.main.async {
                //present it to the view.
                self?.presentableView.prensent(viewData: viewDataProducts)
            }
        }
    }
    
    func getImage(from productData: ProductProtocol, at: Int) {
        DispatchQueue.global().async { [weak self] in
            let viewDataImage: UIImage? = ListOfProductsPrensenter.getImage(from: productData.imagetThumbnailUrl)
            if let viewDataImage = viewDataImage {
                DispatchQueue.main.async {
                    self?.presentableView.present(imageViewData: viewDataImage, at: at)
                }
            }
        }
    }
    
    fileprivate static func getImage(from url: URL?) -> UIImage? {
        if let urlThumnailProduct = url {
            return DownSamplerMethods.downsample(imageAt: urlThumnailProduct,
                                                  to: CGSize(width: 100.0, height: 100.0),
                                                  scale: 3)
        } else {
            return nil
        }
    }
    
    fileprivate static func attributedTitle(with text: String) -> NSAttributedString{
        let mutuableAttString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.11
        
        let attributes = [NSAttributedString.Key.kern: 0.41,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.foregroundColor: UIColor.black.cgColor,
                          NSAttributedString.Key.font: UIFont(name: "DINAlternate-Bold", size: 17)!] as [NSAttributedString.Key : Any]
        
        mutuableAttString.addAttributes(attributes, range: NSRange(location: 0,
                                                                   length: text.count))
        return mutuableAttString
    }
}

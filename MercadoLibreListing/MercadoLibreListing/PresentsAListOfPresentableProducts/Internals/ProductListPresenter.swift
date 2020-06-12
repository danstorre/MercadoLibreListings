//
//  ProductListPresenter.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit


//OBSERVERS
protocol IObserver: class {
    func willChange()
    func didChange()
}

protocol Observable: class {
    var observer: IObserver? { get set }
}

//PRODUCT VIEW DATA PROTOCOL
protocol ViewDataProductProtocol {
    var imageThumnail: UIImage? {get set}
    var attributeTitleProduct: NSAttributedString? {get set}
}

//PRODUCT LIST VIEW PROTOCOL
protocol ListsOfViewProducts {
    var arrayOfViewDataProducts: [ViewDataProductProtocol] { get set }
    func prensent(viewData: [ViewDataProductProtocol])
}

//MODEL PRODUCT PRESENTER PROTOCOL
protocol ListOfProductsPrensenterModelProtocol {
    func getArrayOfProducts(with: ListOfProductsPrensenterProtocol)
}

//PRODUCT LIST PRESENTER PROTOCOL
protocol ListOfProductsPrensenterProtocol {
    func setArrayOfProducts(with: [ProductProtocol])
}

struct ProductCellViewData: ViewDataProductProtocol {
    var imageThumnail: UIImage?
    var attributeTitleProduct: NSAttributedString?
}

class ListOfProductsPrensenter: ListOfProductsPrensenterProtocol{
    var modelList: ListOfProductsPrensenterModelProtocol
    var presentableView: ListsOfViewProducts
    
    init(with prensentableModel: ListOfProductsPrensenterModelProtocol,
         and presentableView: ListsOfViewProducts){
        self.modelList = prensentableModel
        self.presentableView = presentableView
    }
    
    func setArrayOfProducts(with dataProducts: [ProductProtocol]) {
        //PREPARE VIEW DATA
        DispatchQueue.global().async { [weak self] in
            //create an array of ViewDataProductProtocol
            var viewDataProducts = [ProductCellViewData]()
            for productData in dataProducts{
                //search for image if needed
                let viewDataImage: UIImage? = ListOfProductsPrensenter.getImage(from: productData.imagetThumbnailUrl)
                
                //prepare an attributed string.
                let viewDataTile = ListOfProductsPrensenter.attributedTitle(with: productData.title)
                
                let viewData = ProductCellViewData(imageThumnail: viewDataImage,
                                                   attributeTitleProduct: viewDataTile)
                viewDataProducts.append(viewData)
            }
            DispatchQueue.main.async {
                //present it to the view.
                self?.presentableView.prensent(viewData: viewDataProducts)
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

extension ListOfProductsPrensenter: IObserver {
    func willChange() {
        modelList.getArrayOfProducts(with: self)
    }
    
    func didChange() {
        // do some work after data model has finished changing
    }
}


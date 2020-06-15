//
//  DetailScreenViewController.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class DetailScreenViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleItemLabel: UILabel!
    
    var titleItem: String!
    var imageOfItem: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleItemLabel.text = titleItem
        itemImageView.image = imageOfItem
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

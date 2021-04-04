//
//  ProductViewController.swift
//  GoodAsOldPhones_01
//
//  Created by 태로고침 on 2021/04/04.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var products: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productNameLabel.text = products?.cellImageName
        if let imageName = products?.fullscreenImageName {
            productImageView.image = UIImage(named: imageName)
        }
    }
}

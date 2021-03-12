//
//  FullPhotoViewController.swift
//  UPAX
//
//  Created by Raúl Jiménez on 12/03/21.
//

import UIKit

class FullPhotoViewController: UIViewController {

    var foto = UIImage()
    @IBOutlet var FotoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FotoImageView.image = foto
    }
}

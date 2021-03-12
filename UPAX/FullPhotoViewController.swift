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

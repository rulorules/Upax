//
//  FullPhotoViewController.swift
//  UPAX
//
//  Created by Raúl Jiménez on 12/03/21.
//

import UIKit
import Firebase

class FullPhotoViewController: UIViewController {

    var rootref = Database.database().reference()
    var foto = UIImage()
    
    @IBOutlet var FotoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootref.child("color").observe(DataEventType.value, with: { (snapshot) in
            let nuevoColor = snapshot.value as? String  ?? ""
            self.view.backgroundColor = Funciones.hexStringToUIColor(hex: nuevoColor)
        })
        
        FotoImageView.image = foto
    }
    
}

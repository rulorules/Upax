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
            self.view.backgroundColor = self.hexStringToUIColor(hex: nuevoColor)
        })
        
        FotoImageView.image = foto
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

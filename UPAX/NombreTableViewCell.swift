//
//  NombreTableViewCell.swift
//  UPAX
//
//  Created by Raúl Jiménez on 11/03/21.
//

import UIKit

class NombreTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet var NombreTextField: UITextField!
    static let id = "NombreTableViewCell"
    
    static func nib() -> UINib {
            return UINib(nibName: "NombreTableViewCell", bundle: nil)
        }
    
    public func inicia(){
            NombreTextField.delegate = self
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
     }  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

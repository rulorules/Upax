//
//  SelfieTableViewCell.swift
//  UPAX
//
//  Created by Raúl Jiménez on 11/03/21.
//

import UIKit

class SelfieTableViewCell: UITableViewCell {

    @IBOutlet var PreviewImageView: UIImageView!
    @IBOutlet var PreviewLabel: UILabel!
    
    static let id = "SelfieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SelfieTableViewCell", bundle: nil)
    }
    
    public func inicia(with imageName: String,labelName: String){
        PreviewImageView.image = UIImage(named: imageName)
        PreviewLabel.text = labelName
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

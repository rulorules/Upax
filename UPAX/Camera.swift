//
//  Camera.swift
//  UPAX
//
//  Created by Raúl Jiménez on 12/03/21.
//

import Foundation
import UIKit

class Camera:  UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    var imagPickUp : UIImagePickerController!
    var imageV : UIImageView!
    
    func imageAndVideos()-> UIImagePickerController{
        if(imagPickUp == nil){
            imagPickUp = UIImagePickerController()
            imagPickUp.delegate = self
            imagPickUp.allowsEditing = false
        }
        return imagPickUp
    }
    
    func tomaFoto(){
        
        imagPickUp = self.imageAndVideos()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            imagPickUp.mediaTypes = ["public.image"]
            imagPickUp.sourceType = UIImagePickerController.SourceType.camera;
            self.present(imagPickUp, animated: true, completion: nil)
            
        }
        else{
            //UIAlertController(title: "iOSDevCenter", message: "No Camera available.", preferredStyle: .alert).show(self, sender: nil);
            //print("no hay camara disponible")
        }
        
        //print("Foto tomada")
    }
}

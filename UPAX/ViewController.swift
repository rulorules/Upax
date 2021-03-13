//
//  ViewController.swift
//  UPAX
//
//  Created by Raúl Jiménez on 11/03/21.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    var imagPickUp : UIImagePickerController!
    var image : UIImage!
    var docRef: DocumentReference!
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NombreTableViewCell.nib(), forCellReuseIdentifier: NombreTableViewCell.id)
        table.register(SelfieTableViewCell.nib(), forCellReuseIdentifier: SelfieTableViewCell.id)
        return table
    }()
    
    private let btnEnviar: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.gray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("Enviar", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(EnviarAFireBase), for: .touchUpInside)
        return btn
    }()
    
    @objc func EnviarAFireBase(sender: UIButton!) {
        print("Enviar datos a Firebase")
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NombreTableViewCell
        guard let name = cell.NombreTextField.text, !name.isEmpty else {return}
    //TODO foto
        print(name)
        let dataToSave: [String: Any] = ["nombre": name]
        docRef.setData(dataToSave) {(error) in
            if let error = error {
                print("Error: "+(error.localizedDescription))
            }else{
                print("Datos guardados a FileStore")
            }
        }
        
     }
    
    private let formContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        docRef = Firestore.firestore().document("Usuarios/datos")
        
        
        /**Boton imdb**************/
        self.view.addSubview(btnEnviar)
        btnEnviar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        btnEnviar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        btnEnviar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        /*************************/
        
        /**Contenedor*************/
        view.addSubview(formContainerView)
        formContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        formContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        if #available(iOS 11.0, *) {
            formContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        } else {
            formContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        }
        formContainerView.bottomAnchor.constraint(equalTo: btnEnviar.topAnchor, constant: -10).isActive = true
        //formContainerView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.55).isActive = true
        /*************************/
        
        /**Tabla*************/
        formContainerView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        /*************************/
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    		
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NombreTableViewCell.id, for: indexPath) as! NombreTableViewCell
            cell.inicia()
            //cell.textLabel?.text = "inserta tu nombre"
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SelfieTableViewCell.id,for: indexPath) as! SelfieTableViewCell
            cell.inicia(with: "Selfie", labelName: "Selfie")
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SelfieTableViewCell.id,for: indexPath) as! SelfieTableViewCell
        cell.inicia(with: "Chart", labelName: "Gráfica")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return formContainerView.bounds.height/3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 1){
            let alert = UIAlertController(title: "¿Qué desea hacer?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Visualizar", style: .default, handler: { action in
                self.performSegue(withIdentifier: "fotoID", sender: indexPath)
            }))
            alert.addAction(UIAlertAction(title: "Tomar/Retomar foto", style: .default, handler: { action in
                self.imagPickUp = self.imageAndVideos()
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                    self.imagPickUp.mediaTypes = ["public.image"]
                    self.imagPickUp.sourceType = UIImagePickerController.SourceType.camera;
                    self.imagPickUp.cameraDevice = .front;
                    self.imagPickUp.delegate = self
                    self.present(self.imagPickUp, animated: true, completion: nil)
                }
                else{
                    UIAlertController(title: "No se encontró la cámara", message: "No se pudo establecer comunicación con la cámara.", preferredStyle: .alert).show(self, sender: nil);
                }
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else if(indexPath.row == 2){
            performSegue(withIdentifier: "graphID", sender: indexPath)
        }
            
    }
    
    func imageAndVideos()-> UIImagePickerController{
        if(imagPickUp == nil){
            imagPickUp = UIImagePickerController()
            imagPickUp.delegate = self
            imagPickUp.allowsEditing = false
        }
        return imagPickUp
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SelfieTableViewCell
        cell.PreviewImageView.image = image
        
        imagPickUp.dismiss(animated: true, completion: { () -> Void in
        })

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagPickUp.dismiss(animated: true, completion: { () -> Void in
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            let vc = segue.destination as? FullPhotoViewController
            vc?.foto = image
        }
 
    
}


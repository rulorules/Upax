//
//  GraphViewController.swift
//  UPAX
//
//  Created by Raúl Jiménez on 12/03/21.
//

import UIKit

class GraphViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //https://us-central1-bibliotecadecontenido.cloudfunctions.net/helloWorld
               
               //Petición web
               var components = URLComponents()
               components.scheme = "https"
               components.host = "us-central1-bibliotecadecontenido.cloudfunctions.net"
               components.path = "/helloWorld"
               var req = URLRequest(url: components.url!)
               req.httpMethod = "GET"
               let session = URLSession.shared
               let task = session.dataTask(with: req, completionHandler: { (data, response, error) in
                if data != nil{
                   //let resultado = (NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                   //print(resultado!)
                   guard error == nil else {
                       print("ERROR: \(error!)")
                       return
                   }
                   guard data != nil else {
                       print("Empty response")
                       return
                   }
                   let resp = response as! HTTPURLResponse
                   if resp.statusCode == 200 {
                       DispatchQueue.main.async {
                        let datos = try? JSONDecoder().decode(TopGraphStruct.self, from: data!)
                        //print(datos!)
                        
                        for i in datos!.questions {
                            print(i.text)
                            for j in i.chartData {
                                print("color"+","+j.text+","+String(j.percetnage))
                            }
                        }
                       }
                       
                   } else {
                       print("Unsuccesful request: \(resp)")
                   }
                }else{
                    print("Error")
                }
               })
               task.resume()
               dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    

}

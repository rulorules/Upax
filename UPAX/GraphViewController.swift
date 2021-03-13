//
//  GraphViewController.swift
//  UPAX
//
//  Created by Raúl Jiménez on 12/03/21.
//

import UIKit
import Charts

class GraphViewController: UIViewController, UITableViewDelegate, ChartViewDelegate {
    
    var pieChart = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
               
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        
        var entries = [PieChartDataEntry]()
        for x in 0..<10 {
            entries.append(PieChartDataEntry(value: Double(x), data: x))
        }
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        
    }
    

}

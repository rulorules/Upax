//
//  GraphViewController.swift
//  UPAX
//
//  Created by Raúl Jiménez on 12/03/21.
//

import UIKit
import Charts

class GraphViewController: UIViewController, UITableViewDelegate, ChartViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var GraphTableView: UITableView!
    var datos = TopGraphStruct(colors: [""], questions:[])
    var pieCharts = [PieChartView()]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.datos.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pieChart = PieChartView()
        pieCharts.append(pieChart)
        pieCharts[indexPath.row].delegate = self
        let cell = tableView.dequeueReusableCell(withIdentifier: "graphCell", for: indexPath)
        
        
        pieCharts[indexPath.row].frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        pieCharts[indexPath.row].center = cell.contentView.center
        
        cell.contentView.addSubview(pieCharts[indexPath.row])
        
        var entries = [PieChartDataEntry]()

        for j in self.datos.questions[indexPath.row].chartData {
                //Falta color
                entries.append(PieChartDataEntry(value: Double(j.percetnage), label: j.text))
            }
        
        let set = PieChartDataSet(entries: entries, label: self.datos.questions[indexPath.row].text)
        set.colors = ChartColorTemplates.joyful()
        let data = PieChartData(dataSet: set)
        pieCharts[indexPath.row].data = data
        

        return cell
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        GraphTableView.delegate = self
        GraphTableView.dataSource = self
        GraphTableView.rowHeight = 400

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
                        self.datos = try! JSONDecoder().decode(TopGraphStruct.self, from: data!)
                        //print(datos!)
                        
                        /*for i in self.datos.questions {
                            print(i.text)
                            for j in i.chartData {
                                print("color"+","+j.text+","+String(j.percetnage))
                            }
                        }*/
                        self.GraphTableView.reloadData()
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
    
    

}

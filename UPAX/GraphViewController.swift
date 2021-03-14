//
//  GraphViewController.swift
//  UPAX
//
//  Created by Raúl Jiménez on 12/03/21.
//

import UIKit
import Charts
import Firebase

class GraphViewController: UIViewController, UITableViewDelegate, ChartViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var GraphTableView: UITableView!
    var datos = TopGraphStruct(colors: [""], questions:[])
    var pieCharts = [PieChartView()]
    var rootref = Database.database().reference()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.datos.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let pieChart = PieChartView()
        //pieCharts.append(pieChart)
        
        
        pieCharts[indexPath.row].delegate = self
        var circleColors: [NSUIColor] = []
        let cell = tableView.dequeueReusableCell(withIdentifier: "graphCell", for: indexPath)
        
        for view in cell.subviews  {
                if let gra = view as? PieChartView {
                    gra.removeFromSuperview()
                }
            }
        
        pieCharts[indexPath.row].frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 250)
        //pieCharts[indexPath.row].center = cell.center
        
        cell.contentView.addSubview(pieCharts[indexPath.row])
        
        
        var entries = [PieChartDataEntry]()
        var index = 0
        
        
        for j in self.datos.questions[indexPath.row].chartData {
            //print(self.datos.colors[index])
            circleColors.append(Funciones.hexStringToUIColor(hex: self.datos.colors[index]) )
                entries.append(PieChartDataEntry(value: Double(j.percetnage), label: j.text))
                index+=1
            }
        
        let set = PieChartDataSet(entries: entries, label: self.datos.questions[indexPath.row].text)

            
        //circleColors.append(hexStringToUIColor(hex: "#ffffd3"))
        set.colors = circleColors
        let data = PieChartData(dataSet: set)
        pieCharts[indexPath.row].data = data
        
        return cell
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        rootref.child("color").observe(DataEventType.value, with: { (snapshot) in
            let nuevoColor = snapshot.value as? String  ?? ""
            self.view.backgroundColor = Funciones.hexStringToUIColor(hex: nuevoColor)
        })
        
        GraphTableView.delegate = self
        GraphTableView.dataSource = self
        GraphTableView.rowHeight = 250

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
                        
                        for i in self.datos.questions {
                            let pieChart = PieChartView()
                            self.pieCharts.append(pieChart)
                            /*for j in i.chartData {
                                print("color"+","+j.text+","+String(j.percetnage))
                            }*/
                        }
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



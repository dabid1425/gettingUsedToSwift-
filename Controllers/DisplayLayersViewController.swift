//
//  DisplayLayersViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 7/25/22.
//

import UIKit

class DisplayLayersViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var drawingLayerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawingLayerTableView.dataSource = self
        drawingLayerTableView.register(UINib(nibName: "DrawingTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    
    var layers: [DrawingTableViewCell] = []
    let cellIdentifier:String = "DrawingLayerCell"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        layers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let layer = layers[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DrawingTableViewCell
        cell.layerName!.text = layer.layerName?.text
        cell.canvasView = layer.canvasView
        return cell
    }
    

   
}

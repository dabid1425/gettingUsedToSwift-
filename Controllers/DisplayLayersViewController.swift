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
    var originalScreenWidth:CGFloat = 0.0
    var originalScreenHeight:CGFloat = 0.0
    let cellIdentifier:String = "DrawingLayerCell"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        layers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentLayer = layers[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DrawingTableViewCell
        let width = cell.layerView.frame.size.width
        let height = cell.layerView.frame.size.height
        let newLayer = CanvasView(frame: CGRect(x: 0, y: 0, width: width, height: height), widthScale: width / originalScreenWidth, heightScale: height / originalScreenHeight)
        if (currentLayer.layerView != nil){
            newLayer.lines = currentLayer.layerView.lines
            cell.layerView = newLayer
            cell.layerName!.text = "Layer"
        }
        
        return cell
    }
    
    
    
}

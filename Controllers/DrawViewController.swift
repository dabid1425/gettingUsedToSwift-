//
//  ViewController.swift
//  DrawingApp
//
//  Created by Ranosys on 19/09/19.
//  Copyright © 2019 Ranosys. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet var featuresView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var colorSelected: UIColor = .black
    var layers:[CanvasView] = []
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    var pencilStrokeWidth: CGFloat = 1.0
    var pencilStrokeOpacity: CGFloat = 1.0
    var currentLayer:Int = 0
    var eraserStrokeWidth: CGFloat = 1.0
    var eraserStrokeOpacity: CGFloat = 1.0
    var blurView = UIVisualEffectView()
    var currentView: CanvasView!
    var kHeight: CGFloat = 130 // Total height of feature view
    var animationTime = 0.35
    var currenlyMovingPoint: Bool = false
    var panRecognizer: UIPanGestureRecognizer!
    var colorsArray: [UIColor] = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.4059419876, blue: 0.2455089305, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 1, green: 0.4059419876, blue: 0.2455089305, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3823936913, green: 0.8900789089, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.4528176247, blue: 0.4432695911, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        opacitySlider.tintColor = .red
        featuresView.transform = CGAffineTransform(translationX: 0, y: kHeight - (kHeight - 80))
        currentView = canvasView
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureMovement))
        currentView.addGestureRecognizer(panRecognizer)
        layers.append(currentView)
    }
    @objc private func panGestureMovement(_ sender: UIPanGestureRecognizer) {
        let currentPanPoint = sender.location(in: view)
        switch sender.state{
        case .began:
            currenlyMovingPoint = true
            currentView.newUserLine()
        case .changed:
            currentView.userMovingLine(pointToBeAdded: currentPanPoint)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                if (self.currenlyMovingPoint && currentPanPoint.equalTo(sender.location(in: self.view))){
                    self.currentView.determineShape()
                }
            }
        case .ended:
            self.currenlyMovingPoint = false
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    @IBAction func viewLayersButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "DrawingLayerCell", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DrawingLayerCell"{
            if let secondViewController = segue.destination as? DisplayLayersViewController {
                let width = self.canvasView.frame.size.width
                let height = self.canvasView.frame.size.height
                secondViewController.originalScreenWidth = width
                secondViewController.originalScreenHeight = height
                for layerIndex in 0..<layers.count {
                    let drawingCellInfo = DrawingTableViewCell()
                    drawingCellInfo.layerView = layers[layerIndex]
                    drawingCellInfo.layerName?.text = "Layer \(layerIndex + 1)"                
                    secondViewController.layers.append(drawingCellInfo)

                }
            }
        }
            
    }
    
    @IBAction func addLayerButton(_ sender: UIButton) {
        let myNewView=CanvasView()
        
        // Change UIView background colour
        myNewView.backgroundColor = .clear
        myNewView.isOpaque=false
        
        // Add rounded corners to UIView
        myNewView.layer.cornerRadius=25
        
        // Add border to UIView
        myNewView.layer.borderWidth=2
        
        // Change UIView Border Color to Red
        myNewView.layer.borderColor = UIColor.red.cgColor
        currentView.removeGestureRecognizer(panRecognizer)
        currentView = myNewView
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureMovement))
        currentView.addGestureRecognizer(panRecognizer)
        setCanvasValues()
        self.view.insertSubview(currentView, belowSubview: featuresView)
        layers.append(currentView)
    }
    
    func setCanvasValues(){
        currentView.pencilStrokeWidth = currentView.usingEraser ? eraserStrokeWidth : pencilStrokeWidth
        currentView.pencilStrokeOpacity = currentView.usingEraser ? eraserStrokeOpacity : pencilStrokeOpacity
        currentView.strokeColor = currentView.usingEraser ? .white : colorSelected
        widthSlider.value = Float(canvasView.pencilStrokeWidth)
        opacitySlider.value = Float(canvasView.pencilStrokeOpacity)
    }
    
    @IBAction func onClickBrushWidth(_ sender: UISlider) {
        if (currentView.usingEraser){
            eraserStrokeWidth = CGFloat(sender.value)
            
        } else {
            pencilStrokeWidth = CGFloat(sender.value)
        }
        currentView.pencilStrokeWidth = currentView.usingEraser ? eraserStrokeWidth : pencilStrokeWidth
    }
    
    @IBAction func onClickOpacity(_ sender: UISlider) {
        if (currentView.usingEraser){
            eraserStrokeOpacity = CGFloat(sender.value)
            
        } else {
            pencilStrokeOpacity = CGFloat(sender.value)
        }
        currentView.pencilStrokeOpacity = currentView.usingEraser ? eraserStrokeOpacity : pencilStrokeOpacity
    }
    
    @IBAction func onClickUndo(_ sender: Any) {
        currentView.undoDraw()
    }
    @IBAction func changeTip(_ sender: UIButton) {
        if (sender.tag == 1){
            if (currentView.usingEraser){
                currentView.setUsingEraser()
            }
        } else {
            if(!currentView.usingEraser){
                currentView.setUsingEraser()
            }
        }
        setCanvasValues()
        
    }
    @IBAction func onClickSave(_ sender: Any) {
        let image = currentView.takeScreenshot()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextType:)), nil)
    }
    
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextType: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let view = cell.viewWithTag(111) {
            view.layer.cornerRadius = 3
            view.backgroundColor = colorsArray[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colorSelected = colorsArray[indexPath.row]
        if (currentView.usingEraser) {
            currentView.setUsingEraser()
        }
        currentView.strokeColor = colorSelected
    }
}

extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

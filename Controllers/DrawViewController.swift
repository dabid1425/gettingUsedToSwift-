//
//  ViewController.swift
//  DrawingApp
//
//  Created by Ranosys on 19/09/19.
//  Copyright © 2019 Ranosys. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet var featuresView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var usingEraser: Bool = false
    var colorSelected: UIColor = .black
    var layers:[[CanvasView]] = []
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
    
    var colorsArray: [UIColor] = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.4059419876, blue: 0.2455089305, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 1, green: 0.4059419876, blue: 0.2455089305, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3823936913, green: 0.8900789089, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.4528176247, blue: 0.4432695911, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        opacitySlider.tintColor = .red
        featuresView.transform = CGAffineTransform(translationX: 0, y: kHeight - (kHeight - 80))
        currentView = canvasView
    }
    
    
    @IBAction func viewLayersButton(_ sender: UIButton) {
        
    }
    @IBAction func addLayerButton(_ sender: UIButton) {
        let width = self.canvasView.frame.size.width
        let height = self.canvasView.frame.size.height
        let myNewView=CanvasView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Change UIView background colour
        myNewView.backgroundColor = .clear
        myNewView.isOpaque=false
        
        // Add rounded corners to UIView
        myNewView.layer.cornerRadius=25
        
        // Add border to UIView
        myNewView.layer.borderWidth=2
        
        // Change UIView Border Color to Red
        myNewView.layer.borderColor = UIColor.red.cgColor
        currentView = myNewView
        setCanvasValues()
        self.view.insertSubview(myNewView, belowSubview: featuresView)
    }
    
    func setCanvasValues(){
        currentView.pencilStrokeWidth = usingEraser ? eraserStrokeWidth : pencilStrokeWidth
        currentView.pencilStrokeOpacity = usingEraser ? eraserStrokeOpacity : pencilStrokeOpacity
        currentView.strokeColor = usingEraser ? .white : colorSelected
        widthSlider.value = Float(canvasView.pencilStrokeWidth)
        opacitySlider.value = Float(canvasView.pencilStrokeOpacity)
    }
    
    @IBAction func onClickBrushWidth(_ sender: UISlider) {
        if (usingEraser){
            eraserStrokeWidth = CGFloat(sender.value)
            
        } else {
            pencilStrokeWidth = CGFloat(sender.value)
        }
        currentView.pencilStrokeWidth = usingEraser ? eraserStrokeWidth : pencilStrokeWidth
    }
    
    @IBAction func onClickOpacity(_ sender: UISlider) {
        if (usingEraser){
            eraserStrokeOpacity = CGFloat(sender.value)
            
        } else {
            pencilStrokeOpacity = CGFloat(sender.value)
        }
        currentView.pencilStrokeOpacity = usingEraser ? eraserStrokeOpacity : pencilStrokeOpacity
    }
    
    @IBAction func onClickUndo(_ sender: Any) {
        currentView.undoDraw()
    }
    @IBAction func changeTip(_ sender: UIButton) {
        if (sender.tag == 1){
            if (usingEraser){
                self.usingEraser = false
            }
        } else {
            if(!usingEraser){
                self.usingEraser = true
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
        if (usingEraser) {
            self.usingEraser = false
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

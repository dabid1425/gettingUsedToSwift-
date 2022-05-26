//
//  QRCodeGeneratorViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 4/11/21.
//

import UIKit
import UIKit
import CoreImage

class QRCodeGeneratorViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        imageView.isUserInteractionEnabled = true // UIImageView is(was?) the only UIView class this defaults to false
        
        
        self.textView.delegate = self
        registerForKeyboardNotifications()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(shareImage))
        self.imageView.addGestureRecognizer(longPress)

        
        
        refreshQRCode()
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
               return false
           }
           return true
       }
    
    
    func textViewDidChange(_ textView: UITextView) {
        refreshQRCode()
    }
    
    // MARK: - Generate QR Code
    
    func refreshQRCode() {
        let text:String = self.textView.text
        
        // Generate the image
        guard let qrCode:CIImage = createQRCodeForString(text) else {
            print("Failed to generate QRCode")
            self.imageView.image = nil
            return
        }
        
        // Rescale to fit the view (otherwise it is only something like 100px)
        let viewWidth = self.imageView.bounds.size.width;
        let scale = viewWidth/qrCode.extent.size.width;
        let scaledImage = qrCode.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        // Display
        self.imageView.image = UIImage(ciImage: scaledImage)
    }
    
    
    /// Generate a CoreImage image for the text passed in.
    /// This string is converted to ISOLatin1 string encoding, not the usual UTF8.
    /// Then the resulting binary data is past as the input to a CIFilter which makes the QRCode for us
    /// - Parameter text: The text to turn into a QRCode
    func createQRCodeForString(_ text: String) -> CIImage?{
        let data = text.data(using: .isoLatin1)
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        // Input text
        qrFilter?.setValue(data, forKey: "inputMessage")
        let correctionLevel = "L"
        qrFilter?.setValue(correctionLevel, forKey: "inputCorrectionLevel")
        
        return qrFilter?.outputImage
    }
    
    // MARK: Share Image
    
    @objc func shareImage() {
        guard let image = self.imageView.image else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [ sharableImage(image) ], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.imageView // so that iPads won't crash
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    // Lots of the share extensions don't seem to handle UIImage's originating from CoreImage images properly
    // Even though it shouldn't be needed, re-rendering it seems to help reliablity of some sharing options
    func sharableImage(_ image: UIImage) -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: image.size, format: image.imageRendererFormat)
        let img = renderer.image { ctx in
            image.draw(at: CGPoint.zero)
        }
        return img
    }
    
    
    
    
    
    // MARK: - Keyboard Handling
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ aNotification: NSNotification) {
        let info = aNotification.userInfo!
        let kbSize:CGSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        var aRect:CGRect = self.view.frame
        aRect.size.height -= kbSize.height
        if (!aRect.contains(self.textView.frame.origin)) {
            let scrollPoint:CGPoint = CGPoint(x: 0, y: self.textView.frame.origin.y-kbSize.height)
            self.scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    @objc func keyboardWillBeHidden(_ aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }
}

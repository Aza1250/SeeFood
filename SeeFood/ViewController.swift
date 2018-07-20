//
//  ViewController.swift
//  SeeFood
//
//  Created by Aziz Zaynutdinov on 7/16/18.
//  Copyright © 2018 Aziz Zaynutdinov. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let API_KEY: String = "vMAR1awvUidlgWlK5flJeXonmcIZIwrbGobpaYY-BaHa"
    let version: String = "2018-07-19"
    var classificationArray: [String] = []

    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: API_KEY)
            
            let imageData = UIImageJPEGRepresentation(image, 0.01)
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURL = documentsURL.appendingPathComponent("tempImage.jpg")
            
            try? imageData?.write(to: fileURL)
            
            visualRecognition.classify(imagesFile: fileURL) { (classifiedImages) in
                //print(classifiedImages)
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                
                self.classificationArray = []
                
                for index in 0..<classes.count {
                    self.classificationArray.append(classes[index].className)
                }
                if self.classificationArray.contains("hotdog") {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Hotdog!" //It is not a good idea to update UI while being in the background thread (inside of a closure)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not Hotdog :(" //That's why we need to get back to the main thread.
                    }
                }
            }
        }
        else {
            print("the image is nil")
        }
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    
}


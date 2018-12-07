//
//  EntryTableViewController.swift
//  Travelogue
//
//  Created by Olivia Bishop on 12/7/18.
//  Copyright © 2018 Olivia Bishop. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let dateFormatter = DateFormatter()
    let newEntryDateFormatter = DateFormatter()
    let imagePickerController = UIImagePickerController()
    
    var entry: Entry?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        newEntryDateFormatter.dateStyle = .medium
        
        if let entry = entry{
            textField.text = entry.title
            textView.text = entry.body
            if let addDate = entry.addDate {
                date.text = dateFormatter.string(from: addDate)
            }
            image = entry.image
            imageView.image = image
        } else {
            textField.text = ""
            textView.text = ""
            date.text = newEntryDateFormatter.string(from: Date(timeIntervalSinceNow: 0))
            imageView.image = nil
        }
    }
        
        
    @IBAction func choosePhoto(_ sender: Any) {
        ImageSource()
    }
    
    func ImageSource() {
        let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (alertAction) in
            self.useCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alertAction) in
            self.photoLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func useCamera() {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            alertNotifyUser(message: "This device has no camera.")
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func photoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            imagePickerController.dismiss(animated: true, completion: nil)
        }
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        image = selectedImage
        imageView.image = image
        if let entry = entry {
            entry.image = selectedImage
        }
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = textField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            alertNotifyUser(message: "Entry can not be saved without a title.")
            return
        }
        
        
        if let entry = entry {
            entry.title = title
            entry.content = textView.text
            entry.image = image
            
            
        } else {
            entry = Entry(title: title, content: textView.text, image: image)
        }
        
        
        if let entry = entry {
            do {
                let managedContext = entry.managedObjectContext
                try managedContext?.save()
            } catch {
                alertNotifyUser(message: "Entry could not be saved.")
            }
            
        } else {
            alertNotifyUser(message: "Entry could not be created.")
        }
        
        
        navigationController?.popViewController(animated: true)
    }
}
    



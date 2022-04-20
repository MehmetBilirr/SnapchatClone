//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Mehmet Bilir on 21.04.2022.
//

import UIKit
import Firebase

class UploadVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let auth = Auth.auth()
    let firestoreDB = Firestore.firestore()
    let storage = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    
    @objc func chooseImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("Media")
        
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.8) {
            
            let uuid = UUID().uuidString
            
            let imageFolder = mediaFolder.child("\(uuid).jpd")
            imageFolder.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else {
                    imageFolder.downloadURL { url, error in
                        if error != nil {
                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                        }else {
                            let imageUrl = url?.absoluteString
                            
                            self.firestoreDB.collection("Snaps").whereField("snapOwner", isEqualTo: Singleton.shared.username).getDocuments { snapshot, error in
                                
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                }else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        
                                        for document in snapshot!.documents {
                                            
                                            let documentID = document.documentID
                                            
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                let imageArrayData = ["imageUrlArray" : imageUrlArray]
                                                
                                                self.firestoreDB.collection("Snaps").document(documentID).setData(imageArrayData, merge: true) { error in
                                                    if error != nil {
                                                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                                    }else {
                                                        self.imageView.image = UIImage(named: "upload")
                                                        self.tabBarController?.selectedIndex = 0
                                                        
                                                    }
                                                }
                                            }
                                                
                                        }
                                        
                                    }else {
                                        
                                        
                                        let dataArray = ["imageUrlArray" : [imageUrl],"snapOwner":Singleton.shared.username,"date":FieldValue.serverTimestamp()] as [String:Any]
                                        
                                        self.firestoreDB.collection("Snaps").addDocument(data: dataArray) { error in
                                            if error != nil {
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                            }else {
                                                self.imageView.image = UIImage(named: "upload")
                                                self.tabBarController?.selectedIndex = 0
                                            }
                                        }
                                        
                                        
                                    }
                                }
                                
                                
                                
                            }
                            
                            
                            
                        }
                    }
                }
            }
        }
        
        
        
        
        
    }
    
    
    
    
    func makeAlert(title: String, message: String) {
             let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
             let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
             alert.addAction(okButton)
             self.present(alert, animated: true, completion: nil)
         }
    
   
}

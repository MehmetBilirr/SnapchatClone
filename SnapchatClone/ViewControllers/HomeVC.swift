//
//  HomeVC.swift
//  SnapchatClone
//
//  Created by Mehmet Bilir on 21.04.2022.
//

import UIKit
import Firebase
import SDWebImage

class HomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let firestoreDB = Firestore.firestore()
    let auth = Auth.auth()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getUser()
        getDataFirestore()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.usernameLabel.text = snapArray[indexPath.row].username
        cell.homeImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray.first!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func getUser(){
        
        
        self.firestoreDB.collection("Users").whereField("email", isEqualTo: auth.currentUser?.email).getDocuments { snaphsot, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }else {
                if snaphsot?.isEmpty == false && snaphsot != nil {
                    
                    for document in snaphsot!.documents {
                        
                        if let username = document.get("username") as? String {
                            Singleton.shared.email = (self.auth.currentUser?.email)!
                            Singleton.shared.username = username
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func getDataFirestore(){
        firestoreDB.collection("Snaps").order(by: "date").addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    
                    for document in snapshot!.documents {
                        
                        self.snapArray.removeAll(keepingCapacity: false)
                        let documentId = document.documentID
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp {
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if difference >= 24 {
                                            self.firestoreDB.collection("Snaps").document(documentId).delete { error in
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                            }
                                        }else {
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24-difference)
                                            self.snapArray.append(snap)
                                            
                                            
                                            
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    self.tableView.reloadData()
                    
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

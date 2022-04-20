//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Mehmet Bilir on 20.04.2022.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    let auth = Auth.auth()
    let firestoreDB = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func signInClicked(_ sender: Any) {
        
        if passwordText.text != "" && emailText.text != "" {
            auth.signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleId: "Error", messageId: error?.localizedDescription ?? "Error")
                }else {
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                }
            }
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" && emailText.text != "" {
        
            auth.createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleId: "Error", messageId: error?.localizedDescription ?? "Error")
                }else {
                    
                    let userArray = ["username":self.usernameText.text,"email":self.emailText.text]
                    
                    self.firestoreDB.collection("Users").addDocument(data: userArray) { error in
                        if error != nil {
                            
                            self.makeAlert(titleId: "Error", messageId: error?.localizedDescription ?? "Error")
                        }else {
                            self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                        }
                    }
                    
                }
            }
            
            
        }
        
        
        
    }
    
    func makeAlert(titleId:String,messageId:String) {
        let alert = UIAlertController(title: titleId, message: messageId, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}


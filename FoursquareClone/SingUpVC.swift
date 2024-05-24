//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Onur Anıl on 12.05.2024.
//

import UIKit
import Parse

class SingUpVC: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         //Veri Kaydetmek için bu kodu kullanıyoruz.
         //
         let parseObject = PFObject(className: "Fruits")
         parseObject["name"] = "Banana"
         parseObject["calories"] = 150
         parseObject.saveInBackground { success, error in
                 if error != nil {
                     print(error?.localizedDescription)
                 } else {
                      print("uploaded")
                 }
             }
         
        //Veri Çekmek.
        //
        let quary = PFQuery(className: "Fruits")
        //quary.whereKey("name", contains: "Apple")
        //quary.whereKey("calories", greaterThan: 120)
        quary.findObjectsInBackground { objects, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print(objects)
            }
        }
         */
        
        
        
    }
    
    //Kullanıcının oluşturduğu hesabıyla giriş yapabilmesi için.
    @IBAction func singInClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                } else {
                    //Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username / Password??")
        }
        
    }
    
    
    //Uygulamaya Kullanıcı oluşturabilmeleri için.
    @IBAction func singUpClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            
            //Kullanıcı oluşturmak için
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    //Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username / Password??")
        }
        
    }
    
    //Alert Fonksiyonumuz.
    func makeAlert(titleInput: String, messageInput: String ){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle:UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}


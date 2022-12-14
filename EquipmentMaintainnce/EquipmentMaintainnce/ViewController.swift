//
//  ViewController.swift
//  EquipmentMaintainnce
//
//  Created by 醒着像睡着 on 11/9/22.
//


import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keychain = KeyChainService().keyChain
        if keychain.get("uid") != nil {
            performSegue(withIdentifier: "segueLogin", sender: self)
        }
        txtPassword.text = ""
    }

    func addUIDToKeychain(uid: String){
        let keychain = KeyChainService().keyChain
        keychain.set(uid, forKey: "uid")
    }

    @IBAction func loginAction(_ sender: Any) {
        
        guard let email = txtEmail.text else {return}
        guard let password = txtPassword.text else {return}
        
        if email.isEmail == false {
            lblStatus.isHidden = false
            lblStatus.text = "Please enter valid email"
            return
        }
    
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if error != nil {
                strongSelf.lblStatus.isHidden = false
                strongSelf.lblStatus.text = error?.localizedDescription
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            strongSelf.addUIDToKeychain(uid: uid)

            strongSelf.performSegue(withIdentifier: "segueLogin", sender: strongSelf)
            
            
        }
    }
    
}

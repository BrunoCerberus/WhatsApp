//
//  ViewController.swift
//  Whatsapp
//
//  Created by Bruno Lopes de Mello on 25/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logar: UIButton!
    @IBOutlet weak var cadastrese: UIButton!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyBoard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailTextField {
             self.passwordTextField.becomeFirstResponder()
        } else {
            self.dismissKeyBoard()
            
            if let _email = self.emailTextField.text {
                if let _password = self.passwordTextField.text {
                    self.login(email: _email, password: _password)
                }
            }
            
        }
        return false
    }
    
    @IBAction func logarAction(_ sender: Any) {
        
        if let _email = self.emailTextField.text {
            if let _password = self.passwordTextField.text {
                self.login(email: _email, password: _password)
            }
        }
    }
    
    
    
    func login(email: String, password: String) {
        
        self.auth.signIn(withEmail: email, password: password) { (user, erro) in
            
            if erro == nil {
                
                self.performSegue(withIdentifier: "segueLogin", sender: nil)
                
            } else {
                var msg = ""
                
                if email == "" {
                    msg = "Preencha o campo email"
                } else if password == ""{
                    msg = "Preencha o campo senha"
                } else {
                    msg = "Verifique se os dados informados são corretos"
                }
                
                let alert = Alerta(_title: "Atenção", _message: msg, _controller: self)
                alert.show()
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


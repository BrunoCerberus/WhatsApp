//
//  SignUp.swift
//  Whatsapp
//
//  Created by Bruno Lopes de Mello on 25/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUp: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var criarContaButton: UIButton!
    
    var autenticacao: Auth!
    var database: Database!
    var alerta: Alerta!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.autenticacao = Auth.auth()
        self.database = Database.database()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func criarContaAction(_ sender: Any) {
        
        if let _name = self.nameTextField.text {
            if let _email = self.emailTextField.text {
                if let _pass = self.passwordTextField.text {
                    self.createAccount(_name: _name, _email: _email, _password: _pass)
                }
            }
        }
    }
    
    func createAccount(_name: String, _email: String, _password: String) {
        
        self.autenticacao.createUser(withEmail: _email, password: _password) { (user, erro) in
            
            if erro == nil {
                
                var usuario: Dictionary<String, String> = [:]
                
                usuario["nome"] = _name
                usuario["email"] = _email
                
                //Converter para base 64 email
                let chave = Base64().codificarStringBase64(texto: _email)
                
                let usuarios = self.database.reference().child("usuarios")
                usuarios.child(chave).setValue(usuario)
                
            } else {
                var msg = ""
                
                if _name == "" {
                    msg = "Preencha o campo nome"
                } else if _email == "" {
                    msg = "Preencha o campo email"
                } else if _password == "" {
                    msg = "Preencha o campo senha"
                } else {
                    msg = "Não foi possível cadastrar esse usuário"
                }
                
                self.alerta = Alerta(_title: "Atenção", _message: msg, _controller: self)
                self.alerta.show()
                
            }
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {
            self.emailTextField.becomeFirstResponder()
        } else if (textField == emailTextField) {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
            
            if let _name = self.nameTextField.text {
                if let _email = self.emailTextField.text {
                    if let _pass = self.passwordTextField.text {
                        self.createAccount(_name: _name, _email: _email, _password: _pass)
                    }
                }
            }
        }
        
        return false
    }
    
}

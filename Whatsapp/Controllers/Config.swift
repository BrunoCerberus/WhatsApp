//
//  Config.swift
//  Whatsapp
//
//  Created by Bruno Lopes de Mello on 27/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class Config: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var auth: Auth!
    var database: DatabaseReference!
    var storage: Storage!
    var imagePicker = UIImagePickerController()
    var usuario: Usuario!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
        self.database = Database.database().reference()
        self.storage = Storage.storage()
        self.imagePicker.delegate = self
        self.imagem.image = #imageLiteral(resourceName: "padrao")
        self.recuperarUsuario()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sairAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            do {
                try self.auth.signOut()
            } catch let erro {
                print(erro.localizedDescription)
            }
        }
    }
    
    @IBAction func alterarImagem(_ sender: Any) {
        
        self.imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let imageRecuperada = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imagem.image = imageRecuperada
        
        // recuperar a chave em base64 do usuario
        let chave = FirebaseUtil().recuperarChaveUsuarioLogado()
        
        // configurar o storage
        let imagens = storage.reference().child("imagens")
        
        if let imagem = UIImageJPEGRepresentation(imageRecuperada, 0.8) {
            
            // salvar dados no storage
            let nomeImagem = "\(chave).jpg"
            imagens.child("perfil").child(nomeImagem).putData(imagem, metadata: nil, completion: { (metaData, erro) in
                
                if erro == nil {
                    print("Sucesso ao fazer upload")
                } else {
                    print("Erro ao fazer upload")
                }
            })
            
            // Salvar nome da imagem no Database
            self.atualizarDadosUsuario(foto: nomeImagem)
        }
        
       
        
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func recuperarUsuario() {
        // recuperar referencia de usuarios
        let usuarios = self.database.child("usuarios")
        
        // recuperar a chave em base64 do usuario
        let chave = FirebaseUtil().recuperarChaveUsuarioLogado()
        
        let usuarioLogado = usuarios.child(chave)
        usuarioLogado.observeSingleEvent(of: .value) { (snapshot) in
            
            if let dados = snapshot.value as? NSDictionary {
                if let nome = dados["nome"] as? String {
                    if let email = dados["email"] as? String {
                        self.usuario = Usuario(nome: nome, email: email)
                        
                        self.nomeLabel.text = nome
                        self.emailLabel.text = email
                        
                        if snapshot.hasChild("foto") {
                            if let foto = dados["foto"] as? String {
                                self.usuario.foto = foto
                                
                                // configurar storage
                                let perfil = self.storage.reference().child("imagens").child("perfil")
                                let localImagem = perfil.child(foto)
                                localImagem.getMetadata(completion: { (metaData, erro) in
                                    
                                    if erro == nil {
                                        
                                        let url = metaData?.downloadURL()?.absoluteURL
                                        self.imagem.sd_setImage(with: url, completed: { (image, erro, cache, url) in
                                            
                                            if erro == nil {
                                                
                                                print("Sucesso ao carregar a imagem")
                                                
                                            } else {
                                                print("Erro ao carregar a imagem")
                                            }
                                            
                                        })
                                        
                                    } else {
                                        print("Erro ao carregar a imagem!")
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    func atualizarDadosUsuario(foto: String) {
        
        // recuperar referencia de usuarios
        let usuarios = self.database.child("usuarios")
        
        // recuperar a chave em base64 do usuario
        let chave = FirebaseUtil().recuperarChaveUsuarioLogado()
        
        let dadosUsuario = [
            "nome": self.usuario.nome,
            "email": self.usuario.email,
            "foto" : foto
        ]
        
        // salvar dados do usuario
        usuarios.child(chave).setValue(dadosUsuario)
        
    }
    
    
}

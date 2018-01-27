//
//  Usuario.swift
//  Whatsapp
//
//  Created by Bruno Lopes de Mello on 27/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

class Usuario {
    
    
    var nome: String!
    var email: String!
    var foto: String?
    
    init(nome: String, email: String) {
        
        self.nome = nome
        self.email = email
    }
}

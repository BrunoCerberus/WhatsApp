//
//  Alerta.swift
//  Whatsapp
//
//  Created by Bruno Lopes de Mello on 25/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import UIKit

class Alerta {
    
    var titulo: String!
    var mensagem: String!
    var controller: UIViewController!
    
    func show(fallBack: Bool = false) {
        
        let alert = UIAlertController(title: self.titulo, message: self.mensagem, preferredStyle: UIAlertControllerStyle.alert)
        var confirmAction: UIAlertAction!
        if fallBack {
            confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.controller.navigationController?.popViewController(animated: true)
            })
        } else {
            confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        }
    
        alert.addAction(confirmAction)
        self.controller.present(alert, animated: true, completion: nil)
        
    }
    
    init(_title: String, _message: String, _controller: UIViewController) {
        self.titulo = _title
        self.mensagem = _message
        self.controller = _controller
    }
}

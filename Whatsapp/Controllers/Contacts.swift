//
//  Contacts.swift
//  Whatsapp
//
//  Created by Bruno Lopes de Mello on 27/01/18.
//  Copyright © 2018 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import FirebaseAuth

class Contacts: UIViewController {
    
    var auth: Auth!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
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
    

}

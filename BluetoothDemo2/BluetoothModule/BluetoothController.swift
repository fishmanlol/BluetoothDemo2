//
//  BluetoothController.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class BluetoothController: UIViewController {
    
    let vm = BluetoothViewModel(store: DeviceStore())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.delegate = self
    }
}

extension BluetoothController: BluetoothViewModelDelegate {
    func displayAlert(title: String, msg: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "YES", style: .default) { (_) in
            action()
        }
        
        let NOAction = UIAlertAction(title: "NO", style: .cancel)
        
        alert.addAction(OKAction)
        alert.addAction(NOAction)
        
        present(alert, animated: true, completion: nil)
    }
}

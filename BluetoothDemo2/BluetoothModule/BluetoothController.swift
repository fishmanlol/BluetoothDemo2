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
    
    weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        vm.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
}

//private functions
extension BluetoothController {
    private func setup() {
        
        navigationItem.title = "Devices"
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(DeviceCell.self, forCellReuseIdentifier: "DeviceCell")
        self.tableView = tableView
        view.addSubview(tableView)
    }
}

//UITableView datasource
extension BluetoothController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(vm.deviceCount())
        return vm.deviceCount()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as? DeviceCell else { return UITableViewCell() }
        
        vm.config(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

//UITableView delegate
extension BluetoothController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        vm.select(at: indexPath)
    }
}

//BluetoothViewModelDelegate
extension BluetoothController: BluetoothViewModelDelegate {
    func displayAlert(title: String?, msg: String, hasCancel: Bool, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (_) in
            action()
        }
        
        alert.addAction(OKAction)
        
        if hasCancel {
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(CancelAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func reload() {
        tableView.reloadData()
    }
}

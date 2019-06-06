//
//  BluetoothViewModel.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

protocol BluetoothViewModelDelegate: class {
    func displayAlert(title: String, msg: String, action: @escaping ()->Void)
}

class BluetoothViewModel: NSObject {
    
    var command: DeviceCommand!
    var central: CBCentralManager!
    var store: DeviceStore!
    
    
    
    weak var delegate: BluetoothViewModelDelegate?
    
    init(store: DeviceStore) {
        super.init()
        
        self.command = DeviceCommand()
        self.central = CBCentralManager(delegate: self, queue: nil, options: nil)
        self.store = store
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidChanged), name: Constant.NotificationName.deviceDidChanged, object: nil)
    }
    
    @objc func deviceDidChanged(notification: Notification) {
        
        print(#function)
        
    }
    
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth state wrong")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else { return }
        
        print("Did discover: \(name)")
        
        for deviceType in Device.DeviceType.allCases {
            if name.hasPrefix(deviceType.prefix) { //our device found
                let device = Device(name: name, type: deviceType)
                
                if store.contains(device) { //Already in our history devices, connect directly
                    central.connect(peripheral, options: nil)
                    print("Already in history, connecting to \(name)")
                } else { //Not in our history devices, ask user to connect
                    delegate?.displayAlert(title: "New Device", msg: "Do you want to add this device?", action: { [weak self] in
                        self?.store.add(device)
                        central.connect(peripheral, options: nil)
                        print("Not in history, connecting to \(name)")
                    })
                }
                
                return
            }
        }
    }
    
    
    
}

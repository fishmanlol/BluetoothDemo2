//
//  BluetoothViewModel.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

protocol BluetoothViewModelDelegate: class {
    func displayAlert(title: String?, msg: String, hasCancel: Bool, action: @escaping ()->Void)
    func reload()
}

class BluetoothViewModel: NSObject {
    
    var command: DeviceCommand!
    var central: CBCentralManager!
    var store: DeviceStore!
    
    var deviceDict: [String: CBPeripheral] = [:]
    
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
        DispatchQueue.main.async {
            self.delegate?.reload()
        }
    }
    
}


//Public interface
extension BluetoothViewModel {
    func deviceCount() -> Int {
        return store.devices.count
    }
    
    func config(_ cell: DeviceCell, at indexPath: IndexPath) {
        let device = store.devices[indexPath.row]
        fill(cell, with: device)
    }
    
    func select(at indexPath: IndexPath) {
        let device = store.devices[indexPath.row]
        
        if !device.connected {
            delegate?.displayAlert(title: nil, msg: "Device is not connected", hasCancel: false, action: {})
            return
        }
        
        if device.fetching {
            delegate?.displayAlert(title: nil, msg: "Device is fething data", hasCancel: false, action: {})
        } else {
            store.devices[indexPath.row].fetching = true
        }
    }
}

//Private functions
extension BluetoothViewModel {
    
     private func fill(_ cell: DeviceCell, with device: Device) {
        
        let hasData = device.sources.contains { $0.latest != nil }
        cell.hasData = hasData
        
        cell.deviceImageView.image = device.type.image
        
        if hasData { //Max source count is 3
            
            cell.deviceNameLabel1.text = device.type.name
            cell.deviceNoLabel1.text = device.number
            
            let sourceCount = device.sources.count
            
            switch sourceCount {
            case 1:
                cell.topDisplayLabel.isHidden = true
                cell.bottomDisplayLabel.isHidden = true
                cell.middleDisplayLabel.isHidden = false
            case 2:
                cell.topDisplayLabel.isHidden = false
                cell.bottomDisplayLabel.isHidden = false
                cell.middleDisplayLabel.isHidden = true
            case 3:
                cell.topDisplayLabel.isHidden = false
                cell.bottomDisplayLabel.isHidden = false
                cell.middleDisplayLabel.isHidden = false
            default:
                cell.topDisplayLabel.isHidden = true
                cell.bottomDisplayLabel.isHidden = true
                cell.middleDisplayLabel.isHidden = true
            }
            
        } else {
            cell.deviceNameLabel2.text = device.type.name
            cell.deviceNoLabel2.text = device.number
        }
        
        if device.connected {
            cell.deviceImageView.image = device.type.image
        } else {
            cell.deviceImageView.image = device.type.disconnectedImage
        }
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
        guard let name = peripheral.name, let device = Device(name: name) else { return }

        print("Did discover: \(name)")
        stopScan()
        
        if store.contains(device) { //Already in our history devices, connect directly
            if peripheral.state == .disconnected || peripheral.state == .disconnecting {
                central.connect(peripheral, options: nil)
                if !deviceDict.contains(where: { $0.key == name }) {
                    deviceDict[name] = peripheral
                }
                print("Already in history, connecting to \(name)")
            } else {
                print("\(name) alread connected")
            }
            
        } else { //Not in our history devices, ask user to connect
            delegate?.displayAlert(title: "New Device", msg: "Do you want to add this device?", hasCancel: true, action: { [weak self] in
                self?.store.add(device)
                central.connect(peripheral, options: nil)
                self?.startScan()
                print("Not in history, connecting to \(name)")
            })
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let name = peripheral.name, let index = store.devices.firstIndex(where: { $0.name == name }) else { return }
        
        store.devices[index].connected = true
        print("Did connected: \(name)")
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        guard let name = peripheral.name, let index = store.devices.firstIndex(where: { $0.name == name }) else { return }
        
        print("Did didconnected: \(name)")
        store.devices[index].connected = false
        central.connect(peripheral, options: nil)
    }
    
    private func stopScan() {
        central.stopScan()
    }
    
    private func startScan() {
        central.scanForPeripherals(withServices: nil, options: nil)
    }
}

//
//  DeviceStore.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

struct DeviceStore {
    
    var devices: [Device] = [] {
        didSet {
            NotificationCenter.default.post(name: Constant.NotificationName.deviceDidChanged, object: nil)
            save()
        }
    }
    
    init() {
        self.devices = retrieve()
    }
    
    func contains(_ device: Device) -> Bool {
        return devices.contains(device)
    }
    
    func findDeviceIndex(peripheral: CBPeripheral) -> Int? {
        guard let name = peripheral.name, let device = Device(name: name), let index = devices.firstIndex(of: device) else {
            return nil
        }
        return index
    }
    
    mutating func add(_ device: Device) {
        if let index = devices.firstIndex(where: { $0.type == device.type }) {
            devices.remove(at: index)
            devices.insert(device, at: index)
        } else {
            devices.insert(device, at: 0)
        }
    }
    
    mutating func remove(at index: Int) {
        devices.remove(at: index)
    }
    
    private func retrieve() -> [Device] {
        let userDefaults = UserDefaults.standard
        
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: Constant.Key.devicesKey), let historyDevices = try? decoder.decode([Device].self, from: data) {//Retrieve history devices from user defaults
            return historyDevices
        } else {
            return []
        }
    }
    
    private func save() {
        let userDefaults = UserDefaults.standard
        
        if let data = try? JSONEncoder().encode(devices) {
            userDefaults.set(data, forKey: Constant.Key.devicesKey)
        } else {
            print("Encode error")
        }
    }
}

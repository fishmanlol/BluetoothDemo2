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
    
    var central: CBCentralManager!
    var store: DeviceStore!
    
    var pairs: [Device: (DeviceCommand, CBPeripheral)] = [:]
    
    var fetchingDevice: Device?
    
    weak var delegate: BluetoothViewModelDelegate?
    
    init(store: DeviceStore) {
        super.init()
    
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
    
    func remove(at indexPath: IndexPath) {
        store.remove(at: indexPath.row)
    }
    
    func restartScan() {
        stopScan()
        startScan()
    }
    
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
        
        switch device.fetchingState {
        case .fetching:
            delegate?.displayAlert(title: nil, msg: "Device is fetching data", hasCancel: false, action: {})
        default:
            store.devices[indexPath.row].fetchingState = Device.FetchingState.fetching
            fetchData(from: device)
        }
    }
}

//Private functions
extension BluetoothViewModel {
    
    private func fillSource(in device: Device, with dict: [AnyHashable: Any]) {
        switch device.type {
        case .pulseOximeter:
            guard let index = store.devices.firstIndex(where: { $0.type == .pulseOximeter }) else { return }
            
            if let pulseOximeterData = PulseOximeterData(dict: dict) {
                var oxygenSource = Source(type: .oxygen)
                var pulseSource = Source(type: .pulse)
                oxygenSource.latestTime = pulseOximeterData.recordTime
                oxygenSource.latest = pulseOximeterData.oxygenData
                pulseSource.latest = pulseOximeterData.pulseData
                pulseSource.latestTime = pulseOximeterData.recordTime
                
                store.devices[index].sources = [oxygenSource, pulseSource]
                store.devices[index].fetchingState = .succeed
            } else {
                store.devices[index].sources = []
                store.devices[index].fetchingState = .failed("Data Invalid")
            }
        case .earThermometer:
            guard let index = store.devices.firstIndex(where: { $0.type == .earThermometer }) else { return }
            
            if let earThermometerData = EarThermometerData(dict: dict) {
                var temperatureSource = Source(type: .temperature)
                temperatureSource.latest = earThermometerData.temperatureData
                temperatureSource.latestTime = earThermometerData.recordTime
                store.devices[index].sources = [temperatureSource]
                store.devices[index].fetchingState = .succeed
            } else {
                store.devices[index].sources = []
                store.devices[index].fetchingState = .failed("Data Invalid")
            }
        default: break
        }
    }
    
    private func displayText(in device: Device, at index: Int) -> String? {
        
        guard index < device.sources.count && index > -1 else { return nil }
        
        var display = ""
        
        let source = device.sources[index]
        let latest = source.latest
        
        switch source.type {
        case .oxygen:
            if let oxygenData = latest as? OxygenData {
                display = "Oxygen: \(Int(oxygenData.oxygen))%"
            }
        case .pulse:
            if let pulseData = latest as? PulseData {
                display = "Heart Rate: \(Int(pulseData.pulse))bpm"
            }
        case .temperature:
            if let temperatureData = latest as? TemperatureData {
                display = "Temperature: \(temperatureData.temperature.round(to: 1))\(temperatureData.unit.symbol)"
            }
        default: break
        }
        
        return display
    }
    
    private func fetchData(from deivce: Device) {
        guard let (command, peripheral) = pairs[deivce] else { return }
        
        fetchingDevice = deivce
        
        command.peripheral(peripheral, receiveData: 1)
    }
    
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
                cell.middleDisplayLabel.text = displayText(in: device, at: 0)
            case 2:
                cell.topDisplayLabel.isHidden = false
                cell.bottomDisplayLabel.isHidden = false
                cell.middleDisplayLabel.isHidden = true
                cell.topDisplayLabel.text = displayText(in: device, at: 0)
                cell.bottomDisplayLabel.text = displayText(in: device, at: 1)
            case 3:
                cell.topDisplayLabel.isHidden = false
                cell.bottomDisplayLabel.isHidden = false
                cell.middleDisplayLabel.isHidden = false
                cell.topDisplayLabel.text = displayText(in: device, at: 0)
                cell.middleDisplayLabel.text = displayText(in: device, at: 1)
                cell.bottomDisplayLabel.text = displayText(in: device, at: 2)
            default:
                cell.topDisplayLabel.isHidden = true
                cell.bottomDisplayLabel.isHidden = true
                cell.middleDisplayLabel.isHidden = true
            }
            
            switch device.fetchingState {
            case .fetching:
                cell.indicator1.startAnimating()
                cell.errorLabel1.isHidden = true
                cell.errorLabel2.isHidden = true
                cell.timeLabel.isHidden = true
            case .succeed:
                cell.indicator1.stopAnimating()
                cell.errorLabel1.isHidden = true
                cell.errorLabel2.isHidden = true
                cell.timeLabel.isHidden = false
            case .failed(let reason):
                cell.indicator1.stopAnimating()
                cell.errorLabel1.isHidden = false
                cell.errorLabel1.text = reason
                cell.errorLabel2.isHidden = true
                cell.timeLabel.isHidden = true
            case .idle:
                cell.indicator1.stopAnimating()
                cell.timeLabel.isHidden = true
            }
            
        } else {
            cell.deviceNameLabel2.text = device.type.name
            cell.deviceNoLabel2.text = device.number
            
            switch device.fetchingState {
            case .fetching:
                cell.indicator2.startAnimating()
                cell.errorLabel1.isHidden = true
                cell.errorLabel2.isHidden = true
            case .succeed:
                cell.indicator2.stopAnimating()
                cell.errorLabel1.isHidden = true
                cell.errorLabel2.isHidden = true
            case .failed(let reason):
                cell.indicator2.stopAnimating()
                cell.errorLabel2.isHidden = false
                cell.errorLabel2.text = reason
                cell.errorLabel1.isHidden = true
            case .idle:
                cell.indicator2.stopAnimating()
            }
        }
        
        //Different image when devcice connect and disconnect
        if device.connected {
            cell.deviceImageView.image = device.type.image
        } else {
            cell.deviceImageView.image = device.type.disconnectedImage
        }
        
        if let first = device.sources.first, let time = first.latestTime {
            cell.timeLabel.text = time.formattedString
            if time.timeIntervalSinceNow < -600 {
                cell.timeLabel.textColor = UIColor.defaultRed
            } else {
                cell.timeLabel.textColor = UIColor.defaultGray
            }
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
        
        if store.contains(device) { //Already in our history devices, connect directly
            if peripheral.state == .disconnected || peripheral.state == .disconnecting {
                if pairs[device] == nil {
                    let command = DeviceCommand()
                    command.delegate = self
                    pairs[device] = (command, peripheral)
                }
                central.connect(peripheral, options: nil)
                print("Already in history, connecting to \(name)")
            } else {
                print("\(name) alread connected")
            }
            
        } else { //Not in our history devices, ask user to connect
            stopScan() //Prevent too much alert pop up
            
            delegate?.displayAlert(title: "New Device", msg: "Do you want to add this device?", hasCancel: true, action: { [weak self] in
                guard let weakSelf = self else { return }
                
                weakSelf.store.add(device)
                if weakSelf.pairs[device] == nil {
                    let command = DeviceCommand()
                    command.delegate = self
                    weakSelf.pairs[device] = (command, peripheral)
                }
                central.connect(peripheral, options: nil)
                weakSelf.startScan()
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
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        guard let name = peripheral.name, let index = store.devices.firstIndex(where: { $0.name == name }) else { return }
        
        print("Failed connect to \(name)")
        store.devices[index].connected = false
        central.connect(peripheral, options: nil)
    }
    
    private func stopScan() {
        central.stopScan()
    }
    
    private func startScan() {
        central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
}

extension BluetoothViewModel: DeviceCommandDelegate {
    func getDeviceData(_ dicDeviceData: [AnyHashable : Any]!) {
        print(dicDeviceData)
        
        guard let device = fetchingDevice else { return }
        
        fillSource(in: device, with: dicDeviceData)
    }
    
    func getOperateResult(_ dicOperateResult: [AnyHashable : Any]!) {
        print(dicOperateResult)
        fetchingDevice = nil
    }
    
    func getError(_ dicError: [AnyHashable : Any]!) {
        print(dicError)
        
        guard let device = fetchingDevice, let (_, peripheral) = pairs[device], let index = store.findDeviceIndex(peripheral: peripheral) else { return }
        
        fetchingDevice = nil
        store.devices[index].sources = []
        store.devices[index].fetchingState = .failed("Received data failed, try again")
    }
}

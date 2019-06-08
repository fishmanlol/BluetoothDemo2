//
//  AppDelegate.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        let bluetoothController = BluetoothController()
        let navController = UINavigationController(rootViewController: bluetoothController)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }

}


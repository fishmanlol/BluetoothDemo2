//
//  DeviceCell.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

class DeviceCell: UITableViewCell {
    
    weak var deviceImageView: UIImageView!
    weak var deviceNameLabel: UILabel!
    weak var timeLabel: UILabel!
    weak var topDisplayLabel: UILabel!
    weak var middleDisplayLabel: UILabel!
    weak var bottomDisplayLabel: UILabel!
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        let imageView = UIImageView()
        self.deviceImageView = imageView
        addSubview(deviceImageView)
        
        let nameLabel = UILabel()
        self.deviceNameLabel = nameLabel
        addSubview(nameLabel)
        
        let timeLabel = UILabel()
        self.timeLabel = timeLabel
        addSubview(timeLabel)
        
        let topDisplayLabel = UILabel()
        self.topDisplayLabel = topDisplayLabel
        addSubview(topDisplayLabel)
        
        let middleDisplayLabel = UILabel()
        self.middleDisplayLabel = middleDisplayLabel
        addSubview(middleDisplayLabel)
        
        let bottomDisplayLabel = UILabel()
        self.bottomDisplayLabel = bottomDisplayLabel
        addSubview(bottomDisplayLabel)
    }
    
}

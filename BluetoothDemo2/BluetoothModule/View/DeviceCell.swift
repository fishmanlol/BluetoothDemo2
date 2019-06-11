//
//  DeviceCell.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DeviceCell: UITableViewCell {
    
    //end with 1 means the components when has data, 2 means the components no data
    weak var deviceImageView: UIImageView!
    weak var deviceNameLabel1: UILabel!
    weak var deviceNameLabel2: UILabel!
    weak var deviceNoLabel1: UILabel!
    weak var deviceNoLabel2: UILabel!
    weak var indicator1: UIActivityIndicatorView!
    weak var indicator2: UIActivityIndicatorView!
    weak var errorLabel1: UILabel!
    weak var errorLabel2: UILabel!
    weak var timeLabel: UILabel!
    weak var topDisplayLabel: UILabel!
    weak var middleDisplayLabel: UILabel!
    weak var bottomDisplayLabel: UILabel!
    weak var separatorLine: UIView!
    
    var hasData: Bool = false {
        didSet {
            if hasData {
                displayWithData()
            } else {
                displayWithoutData()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "DeviceCell")
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.hasData = false
        super.init(coder: coder)
    }
    
    private func displayWithData() {
        deviceNameLabel1.isHidden = false
        deviceNoLabel1.isHidden = false
        timeLabel.isHidden = false
        topDisplayLabel.isHidden = false
        middleDisplayLabel.isHidden = false
        bottomDisplayLabel.isHidden = false
        
        deviceNameLabel2.isHidden = true
        deviceNoLabel2.isHidden = true
    }
    
    private func displayWithoutData() {
        deviceNameLabel1.isHidden = true
        deviceNoLabel1.isHidden = true
        timeLabel.isHidden = true
        topDisplayLabel.isHidden = true
        middleDisplayLabel.isHidden = true
        bottomDisplayLabel.isHidden = true
        
        deviceNameLabel2.isHidden = false
        deviceNoLabel2.isHidden = false
    }
    
    private func setup() {
        
        //share components
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        self.deviceImageView = imageView
        contentView.addSubview(deviceImageView)
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(r: 200, g: 200, b: 200)
        self.separatorLine = separatorLine
        contentView.addSubview(separatorLine)
        
        //components with data
        let nameLabel1 = UILabel()
        nameLabel1.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel1.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        nameLabel1.textColor = UIColor(r: 72, g: 72, b: 72)
        self.deviceNameLabel1 = nameLabel1
        contentView.addSubview(nameLabel1)
        
        let deviceNoLabel1 = UILabel()
        deviceNoLabel1.textColor = .white
        deviceNoLabel1.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        deviceNoLabel1.backgroundColor = UIColor.orange
        self.deviceNoLabel1 = deviceNoLabel1
        contentView.addSubview(deviceNoLabel1)
        
        let indicator1 = UIActivityIndicatorView()
        indicator1.hidesWhenStopped = true
        indicator1.style = .gray
        self.indicator1 = indicator1
        contentView.addSubview(indicator1)
        
        let errorLabel1 = UILabel()
        errorLabel1.font = UIFont.systemFont(ofSize: 12)
        errorLabel1.textColor = UIColor.defaultRed
        self.errorLabel1 = errorLabel1
        contentView.addSubview(errorLabel1)
        
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.defaultGray
        self.timeLabel = timeLabel
        contentView.addSubview(timeLabel)
        
        let topDisplayLabel = UILabel()
        topDisplayLabel.font = UIFont.systemFont(ofSize: 14)
        topDisplayLabel.textColor = UIColor.defaultGray
        self.topDisplayLabel = topDisplayLabel
        contentView.addSubview(topDisplayLabel)
        
        let middleDisplayLabel = UILabel()
        middleDisplayLabel.font = UIFont.systemFont(ofSize: 14)
        middleDisplayLabel.textColor = UIColor.defaultGray
        self.middleDisplayLabel = middleDisplayLabel
        contentView.addSubview(middleDisplayLabel)
        
        let bottomDisplayLabel = UILabel()
        bottomDisplayLabel.font = UIFont.systemFont(ofSize: 14)
        bottomDisplayLabel.textColor = UIColor.defaultGray
        self.bottomDisplayLabel = bottomDisplayLabel
        contentView.addSubview(bottomDisplayLabel)
        
        //components without data
        let nameLabel2 = UILabel()
        nameLabel2.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        nameLabel2.textColor = UIColor(r: 72, g: 72, b: 72)
        nameLabel2.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.deviceNameLabel2 = nameLabel2
        contentView.addSubview(nameLabel2)
        
        let deviceNoLabel2 = UILabel()
        deviceNoLabel2.textColor = .white
        deviceNoLabel2.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        deviceNoLabel2.backgroundColor = UIColor.orange
        self.deviceNoLabel2 = deviceNoLabel2
        contentView.addSubview(deviceNoLabel2)
        
        let indicator2 = UIActivityIndicatorView()
        indicator2.hidesWhenStopped = true
        indicator2.style = .gray
        self.indicator2 = indicator2
        contentView.addSubview(indicator2)
        
        let errorLabel2 = UILabel()
        errorLabel2.font = UIFont.systemFont(ofSize: 12)
        errorLabel2.textColor = UIColor.defaultRed
        self.errorLabel2 = errorLabel2
        contentView.addSubview(errorLabel2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //shared
        deviceImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        separatorLine.snp.makeConstraints { (make) in
            make.left.equalTo(deviceImageView.snp.right).offset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.right.equalToSuperview()
        }
        
        //with data
        topDisplayLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-20)
        }
        
        middleDisplayLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(topDisplayLabel)
        }
        
        bottomDisplayLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-6)
            make.right.equalTo(topDisplayLabel)
        }
        
        deviceNameLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(separatorLine)
            make.top.equalToSuperview().offset(6)
        }
        
        deviceNoLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(deviceNameLabel1.snp.right).offset(6)
            make.firstBaseline.equalTo(deviceNameLabel1)
            make.height.equalTo(12)
            make.right.lessThanOrEqualTo(topDisplayLabel.snp.left).offset(-6)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(separatorLine)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        indicator1.snp.makeConstraints { (make) in
            make.left.equalTo(separatorLine).offset(12)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        errorLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(separatorLine)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        //without data
        deviceNameLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(separatorLine)
            make.centerY.equalToSuperview()
        }
        
        deviceNoLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(deviceNameLabel2.snp.right).offset(6)
            make.firstBaseline.equalTo(deviceNameLabel2)
            make.height.equalTo(12)
        }
        
        indicator2.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        errorLabel2.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
}

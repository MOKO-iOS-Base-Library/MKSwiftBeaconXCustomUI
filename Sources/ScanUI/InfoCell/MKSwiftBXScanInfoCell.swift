//
//  MKSwiftBXScanInfoCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/24.
//

import UIKit
import SnapKit
import MKBaseSwiftModule
import CoreBluetooth

public protocol MKSwiftBXScanInfoCellProtocol: AnyObject {
    var peripheral: CBPeripheral? { get set }
    var deviceName: String? { get set }
    var connectable: Bool { get set }
    var rssi: String? { get set }
    var displayTime: String? { get set }
    var lightSensor: Bool { get set }
    var lightSensorStatus: Bool { get set }
    var rangingData: String? { get set }
    var txPower: String? { get set }
    var battery: String? { get set }
    var macAddress: String? { get set }
    var tamperAlert: Bool { get set }
}

public protocol MKSwiftBXScanInfoCellDelegate: AnyObject {
    func mk_bx_connectPeripheral(_ peripheral: CBPeripheral)
}

public class MKSwiftBXScanInfoCell: MKSwiftBaseCell {
    public weak var delegate: MKSwiftBXScanInfoCellDelegate?
    public var dataModel: MKSwiftBXScanInfoCellProtocol? {
        didSet {
            updateContent()
        }
    }
    
    private let offsetX: CGFloat = 15.0
    private let rssiIconWidth: CGFloat = 22.0
    private let rssiIconHeight: CGFloat = 11.0
    private let connectButtonWidth: CGFloat = 80.0
    private let connectButtonHeight: CGFloat = 30.0
    private let batteryIconWidth: CGFloat = 25.0
    private let batteryIconHeight: CGFloat = 25.0
    
    
    // MARK: - Public Methods
    public class func initCell(with tableView: UITableView) -> MKSwiftBXScanInfoCell {
        let identifier = "MKSwiftBXScanInfoCellIdenty"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXScanInfoCell
        if cell == nil {
            cell = MKSwiftBXScanInfoCell(style: .default, reuseIdentifier: identifier)
        }
        return cell!
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        contentView.addSubview(topBackView)
        contentView.addSubview(centerBackView)
        contentView.addSubview(bottomBackView)
        
        topBackView.addSubview(rssiIcon)
        topBackView.addSubview(rssiLabel)
        topBackView.addSubview(nameLabel)
        topBackView.addSubview(connectButton)
        
        centerBackView.addSubview(batteryIcon)
        centerBackView.addSubview(macLabel)
        centerBackView.addSubview(tamperLabel)
        
        bottomBackView.addSubview(batteryLabel)
        bottomBackView.addSubview(txPowerLabel)
        bottomBackView.addSubview(txPowerValueLabel)
        bottomBackView.addSubview(rangingDataLabel)
        bottomBackView.addSubview(timeLabel)
        
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
    }
    
    private func updateLayout() {
        topBackView.snp.remakeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(40)
        }
        
        rssiIcon.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(rssiIconWidth)
            make.height.equalTo(rssiIconHeight)
        }
        
        rssiLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(rssiIcon)
            make.width.equalTo(40)
            make.top.equalTo(rssiIcon.snp.bottom).offset(5)
            make.height.equalTo(MKFont.font(10.0).lineHeight)
        }
        
        let nameWidth = contentView.frame.size.width - 2 * offsetX - rssiIconWidth - 10.0 - 8.0 - connectButtonWidth
        let nameSize = nameLabel.text?.size(withFont: nameLabel.font, maxSize: CGSize(width: nameWidth, height: .greatestFiniteMagnitude))
        
        nameLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiIcon.snp.right).offset(20)
            make.centerY.equalTo(rssiIcon)
            make.right.equalTo(connectButton.snp.left).offset(-8)
            make.height.equalTo(nameSize!.height)
        }
        connectButton.snp.remakeConstraints { make in
            make.right.equalTo(-offsetX)
            make.width.equalTo(connectButtonWidth)
            make.centerY.equalTo(topBackView.snp.centerY)
            make.height.equalTo(connectButtonHeight)
        }
        
        centerBackView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBackView.snp.bottom)
            make.height.equalTo(batteryIconHeight)
        }
        batteryIcon.snp.remakeConstraints { make in
            make.left.equalTo(offsetX)
            make.width.equalTo(batteryIconWidth)
            make.centerY.equalTo(centerBackView.snp.centerY)
            make.height.equalTo(batteryIconHeight)
        }
        macLabel.snp.remakeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(tamperLabel.snp.left).offset(-5.0)
            make.centerY.equalTo(centerBackView.snp.centerY)
            make.height.equalTo(MKFont.font(13.0).lineHeight)
        }
        tamperLabel.snp.remakeConstraints { make in
            make.right.equalTo(-offsetX)
            make.width.equalTo(85.0)
            make.centerY.equalTo(centerBackView.snp.centerY)
            make.height.equalTo(MKFont.font(10.0).lineHeight)
        }
        
        bottomBackView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(centerBackView.snp.bottom)
            make.bottom.equalTo(0)
        }
        batteryLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(batteryIcon.snp.centerX)
            make.width.equalTo(45.0)
            make.top.equalTo(3.0)
            make.height.equalTo(MKFont.font(15.0).lineHeight)
        }
        txPowerLabel.snp.remakeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.width.equalTo(55.0)
            make.centerY.equalTo(batteryLabel.snp.centerY)
            make.height.equalTo(MKFont.font(10.0).lineHeight)
        }
        txPowerValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(txPowerLabel.snp.right)
            make.width.equalTo(45.0)
            make.centerY.equalTo(txPowerLabel.snp.centerY)
            make.height.equalTo(MKFont.font(10.0).lineHeight)
        }
        rangingDataLabel.snp.remakeConstraints { make in
            make.left.equalTo(txPowerValueLabel.snp.right).offset(5.0)
            make.right.equalTo(timeLabel.snp.left).offset(-5.0)
            make.centerY.equalTo(txPowerLabel.snp.centerY)
            make.height.equalTo(MKFont.font(10.0).lineHeight)
        }
        timeLabel.snp.remakeConstraints { make in
            make.right.equalTo(-offsetX)
            make.width.equalTo(70.0)
            make.centerY.equalTo(txPowerLabel.snp.centerY)
            make.height.equalTo(MKFont.font(10.0).lineHeight)
        }
    }
    
    private func updateContent() {
        guard let model = dataModel else { return }
        
        connectButton.isHidden = !model.connectable
        txPowerLabel.text = (model.txPower?.isEmpty ?? true) ? "" : "Tx Power:"
        txPowerValueLabel.text = (model.txPower?.isEmpty ?? true) ? "" : "\(model.txPower ?? "")dBm"
        
        if model.lightSensor {
            rangingDataLabel.text = model.lightSensorStatus ?
                "Ambient light detected" : "Ambient light NOT detected"
        } else {
            rangingDataLabel.text = (model.rangingData?.isEmpty ?? true) ?
                "" : "Ranging data:\(model.rangingData ?? "")dBm"
        }
        
        timeLabel.text = model.displayTime
        rssiLabel.text = "\(model.rssi ?? "")dBm"
        nameLabel.text = model.deviceName?.isEmpty ?? true ? "N/A" : model.deviceName
        macLabel.text = "MAC:\(model.macAddress?.isEmpty ?? true ? "N/A" : model.macAddress ?? "")"
        batteryLabel.text = model.battery?.isEmpty ?? true ? "N/A" : "\(model.battery ?? "")mV"
        tamperLabel.text = model.tamperAlert ? "Tamper alert" : "Tamper normal"
        
        setNeedsLayout()
    }
    
    @objc private func connectButtonPressed() {
        guard let peripheral = dataModel?.peripheral else { return }
        delegate?.mk_bx_connectPeripheral(peripheral)
    }
    
    private func createLabel(font: UIFont, text: String? = nil) -> UILabel {
        let label = UILabel()
        label.textColor = MKColor.rgb(184, 184, 184)
        label.textAlignment = .left
        label.font = font
        label.text = text
        return label
    }
    
    // MARK: - UI Components (lazy loaded)
    private lazy var rssiIcon: UIImageView = {
        let view = UIImageView()
        view.image = moduleIcon(name: "mk_swift_bx_signalIcon", in: .module)
        return view
    }()
    
    private lazy var rssiLabel: UILabel = createLabel(font: MKFont.font(10.0))
    private lazy var nameLabel: UILabel = {
        let label = createLabel(font: MKFont.font(15.0))
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var connectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.setTitle("CONNECT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = MKFont.font(15.0)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var batteryIcon: UIImageView = {
        let view = UIImageView()
        view.image = moduleIcon(name: "mk_swift_bx_batteryHighest", in: .module)
        return view
    }()
    
    private lazy var batteryLabel: UILabel = createLabel(font: MKFont.font(10.0))
    private lazy var macLabel: UILabel = createLabel(font: .systemFont(ofSize: 13))
    private lazy var tamperLabel: UILabel = createLabel(font: MKFont.font(10.0))
    private lazy var txPowerLabel: UILabel = createLabel(font: MKFont.font(10.0), text: "Tx Power:")
    private lazy var txPowerValueLabel: UILabel = createLabel(font: MKFont.font(10.0))
    private lazy var rangingDataLabel: UILabel = createLabel(font: MKFont.font(10.0))
    private lazy var timeLabel: UILabel = createLabel(font: MKFont.font(10.0))
    
    private lazy var topBackView: UIView = UIView()
    private lazy var centerBackView: UIView = UIView()
    private lazy var bottomBackView: UIView = UIView()
}

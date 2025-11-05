//
//  MKSwiftBXScanBeaconCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/24.
//

import UIKit
import CoreBluetooth
import SnapKit
import MKBaseSwiftModule

public class MKSwiftBXScanBeaconCellModel:MKSwiftBXScanBaseModel  {
    public var rssi1M: String = ""
    public var txPower: String = ""
    public var interval: String = ""
    public var major: String = ""
    public var minor: String = ""
    public var uuid: String = ""
    public var rssi: String = ""
    
    public override init() {}
}

public class MKSwiftBXScanBeaconCell: MKSwiftBaseCell {
    public var dataModel: MKSwiftBXScanBeaconCellModel? {
        didSet {
            updateContent()
        }
    }
    
    private let offsetX: CGFloat = 10.0
    private let offsetY: CGFloat = 10.0
    private let leftIconWidth: CGFloat = 7.0
    private let leftIconHeight: CGFloat = 7.0
    private let msgFont = MKFont.font(12.0)
    
    // MARK: - Public Methods
    public class func initCell(with tableView: UITableView) -> MKSwiftBXScanBeaconCell {
        let identifier = "MKSwiftBXScanBeaconCellIdenty"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXScanBeaconCell
        if cell == nil {
            cell = MKSwiftBXScanBeaconCell(style: .default, reuseIdentifier: identifier)
        }
        return cell!
    }
    
    public class func getCellHeight(with uuid: String?) -> CGFloat {
        guard !uuid!.isEmpty else { return 125.0 }
        
        let width = MKScreen.width - 2 * 10.0 - 140.0
        let size = uuid!.size(withFont: MKFont.font(16.0), maxSize: CGSize(width: width, height: .greatestFiniteMagnitude))
        
        return 120 + size.height
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
        contentView.addSubview(leftIcon)
        contentView.addSubview(typeLabel)
        contentView.addSubview(rssiLabel)
        contentView.addSubview(rssiValueLabel)
        contentView.addSubview(txPowerLabel)
        contentView.addSubview(txPowerValueLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(distanceValueLabel)
        contentView.addSubview(uuidLabel)
        contentView.addSubview(uuidIDLabel)
        contentView.addSubview(majorLabel)
        contentView.addSubview(majorIDLabel)
        contentView.addSubview(minorLabel)
        contentView.addSubview(minorIDLabel)
    }
    
    private func updateLayout() {
        
        leftIcon.snp.remakeConstraints { make in
            make.left.equalTo(offsetX)
            make.width.equalTo(leftIconWidth)
            make.top.equalTo(offsetY)
            make.height.equalTo(leftIconHeight)
        }
        typeLabel.snp.remakeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).offset(5.0)
            make.width.equalTo(100.0)
            make.centerY.equalTo(leftIcon.snp.centerY)
            make.height.equalTo(MKFont.font(15.0).lineHeight)
        }
        uuidLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(typeLabel.snp.width)
            make.top.equalTo(typeLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        let uuidSize = uuidIDLabel.text?.size(withFont: uuidIDLabel.font, maxSize: CGSize(width: (contentView.frame.width - 2 * offsetX - 140.0), height: .greatestFiniteMagnitude))
        uuidIDLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiLabel.snp.right).offset(25.0)
            make.right.equalTo(-offsetX)
            make.top.equalTo(uuidLabel.snp.top)
            make.height.equalTo(uuidSize?.height ?? 0)
        }
        majorLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(typeLabel.snp.width)
            make.top.equalTo(uuidIDLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        majorIDLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiLabel.snp.right).offset(25.0)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(majorLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        minorLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(typeLabel.snp.width)
            make.top.equalTo(majorLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        minorIDLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiLabel.snp.right).offset(25.0)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(minorLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        rssiLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(typeLabel.snp.width)
            make.top.equalTo(minorLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        rssiValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiLabel.snp.right).offset(25.0)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(rssiLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        distanceLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(typeLabel.snp.width)
            make.top.equalTo(rssiLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        distanceValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiLabel.snp.right).offset(25.0)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(distanceLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        txPowerLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(typeLabel.snp.width)
            make.top.equalTo(distanceLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        txPowerValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiLabel.snp.right).offset(25.0)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(txPowerLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
    }
    
    private func updateContent() {
        guard let model = dataModel else { return }
        
        uuidIDLabel.text = model.uuid
        majorIDLabel.text = model.major
        minorIDLabel.text = model.minor
        rssiValueLabel.text = "\(model.rssi1M)dBm"
        txPowerValueLabel.text = "\(model.txPower)dBm"
        if model.rssi.count > 0 && model.rssi1M.count > 0 {
            let distanceValue = calcDistByRSSI(Int(model.rssi)!, measurePower: abs(Int(model.rssi1M)!))
            if (distanceValue as NSString).floatValue <= 0.1 {
                distanceValueLabel.text = "Immediate"
            } else if (distanceValue as NSString).floatValue > 0.1 && (distanceValue as NSString).floatValue <= 1.0 {
                distanceValueLabel.text = "Near"
            } else {
                distanceValueLabel.text = "Far"
            }
        }
        
        setNeedsLayout()
    }
    
    private func calcDistByRSSI(_ rssi: Int, measurePower: Int) -> String {
        let iRssi = abs(rssi)
        let power = Float(iRssi - measurePower) / (10 * 2.0)
        return String(format: "%.2fm", powf(10, power))
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
    private lazy var leftIcon: UIImageView = {
        let view = UIImageView()
        view.image = moduleIcon(name: "mk_swift_bx_littleBluePoint", in: .module)
        return view
    }()
    
    private lazy var typeLabel: UILabel = createLabel(font: MKFont.font(15), text: "iBeacon")
    private lazy var rssiLabel: UILabel = createLabel(font: msgFont, text: "RSSI@1m")
    private lazy var rssiValueLabel: UILabel = createLabel(font: msgFont)
    private lazy var txPowerLabel: UILabel = createLabel(font: msgFont, text: "Tx power")
    private lazy var txPowerValueLabel: UILabel = createLabel(font: msgFont)
    private lazy var distanceLabel: UILabel = createLabel(font: msgFont, text: "Proximity state")
    private lazy var distanceValueLabel: UILabel = createLabel(font: msgFont)
    private lazy var uuidLabel: UILabel = createLabel(font: msgFont, text: "UUID")
    private lazy var uuidIDLabel: UILabel = {
        let label = createLabel(font: msgFont)
        label.numberOfLines = 0
        return label
    }()
    private lazy var majorLabel: UILabel = createLabel(font: msgFont, text: "Major")
    private lazy var majorIDLabel: UILabel = createLabel(font: msgFont)
    private lazy var minorLabel: UILabel = createLabel(font: msgFont, text: "Minor")
    private lazy var minorIDLabel: UILabel = createLabel(font: msgFont)
}

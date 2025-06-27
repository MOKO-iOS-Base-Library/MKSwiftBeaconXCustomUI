//
//  MKSwiftBXScanHTCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/24.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public class MKSwiftBXScanHTCellModel {
    public var txPower: String?
    public var rssi0M: String?
    public var interval: String?
    public var temperature: String?
    public var humidity: String?
    
    public init() {}
}

public class MKSwiftBXScanHTCell: MKSwiftBaseCell {
    public var dataModel: MKSwiftBXScanHTCellModel? {
        didSet {
            updateContent()
        }
    }
    
    private let offsetX: CGFloat = 10.0
    private let offsetY: CGFloat = 10.0
    private let leftIconWidth: CGFloat = 7.0
    private let leftIconHeight: CGFloat = 7.0
    private let msgLabelWidth: CGFloat = 100.0
    private let msgFont = Font.MKFont(12.0)
    
    // MARK: - Public Methods
    public class func initCell(with tableView: UITableView) -> MKSwiftBXScanHTCell {
        let identifier = "MKSwiftBXScanHTCellIdenty"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXScanHTCell
        if cell == nil {
            cell = MKSwiftBXScanHTCell(style: .default, reuseIdentifier: identifier)
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
        contentView.addSubview(leftIcon)
        contentView.addSubview(typeLabel)
        contentView.addSubview(rssiLabel)
        contentView.addSubview(rssiValueLabel)
        contentView.addSubview(txPowerLabel)
        contentView.addSubview(txPowerValueLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(tempValueLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(humidityValueLabel)
    }
    
    private func updateLayout() {
        leftIcon.snp.makeConstraints { make in
            make.left.equalTo(offsetX)
            make.width.equalTo(leftIconWidth)
            make.top.equalTo(offsetY)
            make.height.equalTo(leftIconHeight)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).offset(5)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(leftIcon.snp.centerY)
            make.height.equalTo(Font.MKFont(15.0).lineHeight)
        }
        txPowerLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(msgLabelWidth)
            make.top.equalTo(typeLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        txPowerValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiValueLabel.snp.left)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(txPowerLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        rssiLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(msgLabelWidth)
            make.top.equalTo(txPowerLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        rssiValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiLabel.snp.right).offset(25.0)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(rssiLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        rssiLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(msgLabelWidth)
            make.top.equalTo(txPowerLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        rssiValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiLabel.snp.right).offset(25.0)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(rssiLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        tempLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(msgLabelWidth)
            make.top.equalTo(rssiLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        tempValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiValueLabel.snp.left)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(tempLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        humidityLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(msgLabelWidth)
            make.top.equalTo(tempLabel.snp.bottom).offset(5.0)
            make.height.equalTo(msgFont.lineHeight)
        }
        humidityValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiValueLabel.snp.left)
            make.right.equalTo(-offsetX)
            make.centerY.equalTo(humidityLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
    }
    
    private func updateContent() {
        guard let model = dataModel else { return }
        
        rssiValueLabel.text = "\(model.rssi0M ?? "")dBm"
        txPowerValueLabel.text = "\(model.txPower ?? "")dBm"
        tempValueLabel.text = "\(model.temperature ?? "")℃"
        humidityValueLabel.text = "\(model.humidity ?? "")%RH"
        
        setNeedsLayout()
    }
    
    private func createLabel(font: UIFont, text: String? = nil) -> UILabel {
        let label = UILabel()
        label.textColor = Color.rgb(184, 184, 184)
        label.textAlignment = .left
        label.font = font
        label.text = text
        return label
    }
    
    // MARK: - UI Components (lazy loaded)
    private lazy var leftIcon: UIImageView = {
        let view = UIImageView()
        view.image = moduleIcon(name: "mk_swift_bx_littleBluePoint")
        return view
    }()
    
    private lazy var typeLabel: UILabel = createLabel(font: Font.MKFont(15.0), text: "Temperature&Humidity")
    private lazy var rssiLabel: UILabel = createLabel(font: msgFont, text: "Ranging data")
    private lazy var rssiValueLabel: UILabel = createLabel(font: msgFont)
    private lazy var txPowerLabel: UILabel = createLabel(font: msgFont, text: "Tx power")
    private lazy var txPowerValueLabel: UILabel = createLabel(font: msgFont)
    private lazy var tempLabel: UILabel = createLabel(font: msgFont, text: "Temperature")
    private lazy var tempValueLabel: UILabel = createLabel(font: msgFont)
    private lazy var humidityLabel: UILabel = createLabel(font: msgFont, text: "Humidity")
    private lazy var humidityValueLabel: UILabel = createLabel(font: msgFont)
}

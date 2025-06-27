//
//  MKSwiftBXScanUIDCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/25.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public class MKSwiftBXScanUIDCellModel {
    public var txPower: String = ""
    public var namespaceId: String = ""
    public var instanceId: String = ""
    
    public init() {}
}

public class MKSwiftBXScanUIDCell: MKSwiftBaseCell {
    public var dataModel: MKSwiftBXScanUIDCellModel? {
        didSet {
            updateContent()
        }
    }
    
    private let msgFont = Font.MKFont(12.0)
    private let offsetX: CGFloat = 10
    private let offsetY: CGFloat = 10
    private let leftIconWidth: CGFloat = 7
    private let leftIconHeight: CGFloat = 7
    
    // MARK: - Initialization
    
    public class func initCell(with tableView: UITableView) -> MKSwiftBXScanUIDCell {
        let identifier = "MKSwiftBXScanUIDCellIdenty"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXScanUIDCell
        if cell == nil {
            cell = MKSwiftBXScanUIDCell(style: .default, reuseIdentifier: identifier)
        }
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        leftIcon.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(offsetX)
            make.width.equalTo(leftIconWidth)
            make.top.equalToSuperview().offset(offsetY)
            make.height.equalTo(leftIconHeight)
        }
        
        typeLabel.snp.remakeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).offset(5)
            make.width.equalTo(100)
            make.centerY.equalTo(leftIcon.snp.centerY)
            make.height.equalTo(typeLabel.font.lineHeight)
        }
        
        rssiLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(typeLabel.snp.width)
            make.top.equalTo(typeLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        txPowerLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiLabel.snp.right).offset(25)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(rssiLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        nameSpaceLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(typeLabel.snp.width)
            make.top.equalTo(rssiLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        nameSpaceIDLabel.snp.remakeConstraints { make in
            make.left.equalTo(txPowerLabel.snp.left)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(nameSpaceLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        instanceLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(typeLabel.snp.width)
            make.top.equalTo(nameSpaceLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        instanceIDLabel.snp.remakeConstraints { make in
            make.left.equalTo(txPowerLabel.snp.left)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(instanceLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupSubviews() {
        contentView.addSubview(leftIcon)
        contentView.addSubview(typeLabel)
        contentView.addSubview(rssiLabel)
        contentView.addSubview(txPowerLabel)
        contentView.addSubview(nameSpaceLabel)
        contentView.addSubview(nameSpaceIDLabel)
        contentView.addSubview(instanceLabel)
        contentView.addSubview(instanceIDLabel)
    }
    
    private func createLabel(with font: UIFont) -> UILabel {
        let label = UILabel()
        label.textColor = Color.rgb(184, 184, 184)
        label.textAlignment = .left
        label.font = font
        return label
    }
    
    private func updateContent() {
        guard let dataModel = dataModel else { return }
        
        txPowerLabel.text = "\(dataModel.txPower)dBm"
        nameSpaceIDLabel.text = "0x\(dataModel.namespaceId.uppercased())"
        instanceIDLabel.text = "0x\(dataModel.instanceId.uppercased())"
    }
    
    // MARK: - UI Components
    
    private lazy var leftIcon: UIImageView = {
        let view = UIImageView()
        view.image = moduleIcon(name: "mk_swift_bx_littleBluePoint")
        return view
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = createLabel(with: Font.MKFont(15.0))
        label.textColor = .black
        label.text = "UID"
        return label
    }()
    
    private lazy var rssiLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "RSSI@0m"
        return label
    }()
    
    private lazy var txPowerLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "0dBm"
        return label
    }()
    
    private lazy var nameSpaceLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Namespace ID"
        return label
    }()
    
    private lazy var nameSpaceIDLabel: UILabel = {
        createLabel(with: msgFont)
    }()
    
    private lazy var instanceLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Instance ID"
        return label
    }()
    
    private lazy var instanceIDLabel: UILabel = {
        createLabel(with: msgFont)
    }()
}

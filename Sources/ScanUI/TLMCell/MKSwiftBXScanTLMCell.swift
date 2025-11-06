//
//  MKSwiftBXScanTLMCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/25.
//

import UIKit

import SnapKit

import MKBaseSwiftModule
import MKSwiftCustomUI

public class MKSwiftBXScanTLMCellModel: MKSwiftBXScanBaseModel {
    public var version: String = ""
    public var mvPerbit: String = ""
    public var temperature: String = ""
    public var advertiseCount: String = ""
    public var deciSecondsSinceBoot: String = ""
    
    public override init() {}
}

public class MKSwiftBXScanTLMCell: MKSwiftBaseCell {
    public var dataModel: MKSwiftBXScanTLMCellModel? {
        didSet {
            updateContent()
        }
    }
    
    private let msgFont = MKFont.font(12.0)
    private let offsetX: CGFloat = 10
    private let offsetY: CGFloat = 10
    private let leftIconWidth: CGFloat = 7
    private let leftIconHeight: CGFloat = 7
    
    // MARK: - Initialization
    
    public class func initCell(with tableView: UITableView) -> MKSwiftBXScanTLMCell {
        let identifier = "MKSwiftBXScanTLMCellIdenty"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXScanTLMCell
        if cell == nil {
            cell = MKSwiftBXScanTLMCell(style: .default, reuseIdentifier: identifier)
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
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(leftIcon.snp.centerY)
            make.height.equalTo(typeLabel.font.lineHeight)
        }
        
        batteryMsgLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(120)
            make.top.equalTo(typeLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        batteryLabel.snp.remakeConstraints { make in
            make.left.equalTo(batteryMsgLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(batteryMsgLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        temperMsgLabel.snp.remakeConstraints { make in
            make.left.equalTo(batteryMsgLabel.snp.left)
            make.width.equalTo(batteryMsgLabel.snp.width)
            make.top.equalTo(batteryMsgLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        temperatureLabel.snp.remakeConstraints { make in
            make.left.equalTo(batteryLabel.snp.left)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(temperMsgLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        advLabel.snp.remakeConstraints { make in
            make.left.equalTo(batteryMsgLabel.snp.left)
            make.width.equalTo(batteryMsgLabel.snp.width)
            make.top.equalTo(temperMsgLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        advValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(batteryLabel.snp.left)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(advLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        timeSinceLabel.snp.remakeConstraints { make in
            make.left.equalTo(batteryMsgLabel.snp.left)
            make.width.equalTo(batteryMsgLabel.snp.width)
            make.top.equalTo(advLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.left.equalTo(batteryLabel.snp.left)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(timeSinceLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupSubviews() {
        contentView.addSubview(leftIcon)
        contentView.addSubview(typeLabel)
        contentView.addSubview(batteryMsgLabel)
        contentView.addSubview(batteryLabel)
        contentView.addSubview(temperMsgLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(advLabel)
        contentView.addSubview(advValueLabel)
        contentView.addSubview(timeSinceLabel)
        contentView.addSubview(timeLabel)
    }
    
    private func createLabel(with font: UIFont) -> UILabel {
        let label = UILabel()
        label.textColor = MKColor.rgb(184, 184, 184)
        label.textAlignment = .left
        label.font = font
        return label
    }
    
    private func updateContent() {
        guard let dataModel = dataModel else { return }
        
        batteryLabel.text = "\(dataModel.mvPerbit)mV"
        temperatureLabel.text = String(format: "%.1f°C", (dataModel.temperature as NSString).floatValue)
        advValueLabel.text = dataModel.advertiseCount
        timeLabel.text = getTimeWithSec((dataModel.deciSecondsSinceBoot as NSString).floatValue)
    }
    
    private func getTimeWithSec(_ second: Float) -> String {
        let minutes = floor(second / 60)
        let sec = second - minutes * 60
        var hours1 = floor(second / (60 * 60))
        hours1 = hours1 - 24 * floor(hours1 / 24)
        let day = floor(hours1 / 24)
        hours1 = hours1 - 24 * day
        return String(format: "%dd%dh%dm%.1fs", Int(day), Int(hours1), Int(minutes), sec)
    }
    
    // MARK: - UI Components
    
    private lazy var leftIcon: UIImageView = {
        let view = UIImageView()
        view.image = moduleIcon(name: "mk_swift_bx_littleBluePoint", in: .module)
        return view
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = createLabel(with: MKFont.font(15.0))
        label.textColor = .black
        label.text = "Unencrypted TLM"
        return label
    }()
    
    private lazy var batteryMsgLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Battery voltage"
        return label
    }()
    
    private lazy var batteryLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "0mV"
        return label
    }()
    
    private lazy var temperMsgLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Chip temperature"
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "0°C"
        return label
    }()
    
    private lazy var advLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "ADV count"
        return label
    }()
    
    private lazy var advValueLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "0"
        return label
    }()
    
    private lazy var timeSinceLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Running time"
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "0s"
        return label
    }()
}

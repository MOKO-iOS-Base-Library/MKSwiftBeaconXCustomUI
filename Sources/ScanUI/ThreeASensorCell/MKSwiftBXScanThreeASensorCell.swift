//
//  MKSwiftBXScanThreeASensorCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/25.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public class MKSwiftBXScanThreeASensorCellModel: MKSwiftBXScanBaseModel {
    public var rssi0M: String = ""
    public var txPower: String = ""
    public var interval: String = ""
    public var samplingRate: String = ""
    public var accelerationOfGravity: String = ""
    public var sensitivity: String = ""
    public var xData: String = ""
    public var yData: String = ""
    public var zData: String = ""
    public var needParse: Bool = false
    
    public override init() {}
}

public class MKSwiftBXScanThreeASensorCell: MKSwiftBaseCell {
    public var dataModel: MKSwiftBXScanThreeASensorCellModel? {
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
    
    public class func initCell(with tableView: UITableView) -> MKSwiftBXScanThreeASensorCell {
        let identifier = "MKSwiftBXScanThreeASensorCellIdenty"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXScanThreeASensorCell
        if cell == nil {
            cell = MKSwiftBXScanThreeASensorCell(style: .default, reuseIdentifier: identifier)
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
        
        txPowerLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(rssiLabel.snp.width)
            make.top.equalTo(typeLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        txPowerValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiValueLabel.snp.left)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(txPowerLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        rssiLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(100)
            make.top.equalTo(txPowerLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        rssiValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiLabel.snp.right).offset(25)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(rssiLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        dataRateLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(rssiLabel.snp.width)
            make.top.equalTo(rssiLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        dateRateValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiValueLabel.snp.left)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(dataRateLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        scaleLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(rssiLabel.snp.width)
            make.top.equalTo(dataRateLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        scaleValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiValueLabel.snp.left)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(scaleLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        senLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(rssiLabel.snp.width)
            make.top.equalTo(scaleLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        senValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiValueLabel.snp.left)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(senLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        rawLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(rssiLabel.snp.width)
            make.top.equalTo(senLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        rawValueLabel.snp.remakeConstraints { make in
            make.left.equalTo(rssiValueLabel.snp.left)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(rawLabel.snp.centerY)
            make.height.equalTo(msgFont.lineHeight)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupSubviews() {
        contentView.addSubview(leftIcon)
        contentView.addSubview(typeLabel)
        contentView.addSubview(rssiLabel)
        contentView.addSubview(rssiValueLabel)
        contentView.addSubview(txPowerLabel)
        contentView.addSubview(txPowerValueLabel)
        contentView.addSubview(dataRateLabel)
        contentView.addSubview(dateRateValueLabel)
        contentView.addSubview(scaleLabel)
        contentView.addSubview(scaleValueLabel)
        contentView.addSubview(senLabel)
        contentView.addSubview(senValueLabel)
        contentView.addSubview(rawLabel)
        contentView.addSubview(rawValueLabel)
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
        
        rssiValueLabel.text = "\(dataModel.rssi0M)dBm"
        txPowerValueLabel.text = "\(dataModel.txPower)dBm"
        dateRateValueLabel.text = fetchDataRate(dataModel.samplingRate)
        scaleValueLabel.text = fetchScaleData(dataModel.accelerationOfGravity)
        senValueLabel.text = String(format: "%.1fg", (dataModel.sensitivity as NSString).doubleValue * 0.1)
        
        if dataModel.needParse {
            let scale = fetchRawScale(dataModel.accelerationOfGravity)
            
            let xValue = "X:\(fetchRawString(dataModel.xData, scale: scale))mg"
            let yValue = "Y:\(fetchRawString(dataModel.yData, scale: scale))mg"
            let zValue = "Z:\(fetchRawString(dataModel.zData, scale: scale))mg"
            
            rawValueLabel.text = "\(xValue) \(yValue) \(zValue)"
        } else {
            let xValue = "0x\(dataModel.xData.uppercased())"
            let yValue = "0x\(dataModel.yData.uppercased())"
            let zValue = "0x\(dataModel.zData.uppercased())"
            rawValueLabel.text = "X:\(xValue) Y:\(yValue) Z:\(zValue)"
        }
    }
    
    private func fetchDataRate(_ rate: String) -> String {
        switch rate {
        case "00": return "1 Hz"
        case "01": return "10 Hz"
        case "02": return "25 Hz"
        case "03": return "50 Hz"
        case "04": return "100 Hz"
        case "05": return "200 Hz"
        case "06": return "400 Hz"
        case "07": return "1344 Hz"
        case "08": return "1620 Hz"
        case "09": return "5376 Hz"
        default: return ""
        }
    }
    
    private func fetchScaleData(_ scale: String) -> String {
        switch scale {
        case "00": return "±2g"
        case "01": return "±4g"
        case "02": return "±8g"
        case "03": return "±16g"
        default: return ""
        }
    }
    
    private func fetchRawScale(_ scale: String) -> Float {
        switch scale {
        case "00": return 0.9765625
        case "01": return 1.953125
        case "02": return 3.90625
        case "03": return 7.8125
        default: return 0
        }
    }
    
    private func fetchRawString(_ dataValue: String, scale: Float) -> String {
        let xHex = numberWithHexString(dataValue)
        var value: Float = 0
        if xHex & 0x8000 != 0 {
            let shifted = (xHex >> 4) - 0x1000
            value = Float(shifted) * scale
        } else {
            let shifted = xHex >> 4
            value = Float(shifted) * scale
        }
        return String(format: "%.f", value)
    }
    
    private func numberWithHexString(_ hexString: String) -> Int {
        let scanner = Scanner(string: hexString)
        var result: UInt64 = 0
        scanner.scanHexInt64(&result)
        return Int(result)
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
        label.text = "3-axis accelerometer"
        return label
    }()
    
    private lazy var rssiLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Ranging data"
        return label
    }()
    
    private lazy var rssiValueLabel: UILabel = {
        createLabel(with: msgFont)
    }()
    
    private lazy var txPowerLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Tx power"
        return label
    }()
    
    private lazy var txPowerValueLabel: UILabel = {
        createLabel(with: msgFont)
    }()
    
    private lazy var dataRateLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Sampling rate"
        return label
    }()
    
    private lazy var dateRateValueLabel: UILabel = {
        createLabel(with: msgFont)
    }()
    
    private lazy var scaleLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Full-scale"
        return label
    }()
    
    private lazy var scaleValueLabel: UILabel = {
        createLabel(with: msgFont)
    }()
    
    private lazy var senLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Motion threshold"
        return label
    }()
    
    private lazy var senValueLabel: UILabel = {
        createLabel(with: msgFont)
    }()
    
    private lazy var rawLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "Acceleration"
        return label
    }()
    
    private lazy var rawValueLabel: UILabel = {
        createLabel(with: msgFont)
    }()
}

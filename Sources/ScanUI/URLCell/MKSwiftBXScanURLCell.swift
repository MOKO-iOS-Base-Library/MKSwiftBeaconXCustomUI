//
//  MKSwiftBXScanURLCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/25.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public class MKSwiftBXScanURLCellModel {
    public var txPower: String = ""
    public var shortUrl: String = ""
    
    public init() {}
}

public class MKSwiftBXScanURLCell: MKSwiftBaseCell {
    public var dataModel: MKSwiftBXScanURLCellModel? {
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
    
    public class func initCell(with tableView: UITableView) -> MKSwiftBXScanURLCell {
        let identifier = "MKSwiftBXScanURLCellIdenty"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXScanURLCell
        if cell == nil {
            cell = MKSwiftBXScanURLCell(style: .default, reuseIdentifier: identifier)
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
        
        linkLabel.snp.remakeConstraints { make in
            make.left.equalTo(typeLabel.snp.left)
            make.width.equalTo(typeLabel.snp.width)
            make.top.equalTo(rssiLabel.snp.bottom).offset(5)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        let lineIDSize = NSString(string: linkIDLabel.text ?? "").size(
            withAttributes: [.font: msgFont]
        )
        var lineIDWidth = lineIDSize.width
        if lineIDWidth > contentView.frame.width - (offsetX + leftIconWidth + 100 + 5) {
            lineIDWidth = contentView.frame.width - (offsetX + leftIconWidth + 100 + 5)
        }
        
        linkIDLabel.snp.remakeConstraints { make in
            make.left.equalTo(txPowerLabel.snp.left)
            make.width.equalTo(lineIDWidth)
            make.top.equalTo(linkLabel.snp.top)
            make.height.equalTo(msgFont.lineHeight)
        }
        
        linkLine.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }
    
    // MARK: - Event Methods
    
    @objc private func linkUrlPressed() {
        guard let urlString = dataModel?.shortUrl, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupSubviews() {
        contentView.addSubview(leftIcon)
        contentView.addSubview(typeLabel)
        contentView.addSubview(rssiLabel)
        contentView.addSubview(txPowerLabel)
        contentView.addSubview(linkLabel)
        contentView.addSubview(linkIDLabel)
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
        linkIDLabel.text = dataModel.shortUrl
        setNeedsLayout()
    }
    
    // MARK: - UI Components
    
    private lazy var leftIcon: UIImageView = {
        let view = UIImageView()
        view.image = moduleIcon(name: "mk_swift_bx_littleBluePoint", in: .module)
        return view
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = createLabel(with: Font.MKFont(15.0))
        label.textColor = .black
        label.text = "URL"
        return label
    }()
    
    private lazy var rssiLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "RSSI@0m"
        return label
    }()
    
    private lazy var txPowerLabel: UILabel = {
        createLabel(with: msgFont)
    }()
    
    private lazy var linkLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.text = "URL link"
        return label
    }()
    
    private lazy var linkIDLabel: UILabel = {
        let label = createLabel(with: msgFont)
        label.numberOfLines = 0
        label.textColor = .blue
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkUrlPressed))
        label.addGestureRecognizer(tap)
        label.addSubview(linkLine)
        return label
    }()
    
    private lazy var linkLine: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
}

//
//  MKSwiftBXSlotConfigInfoCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/26.
//

import UIKit

import SnapKit

import MKBaseSwiftModule
import MKSwiftCustomUI

public class MKSwiftBXSlotConfigInfoCellModel {
    var deviceName: String = ""
    var nameMinLen: Int = 1
    var nameMaxLen: Int = 20
    
    public init() {}
}

public class MKSwiftBXSlotConfigInfoCell: UITableViewCell, @preconcurrency MKSwiftBXSlotConfigCellProtocol {
    public func slotConfigCellParams() -> [String : Any] {
        guard let deviceName = textField.text, !deviceName.isEmpty else {
            return [
                "msg":"Device name cannot be empty",
                "result":[:]
            ]
        }
        return [
            "msg": "",
            "result": [
                "dataType": MKSwiftBXSlotConfigKey.advContentType,
                "params": [
                    "frameType": MKSwiftBXSlotConfigKey.infoData,
                    "deviceName":deviceName
                ]
            ]
        ]
    }
    
    public var dataModel: MKSwiftBXSlotConfigInfoCellModel? {
        didSet {
            updateContent()
        }
    }
    
    public class func dequeueReusableCell(with tableView: UITableView) -> MKSwiftBXSlotConfigInfoCell {
        let identifier = String(describing: MKSwiftBXSlotConfigInfoCell.self)
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXSlotConfigInfoCell {
            return cell
        }
        return MKSwiftBXSlotConfigInfoCell(style: .default, reuseIdentifier: identifier)
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.addSubview(backView)
        backView.addSubview(leftIcon)
        backView.addSubview(typeLabel)
        backView.addSubview(msgLabel)
        backView.addSubview(textField)        
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        leftIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(22)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(22)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(leftIcon)
            make.height.equalTo(typeLabel.font.lineHeight)
        }
        
        msgLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(120)
            make.centerY.equalTo(textField)
            make.height.equalTo(msgLabel.font.lineHeight)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(msgLabel.snp.right).offset(20)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(leftIcon.snp.bottom).offset(15)
            make.height.equalTo(30)
        }
    }
    
    // MARK: - Update UI
    
    private func updateContent() {
        guard let dataModel = dataModel else { return }
        textField.text = dataModel.deviceName
        textField.placeholder = "\(dataModel.nameMinLen) ~ \(dataModel.nameMaxLen) characters."
        textField.maxLength = dataModel.nameMaxLen
    }
    
    // MARK: - UI Components
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var leftIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = moduleIcon(name: "mk_swift_bx_slotAdvContent", in: .module)
        return imageView
    }()
    
    private lazy var typeLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(text: "Adv content")
    }()
    
    private lazy var msgLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(text: "Device name")
    }()
    
    private lazy var textField: MKSwiftTextField = {
        let textField = MKSwiftTextField(textFieldType: .normal)
        textField.textColor = MKColor.defaultText
        textField.maxLength = 5
        textField.font = MKFont.font(15.0)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = MKColor.line.cgColor
        textField.layer.cornerRadius = 3
        return textField
    }()
}

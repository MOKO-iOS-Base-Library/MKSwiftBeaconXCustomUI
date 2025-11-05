//
//  MKSwiftBXSlotConfigBeaconCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/26.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public class MKSwiftBXSlotConfigBeaconCellModel {
    public var major: String = ""
    public var minor: String = ""
    public var uuid: String = ""
    
    public init() {}
}

public class MKSwiftBXSlotConfigBeaconCell: MKSwiftBaseCell, @preconcurrency MKSwiftBXSlotConfigCellProtocol {
    public func slotConfigCellParams() -> [String : Any] {
        guard let major = majorTextField.text, !major.isEmpty,
              let minor = minorTextField.text, !minor.isEmpty,
              let uuid = uuidTextField.text, !uuid.isEmpty else {
            return [
                "msg":"Value cannot be empty",
                "result":[:]
            ]
        }
        return [
            "msg": "",
            "result": [
                "dataType": MKSwiftBXSlotConfigKey.advContentType,
                "params": [
                    "frameType": MKSwiftBXSlotConfigKey.beaconData,
                    "major":majorTextField.text ?? "",
                    "minor":minorTextField.text ?? "",
                    "uuid":uuidTextField.text ?? ""
                ]
            ]
        ]
    }
    
    public var dataModel: MKSwiftBXSlotConfigBeaconCellModel? {
        didSet {
            updateContent()
        }
    }
    
    // MARK: - Public Methods
    
    public class func dequeueReusableCell(with tableView: UITableView) -> MKSwiftBXSlotConfigBeaconCell {
        let identifier = String(describing: MKSwiftBXSlotConfigBeaconCell.self)
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXSlotConfigBeaconCell {
            return cell
        }
        return MKSwiftBXSlotConfigBeaconCell(style: .default, reuseIdentifier: identifier)
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
        backView.addSubview(majorLabel)
        backView.addSubview(majorTextField)
        backView.addSubview(minorLabel)
        backView.addSubview(minorTextField)
        backView.addSubview(uuidLabel)
        backView.addSubview(hexLabel)
        backView.addSubview(uuidTextField)
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
        
        majorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(80)
            make.centerY.equalTo(majorTextField)
            make.height.equalTo(majorLabel.font.lineHeight)
        }
        
        majorTextField.snp.makeConstraints { make in
            make.left.equalTo(majorLabel.snp.right).offset(40)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(leftIcon.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        minorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(80)
            make.centerY.equalTo(minorTextField)
            make.height.equalTo(minorLabel.font.lineHeight)
        }
        
        minorTextField.snp.makeConstraints { make in
            make.left.equalTo(minorLabel.snp.right).offset(40)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(majorTextField.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        uuidLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(80)
            make.centerY.equalTo(uuidTextField)
            make.height.equalTo(uuidLabel.font.lineHeight)
        }
        
        hexLabel.snp.makeConstraints { make in
            make.right.equalTo(uuidTextField.snp.left).offset(-2)
            make.width.equalTo(30)
            make.centerY.equalTo(uuidTextField)
            make.height.equalTo(hexLabel.font.lineHeight)
        }
        
        uuidTextField.snp.makeConstraints { make in
            make.left.equalTo(uuidLabel.snp.right).offset(40)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(minorTextField.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
    }
    
    // MARK: - Update UI
    
    private func updateContent() {
        guard let dataModel = dataModel else { return }
        majorTextField.text = dataModel.major
        minorTextField.text = dataModel.minor
        uuidTextField.text = dataModel.uuid
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
        // Replace with your actual image asset
        imageView.image = moduleIcon(name: "mk_swift_bx_slotAdvContent", in: .module)
        return imageView
    }()
    
    private lazy var typeLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(text: "Adv content")
    }()
    
    private lazy var majorLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(text: "Major")
    }()
    
    private lazy var majorTextField: MKSwiftTextField = {
        let textField = MKSwiftTextField(textFieldType: .realNumberOnly)
        textField.textColor = MKColor.defaultText
        textField.placeholder = "0~65535"
        textField.maxLength = 5
        textField.font = MKFont.font(15.0)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = MKColor.line.cgColor
        textField.layer.cornerRadius = 3
        return textField
    }()
    
    private lazy var minorLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(text: "Minor")
    }()
    
    private lazy var minorTextField: MKSwiftTextField = {
        let textField = MKSwiftTextField(textFieldType: .realNumberOnly)
        textField.textColor = MKColor.defaultText
        textField.placeholder = "0~65535"
        textField.maxLength = 5
        textField.font = MKFont.font(15.0)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = MKColor.line.cgColor
        textField.layer.cornerRadius = 3
        return textField
    }()
    
    private lazy var uuidLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(text: "UUID")
    }()
    
    private lazy var hexLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(font: MKFont.font(12.0), text: "0x")
    }()
    
    private lazy var uuidTextField: MKSwiftTextField = {
        let textField = MKSwiftTextField(textFieldType: .hexCharOnly)
        textField.textColor = MKColor.defaultText
        textField.placeholder = "16bytes"
        textField.maxLength = 32
        textField.font = MKFont.font(15.0)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = MKColor.line.cgColor
        textField.layer.cornerRadius = 3
        return textField
    }()
}

//
//  MKSwiftBXSlotConfigUIDCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/26.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public class MKSwiftBXSlotConfigUIDCell {
    var nameSpace: String = ""
    var instanceID: String = ""
    
    public init() {}
}

public class MKBXSlotConfigUIDCell: MKSwiftBaseCell, @preconcurrency MKSwiftBXSlotConfigCellProtocol {
    public func slotConfigCellParams() -> [String : Any] {
        guard let nameSpace = nameTextField.text, !nameSpace.isEmpty, let instanceID = instanceTextField.text, !instanceID.isEmpty else {
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
                    "frameType": MKSwiftBXSlotConfigKey.uidData,
                    "nameSpace":nameSpace,
                    "instanceID":instanceID
                ]
            ]
        ]
    }
    
    public var dataModel: MKSwiftBXSlotConfigUIDCell? {
        didSet {
            updateUI()
        }
    }
    
    public class func dequeueReusableCell(with tableView: UITableView) -> MKBXSlotConfigUIDCell {
        let identifier = String(describing: MKBXSlotConfigUIDCell.self)
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKBXSlotConfigUIDCell {
            return cell
        }
        return MKBXSlotConfigUIDCell(style: .default, reuseIdentifier: identifier)
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
        backView.addSubview(nameLabel)
        backView.addSubview(hexNameLabel)
        backView.addSubview(nameTextField)
        backView.addSubview(instanceLabel)
        backView.addSubview(hexInstanceLabel)
        backView.addSubview(instanceTextField)
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
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(120)
            make.centerY.equalTo(nameTextField)
            make.height.equalTo(nameLabel.font.lineHeight)
        }
        
        hexNameLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.width.equalTo(30)
            make.centerY.equalTo(nameTextField)
            make.height.equalTo(hexNameLabel.font.lineHeight)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.left.equalTo(hexNameLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(leftIcon.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        instanceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(120)
            make.centerY.equalTo(instanceTextField)
            make.height.equalTo(instanceLabel.font.lineHeight)
        }
        
        hexInstanceLabel.snp.makeConstraints { make in
            make.left.equalTo(instanceLabel.snp.right).offset(5)
            make.width.equalTo(30)
            make.centerY.equalTo(instanceTextField)
            make.height.equalTo(hexInstanceLabel.font.lineHeight)
        }
        
        instanceTextField.snp.makeConstraints { make in
            make.left.equalTo(hexInstanceLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
    }
    
    // MARK: - Update UI
    
    private func updateUI() {
        guard let dataModel = dataModel else { return }
        nameTextField.text = dataModel.nameSpace
        instanceTextField.text = dataModel.instanceID
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
    
    private lazy var nameLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(text: "Namespace ID")
    }()
    
    private lazy var hexNameLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(font: MKFont.font(12.0), text: "0x")
    }()
    
    private lazy var nameTextField: MKSwiftTextField = {
        let textField = MKSwiftTextField(textFieldType: .hexCharOnly)
        textField.textColor = MKColor.defaultText
        textField.placeholder = "10bytes"
        textField.maxLength = 20
        textField.font = MKFont.font(15.0)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = MKColor.line.cgColor
        textField.layer.cornerRadius = 3
        return textField
    }()
    
    private lazy var instanceLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(text: "Instance ID")
    }()
    
    private lazy var hexInstanceLabel: UILabel = {
        return MKSwiftUIAdaptor.createNormalLabel(font: MKFont.font(12.0), text: "0x")
    }()
    
    private lazy var instanceTextField: MKSwiftTextField = {
        let textField = MKSwiftTextField(textFieldType: .hexCharOnly)
        textField.textColor = MKColor.defaultText
        textField.placeholder = "6bytes"
        textField.maxLength = 12
        textField.font = MKFont.font(15.0)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = MKColor.line.cgColor
        textField.layer.cornerRadius = 3
        return textField
    }()
}

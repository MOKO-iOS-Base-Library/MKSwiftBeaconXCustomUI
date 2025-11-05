//
//  File.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/26.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public class MKSwiftBXSlotConfigURLCellModel {
    public var advData: Data?
    //0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
    public var urlType: Int = 0
    public var urlContent: String = ""
    
    public init() {}
}

public class MKSwiftBXSlotConfigURLCell: MKSwiftBaseCell, @preconcurrency MKSwiftBXSlotConfigCellProtocol {
    public func slotConfigCellParams() -> [String : Any] {
        guard let content = textField.text, !content.isEmpty else {
            return [
                "msg":"Data format incorrect!",
                "result":[:]
            ]
        }
        let url = urlTypeLabel.text! + content
        //需要对,@"http://"、@"https://这两种情况单独处理
        let legal = url.matchesRegex(String.isUrl)
        if legal {
            return getLegitimateUrl(header: urlTypeLabel.text!, urlContent: content)
        }
        return suffixIllegal(header: urlTypeLabel.text!, urlContent: content)
    }
    
    public var dataModel: MKSwiftBXSlotConfigURLCellModel? {
        didSet {
            updateContent()
        }
    }
    
    public class func dequeueReusableCell(with tableView: UITableView) -> MKSwiftBXSlotConfigURLCell {
        let identifier = String(describing: MKSwiftBXSlotConfigURLCell.self)
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXSlotConfigURLCell {
            return cell
        }
        return MKSwiftBXSlotConfigURLCell(style: .default, reuseIdentifier: identifier)
    }
    
    private let urlHeaders = ["http://www.", "https://www.", "http://", "https://"]
    
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
        backView.addSubview(urlTypeLabel)
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
            make.width.equalTo(40)
            make.centerY.equalTo(textField)
            make.height.equalTo(msgLabel.font.lineHeight)
        }
        
        urlTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(msgLabel.snp.right).offset(15)
            make.width.equalTo(80)
            make.centerY.equalTo(textField)
            make.height.equalTo(urlTypeLabel.font.lineHeight)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(urlTypeLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(leftIcon.snp.bottom).offset(15)
            make.height.equalTo(30)
        }
    }
    
    // MARK: - Update UI
    
    private func updateContent() {
        guard let dataModel = dataModel else { return }
        
        if let advData = dataModel.advData {
            loadUrlInfo(advData)
        }
    }
    
    // MARK: - Event Handlers
    
    @objc private func urlTypeLabelPressed() {
        let currentIndex = urlHeaders.firstIndex(of: urlTypeLabel.text ?? "") ?? 0
        let pickView = MKSwiftPickerView()
        pickView.showPickView(with: urlHeaders, selectedRow: currentIndex) { [weak self] currentRow in
            guard let self = self else { return }
            self.urlTypeLabel.text = self.urlHeaders[currentIndex]
        }
    }
    
    // MARK: - Private Methods
    
    private func loadUrlInfo(_ advData: Data) {
        guard advData.count >= 3 else { return }
        
        let bytes = [UInt8](advData)
        let urlBytes = bytes[3...]
        
        var url = ""
        for byte in urlBytes {
            url.append(MKSwiftBXSlotDataAdopter.getEncodedString(CChar(byte)))
        }
        
        urlTypeLabel.text = MKSwiftBXSlotDataAdopter.getUrlscheme(CChar(bytes[2]))
        textField.text = url
    }
    
    private func getLegitimateUrl(header: String, urlContent: String) -> [String: Any] {
        let urlList = urlContent.components(separatedBy: ".")
        guard !urlList.isEmpty else {
            return [
                "msg": "Data format incorrect!",
                "result": [:]
            ]
        }
        
        let lastComponent = urlList.last!
        let expansion = MKSwiftBXSlotDataAdopter.getExpansionHex("." + lastComponent)
        guard !expansion.isEmpty else {
            // 后缀名不合法
            return suffixIllegal(header: header, urlContent: urlContent)
        }
        
        // 如果后缀名合法，则校验中间的字符，最大长度是16
        var content = ""
        for i in 0..<urlList.count-1 {
            content += ".\(urlList[i])"
        }
        
        guard !content.isEmpty else {
            return [
                "msg": "Data format incorrect!",
                "result": [:]
            ]
        }
        
        content = String(content.dropFirst())
        guard content.count <= 16 else {
            return [
                "msg": "Data format incorrect!",
                "result": [:]
            ]
        }
        
        return [
            "msg": "",
            "result": [
                "dataType": MKSwiftBXSlotConfigKey.advContentType,
                "params": [
                    "frameType": MKSwiftBXSlotConfigKey.urlData,
                    "urlHeader": header,
                    "urlExpansion": "." + lastComponent,
                    "urlContent": content
                ]
            ]
        ]
    }

    private func suffixIllegal(header: String, urlContent: String) -> [String: Any] {
        // 如果url不合法，则最大输入长度是17个字节
        guard urlContent.count >= 2 else {
            return [
                "msg": "Data format incorrect!",
                "result": [:]
            ]
        }
        
        guard urlContent.count <= 17 else {
            return [
                "msg": "Data format incorrect!",
                "result": [:]
            ]
        }
        
        return [
            "msg": "",
            "result": [
                "dataType": MKSwiftBXSlotConfigKey.advContentType,
                "params": [
                    "frameType": MKSwiftBXSlotConfigKey.urlData,
                    "urlHeader": header,
                    "urlContent": urlContent,
                    "urlExpansion": ""
                ]
            ]
        ]
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
        return MKSwiftUIAdaptor.createNormalLabel(font: MKFont.font(14.0), text: "URL")
    }()
    
    private lazy var urlTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = MKColor.rgb(111, 111, 111)
        label.font = MKFont.font(12.0)
        label.text = "http://www."
        label.layer.masksToBounds = true
        label.layer.borderWidth = 0.5
        label.layer.borderColor = MKColor.line.cgColor
        label.layer.cornerRadius = 2
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(urlTypeLabelPressed)))
        return label
    }()
    
    private lazy var textField: MKSwiftTextField = {
        let textField = MKSwiftTextField(textFieldType: .normal)
        textField.textColor = MKColor.defaultText
        textField.placeholder = "mokoblue.com/"
        textField.font = MKFont.font(15.0)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = MKColor.line.cgColor
        textField.layer.cornerRadius = 3
        return textField
    }()
}

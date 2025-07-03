//
//  MKSwiftBXScanSearchButton.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/24.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public protocol MKSwiftBXScanSearchButtonDelegate: AnyObject {
    func mk_bx_scanSearchButtonMethod()
    func mk_bx_scanSearchButtonClearMethod()
}

public class MKSwiftBXScanSearchButtonModel {
    public var placeholder: String?
    public var searchName: String?
    public var searchMac: String?
    public var searchRssi: Int = 0
    public var minSearchRssi: Int = 0
    
    public init() {}
}

public class MKSwiftBXScanSearchButton: UIControl {
    
    // MARK: - Properties
    public weak var delegate: MKSwiftBXScanSearchButtonDelegate?
    public var dataModel: MKSwiftBXScanSearchButtonModel? {
        didSet {
            updateContent()
        }
    }
    
    // MARK: - Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        searchIcon.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(searchIcon.snp.right).offset(10)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(15)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(clearButton.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(15)
        }
        
        clearButton.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.width.equalTo(45)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    // MARK: - Event Methods
    @objc private func clearButtonPressed() {
        titleLabel.isHidden = false
        searchIcon.isHidden = false
        searchLabel.isHidden = true
        clearButton.isHidden = true
        delegate?.mk_bx_scanSearchButtonClearMethod()
    }
    
    @objc private func searchButtonPressed() {
        delegate?.mk_bx_scanSearchButtonMethod()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        addSubview(searchIcon)
        addSubview(titleLabel)
        addSubview(searchLabel)
        addSubview(clearButton)
        addTarget(self,
                  action: #selector(searchButtonPressed),
                  for: .touchUpInside)
    }
    
    private func updateContent() {
        guard let model = dataModel else { return }
        
        titleLabel.text = model.placeholder ?? "Edit Filter"
        
        var conditions = [String]()
        if let name = model.searchName, !name.isEmpty {
            conditions.append(name)
        }
        if let mac = model.searchMac, !mac.isEmpty {
            conditions.append(mac)
        }
        if model.searchRssi > model.minSearchRssi {
            conditions.append("\(model.searchRssi)dBm")
        }
        
        if conditions.isEmpty {
            titleLabel.isHidden = false
            searchIcon.isHidden = false
            searchLabel.isHidden = true
            clearButton.isHidden = true
        } else {
            titleLabel.isHidden = true
            searchIcon.isHidden = true
            searchLabel.isHidden = false
            clearButton.isHidden = false
            searchLabel.text = conditions.joined(separator: ";")
        }
    }
    
    // MARK: - Lazy
    
    private lazy var searchIcon: UIImageView = {
        return UIImageView(image: moduleIcon(name: "mk_swift_bx_searchGrayIcon", in: .module))
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = "Edit Filter"
        return titleLabel
    }()
    private lazy var searchLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.textColor = .darkText
        searchLabel.textAlignment = .left
        searchLabel.font = UIFont.systemFont(ofSize: 15)
        searchLabel.isHidden = true
        return searchLabel
    }()
    private lazy var clearButton: UIButton = {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(moduleIcon(name: "mk_swift_bx_clearButtonIcon", in: .module), for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        clearButton.isHidden = true
        return clearButton
    }()
}

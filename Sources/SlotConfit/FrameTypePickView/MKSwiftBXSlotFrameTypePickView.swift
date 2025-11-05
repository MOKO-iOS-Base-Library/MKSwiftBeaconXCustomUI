//
//  MKSwiftBXSlotFrameTypePickView.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/25.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public protocol MKSwiftBXSlotFrameTypePickViewDelegate: AnyObject {
    func slotFrameTypeChanged(_ frameType: MKSwiftBXSlotFrameType)
}

// MARK: - Model
public class MKSwiftBXSlotFrameTypePickViewModel {
    public var frameName: String = ""
    public var frameType: MKSwiftBXSlotFrameType = .beacon
    
    public init() {}
}

// MARK: - Pick View

public class MKSwiftBXSlotFrameTypePickView: UIView {
    
    // MARK: - Properties
    
    public private(set) var frameType: MKSwiftBXSlotFrameType = .beacon
    public var dataList: [MKSwiftBXSlotFrameTypePickViewModel] = []
    public weak var delegate: MKSwiftBXSlotFrameTypePickViewDelegate?
    
    
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    // MARK: - Public Methods
    
    public func updateFrameType(_ frameType: MKSwiftBXSlotFrameType) {
        guard !dataList.isEmpty else { return }
        
        self.frameType = frameType
        pickerView.reloadAllComponents()
        
        if let selectedRow = dataList.firstIndex(where: { $0.frameType == frameType }) {
            pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        }
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        addSubview(backView)
        backView.addSubview(leftIcon)
        backView.addSubview(typeLabel)
        backView.addSubview(pickerView)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        leftIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(22)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).offset(15)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.height.equalTo(typeLabel.font.lineHeight)
        }
        
        pickerView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(100)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
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
        imageView.image = UIImage(named: "mk_bx_slotFrameType")
        return imageView
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Frame type"
        return label
    }()
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        picker.layer.masksToBounds = true
        picker.layer.borderColor = MKColor.navBar.cgColor
        picker.layer.borderWidth = 0.5
        picker.layer.cornerRadius = 4
        return picker
    }()
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension MKSwiftBXSlotFrameTypePickView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let titleLabel: UILabel = view as? UILabel ?? {
            let label = UILabel()
            label.textColor = .black
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            return label
        }()
        
        let model = dataList[row]
        if model.frameType == frameType {
            titleLabel.attributedText = attributedTitle(for: model)
        } else {
            titleLabel.text = model.frameName
        }
        
        return titleLabel
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let model = dataList[row]
        frameType = model.frameType
        pickerView.reloadAllComponents()
        
        delegate?.slotFrameTypeChanged(model.frameType)
    }
    
    private func attributedTitle(for model: MKSwiftBXSlotFrameTypePickViewModel) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: MKFont.font(13.0),
            .foregroundColor: MKColor.navBar
        ]
        return NSAttributedString(string: model.frameName, attributes: attributes)
    }
}

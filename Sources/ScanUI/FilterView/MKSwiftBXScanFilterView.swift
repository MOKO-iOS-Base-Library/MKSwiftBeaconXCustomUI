//
//  MKSwiftBXScanFilterView.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/24.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public class MKSwiftBXScanFilterView: UIView {
    
    // MARK: - Constants
    private let offsetX: CGFloat = 10.0
    private let backViewHeight: CGFloat = 400.0
    private let signalIconWidth: CGFloat = 17.0
    private let signalIconHeight: CGFloat = 15.0
    private let noteMsg1 = "* RSSI filtering is the highest priority filtering condition. BLE Name and MAC Address filtering must first meet the RSSI filtering condition."
    private let noteMsg2 = "* There is an \"OR\" relationship between the BLE Name filtering and the MAC Address filtering."
    
    // MARK: - Properties
    private var searchBlock: ((String, String, Int) -> Void)?
    
    // MARK: - Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor(white: 0, alpha: 0.1)
        setupUI()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("MKSwiftBXScanFilterView deinit")
    }
    
    // MARK: - Public Methods
    public static func showSearch(name: String?, macAddress: String?, rssi: Int, searchBlock: @escaping (String, String, Int) -> Void) {
        let view = MKSwiftBXScanFilterView()
        view.showSearch(name: name, macAddress: macAddress, rssi: rssi, searchBlock: searchBlock)
    }
    
    //MARK: - Event Methods
    @objc private func rssiValueChanged() {
        rssiValueLabel.text = String(format: "%.0fdBm", -100 - slider.value)
    }
    
    @objc private func dismiss() {
        nameTextField.resignFirstResponder()
        macTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25) {
            self.backView.transform = CGAffineTransform(translationX: 0, y: -self.backViewHeight)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc private func doneButtonPressed() {
        nameTextField.resignFirstResponder()
        macTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25) {
            self.backView.transform = CGAffineTransform(translationX: 0, y: -self.backViewHeight)
        } completion: { _ in
            let rssi = -100 - Int(self.slider.value)
            self.searchBlock?(self.nameTextField.text ?? "", self.macTextField.text ?? "", rssi)
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(nameTextField)
        backView.addSubview(macLabel)
        backView.addSubview(macTextField)
        backView.addSubview(minRssiLabel)
        backView.addSubview(rssiValueLabel)
        backView.addSubview(signalIcon)
        backView.addSubview(slider)
        backView.addSubview(graySignalIcon)
        backView.addSubview(maxLabel)
        backView.addSubview(minLabel)
        backView.addSubview(noteLabel1)
        backView.addSubview(noteLabel2)
        backView.addSubview(doneButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(offsetX)
            make.right.equalToSuperview().offset(-offsetX)
            make.height.equalTo(backViewHeight)
            make.top.equalToSuperview().offset(-backViewHeight)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(offsetX)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(30)
        }
        
        macLabel.snp.makeConstraints { make in
            make.left.width.height.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(30)
        }
        
        macTextField.snp.makeConstraints { make in
            make.left.right.height.equalTo(nameTextField)
            make.centerY.equalTo(macLabel)
        }
        
        minRssiLabel.snp.makeConstraints { make in
            make.left.width.equalTo(nameLabel)
            make.top.equalTo(macLabel.snp.bottom).offset(30)
            make.height.equalTo(25)
        }
        
        rssiValueLabel.snp.makeConstraints { make in
            make.left.equalTo(nameTextField)
            make.right.equalToSuperview().offset(-offsetX)
            make.centerY.equalTo(minRssiLabel)
            make.height.equalTo(25)
        }
        
        signalIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(offsetX)
            make.width.equalTo(signalIconWidth)
            make.height.equalTo(signalIconHeight)
            make.top.equalTo(minRssiLabel.snp.bottom).offset(30)
        }
        
        slider.snp.makeConstraints { make in
            make.left.equalTo(signalIcon.snp.right).offset(10)
            make.right.equalTo(graySignalIcon.snp.left).offset(-10)
            make.centerY.equalTo(signalIcon)
            make.height.equalTo(signalIconHeight)
        }
        
        graySignalIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-offsetX)
            make.width.height.equalTo(signalIcon)
            make.centerY.equalTo(signalIcon)
        }
        
        maxLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(offsetX)
            make.width.equalTo(50)
            make.top.equalTo(signalIcon.snp.bottom).offset(2)
            make.height.equalTo(13)
        }
        
        minLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-offsetX)
            make.width.equalTo(50)
            make.top.equalTo(signalIcon.snp.bottom).offset(2)
            make.height.equalTo(13)
        }
        
        let note1Size = noteMsg1.size(withFont: noteLabel1.font, maxSize: CGSize(width: (MKScreen.width - 4 * offsetX), height: .greatestFiniteMagnitude))
        
        noteLabel1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(offsetX)
            make.right.equalToSuperview().offset(-offsetX)
            make.top.equalTo(signalIcon.snp.bottom).offset(offsetX + 20)
            make.height.equalTo(note1Size.height)
        }
        
        let note2Size = noteMsg2.size(withFont: noteLabel2.font, maxSize: CGSize(width: (MKScreen.width - 4 * offsetX), height: .greatestFiniteMagnitude))
        
        noteLabel2.snp.makeConstraints { make in
            make.left.right.equalTo(noteLabel1)
            make.top.equalTo(noteLabel1.snp.bottom).offset(22)
            make.height.equalTo(note2Size.height)
        }
        
        doneButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(offsetX)
            make.right.equalToSuperview().offset(-offsetX)
            make.bottom.equalToSuperview().offset(-45)
            make.height.equalTo(45)
        }
    }
    
    private func showSearch(name: String?, macAddress: String?, rssi: Int, searchBlock: @escaping (String, String, Int) -> Void) {
        
        self.searchBlock = searchBlock
        nameTextField.text = name
        macTextField.text = macAddress
        slider.value = Float(-100 - rssi)
        rssiValueLabel.text = "\(rssi)dBm"
        
        MKApp.window?.addSubview(self)
        
        UIView.animate(withDuration: 0.25) {
            self.backView.transform = CGAffineTransform(translationX: 0, y: self.backViewHeight + 88)
        } completion: { _ in
            self.nameTextField.becomeFirstResponder()
        }
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    // MARK: - UI Components (Lazy loaded)
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6.0
        view.layer.shadowColor = UIColor.darkText.cgColor
        view.layer.shadowOffset = CGSize(width: 1.5, height: 3)
        view.layer.shadowOpacity = 0.8
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "BLE Name"
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.textColor = .darkText
        textField.placeholder = "1-20 characters"
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1).cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4.0
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private lazy var macLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.textAlignment = .left
        label.font = MKFont.font(14.0)
        label.text = "MAC Addr"
        return label
    }()
    
    private lazy var macTextField: MKSwiftTextField = {
        let textField = MKSwiftTextField(textFieldType: .normal)
        textField.borderStyle = .none
        textField.font = MKFont.font(13.0)
        textField.textColor = MKColor.defaultText
        textField.placeholder = "1-6bytes HEX"
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = MKColor.navBar.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4.0
        textField.layer.masksToBounds = true
        textField.maxLength = 20
        return textField
    }()
    
    private lazy var minRssiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.textAlignment = .left
        label.font = MKFont.font(14.0)
        label.text = "Min. RSSI"
        return label
    }()
    
    private lazy var rssiValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.textAlignment = .left
        label.font = MKFont.font(14.0)
        label.text = "-100dBm"
        
        let lineView = UIView()
        lineView.backgroundColor = .darkText
        lineView.frame = CGRect(x: 0, y: 24.5, width: UIScreen.main.bounds.width - 3 * 10 - 100 - 5, height: 0.5)
        label.addSubview(lineView)
        
        return label
    }()
    
    private lazy var signalIcon: UIImageView = {
        let imageView = UIImageView(image: moduleIcon(name: "mk_swift_bx_wifiSignalIcon", in: .module))
        return imageView
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 0
        slider.minimumValue = -100
        slider.value = -100
        slider.addTarget(self, action: #selector(rssiValueChanged), for: .valueChanged)
        return slider
    }()
    
    private lazy var graySignalIcon: UIImageView = {
        let imageView = UIImageView(image: moduleIcon(name: "mk_swift_bx_wifiGraySignalIcon", in: .module))
        return imageView
    }()
    
    private lazy var maxLabel: UILabel = {
        let label = UILabel()
        label.textColor = MKColor.rgb(15, 131, 255)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "0dBm"
        return label
    }()
    
    private lazy var minLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = MKFont.font(11.0)
        label.text = "-100dBm"
        return label
    }()
    
    private lazy var noteLabel1: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.font = MKFont.font(11.0)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = noteMsg1
        return label
    }()
    
    private lazy var noteLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.font = MKFont.font(11.0)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = noteMsg2
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
        button.layer.cornerRadius = 4.0
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return button
    }()
}

extension MKSwiftBXScanFilterView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self
    }
}

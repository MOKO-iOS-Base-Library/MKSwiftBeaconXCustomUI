//
//  MKSwiftBXTriggerHumidityView.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/25.
//

import UIKit

import SnapKit

import MKBaseSwiftModule
import MKSwiftCustomUI

public class MKSwiftBXTriggerHumidityViewModel {
    public var sliderValue: Float = 0
    public var above: Bool = false
    public var start: Bool = false
    
    public init() {}
}

public protocol MKSwiftBXTriggerHumidityViewDelegate: AnyObject {
    func triggerHumidityStartStatusChanged(_ start: Bool)
    func triggerHumidityThresholdValueChanged(_ sliderValue: Float)
}

public class MKSwiftBXTriggerHumidityView: UIView {
    
    // MARK: - Properties
    
    public weak var delegate: MKSwiftBXTriggerHumidityViewDelegate?
    
    public var dataModel: MKSwiftBXTriggerHumidityViewModel? {
        didSet {
            updateContent()
        }
    }
    
    private var startStatus: Bool = false
    
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
    
    // MARK: - UI Setup
    
    private func setupUI() {
        addSubview(msgLabel)
        addSubview(humiditySlider)
        addSubview(sliderValueLabel)
        addSubview(startIcon)
        addSubview(startLabel)
        addSubview(stopIcon)
        addSubview(stopLabel)
        addSubview(noteMsgLabel)
    }
    
    private func setupConstraints() {
        msgLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(UIFont.systemFont(ofSize: 13).lineHeight)
        }
        
        humiditySlider.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(sliderValueLabel.snp.left).offset(-5)
            make.top.equalTo(msgLabel.snp.bottom).offset(15)
            make.height.equalTo(10)
        }
        
        sliderValueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(50)
            make.centerY.equalTo(humiditySlider)
            make.height.equalTo(UIFont.systemFont(ofSize: 12).lineHeight)
        }
        
        startIcon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(10)
            make.centerY.equalTo(startLabel)
        }
        
        startLabel.snp.makeConstraints { make in
            make.left.equalTo(startIcon.snp.right).offset(2)
            make.right.equalToSuperview()
            make.top.equalTo(humiditySlider.snp.bottom).offset(10)
            make.height.equalTo(25)
        }
        
        stopIcon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(10)
            make.centerY.equalTo(stopLabel)
        }
        
        stopLabel.snp.makeConstraints { make in
            make.left.equalTo(stopIcon.snp.right).offset(2)
            make.right.equalToSuperview()
            make.top.equalTo(startLabel.snp.bottom).offset(10)
            make.height.equalTo(25)
        }
        
        noteMsgLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(stopLabel.snp.bottom).offset(5)
        }
    }
    
    // MARK: - Event Handlers
    
    @objc private func sliderValueChanged() {
        let value = String(format: "%.f", humiditySlider.value)
        sliderValueLabel.text = "\(value)%"
        updateNoteMsg()
        delegate?.triggerHumidityThresholdValueChanged(humiditySlider.value)
    }
    
    @objc private func startLabelPressed() {
        if startStatus { return }
        startStatus = true
        updateNoteMsg()
        updateSelectedIcon()
        delegate?.triggerHumidityStartStatusChanged(true)
    }
    
    @objc private func stopLabelPressed() {
        if !startStatus { return }
        startStatus = false
        updateNoteMsg()
        updateSelectedIcon()
        delegate?.triggerHumidityStartStatusChanged(false)
    }
    
    // MARK: - Private Methods
    
    private func updateContent() {
        guard let dataModel = dataModel else { return }
        
        startStatus = dataModel.start
        let value = String(format: "%.f", dataModel.sliderValue)
        sliderValueLabel.text = "\(value)%"
        humiditySlider.value = dataModel.sliderValue
        updateNoteMsg()
        updateSelectedIcon()
    }
    
    private func updateNoteMsg() {
        guard let dataModel = dataModel else { return }
        
        let msg = "*The Beacon will \(startStatus ? "start" : "stop") advertising when the humidity is \(dataModel.above ? "above" : "below") \(sliderValueLabel.text ?? "")"
        noteMsgLabel.text = msg
    }
    
    private func updateSelectedIcon() {
        startIcon.image = moduleIcon(name: startStatus ? "mk_swift_bx_slotConfigSelectedIcon" : "mk_swift_bx_slotConfigUnselectedIcon", in: .module)
        stopIcon.image = moduleIcon(name: startStatus ? "mk_swift_bx_slotConfigUnselectedIcon" : "mk_swift_bx_slotConfigSelectedIcon", in: .module)
    }
    
    // MARK: - UI Components (Lazy loading)
    
    private lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.textColor = MKColor.defaultText
        label.textAlignment = .left
        label.attributedText = MKSwiftUIAdaptor.createAttributedString(strings: ["Humidity threshold","   (0%~95%)"], fonts: [MKFont.font(13.0),MKFont.font(11.0)], colors: [MKColor.defaultText,MKColor.rgb(223, 223, 223)])
        
        return label
    }()
    
    private lazy var humiditySlider: MKSwiftSlider = {
        let slider = MKSwiftSlider()
        slider.maximumValue = 95
        slider.minimumValue = 0
        slider.value = 0
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    private lazy var sliderValueLabel: UILabel = {
        let label = MKSwiftUIAdaptor.createNormalLabel(font: MKFont.font(12.0),text: "0%")
        return label
    }()
    
    private lazy var startIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = moduleIcon(name: "mk_swift_bx_slotConfigSelectedIcon", in: .module)
        return imageView
    }()
    
    private lazy var startLabel: UILabel = {
        let label = MKSwiftUIAdaptor.createNormalLabel(font: MKFont.font(11.0),text: "Start advertising")
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startLabelPressed)))
        return label
    }()
    
    private lazy var stopIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = moduleIcon(name: "mk_swift_bx_slotConfigUnselectedIcon", in: .module)
        return imageView
    }()
    
    private lazy var stopLabel: UILabel = {
        let label = MKSwiftUIAdaptor.createNormalLabel(font: MKFont.font(11.0),text: "Stop advertising")
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stopLabelPressed)))
        return label
    }()
    
    private lazy var noteMsgLabel: UILabel = {
        let label = UILabel()
        label.textColor = MKColor.rgb(229, 173, 140)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = MKFont.font(11.0)
        return label
    }()
}

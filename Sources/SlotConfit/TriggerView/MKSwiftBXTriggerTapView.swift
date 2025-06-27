//
//  MKSwiftBXMKSwiftBXTriggerTapView.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/25.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public enum MKSwiftBXTriggerTapViewType: Int {
    case double
    case triple
    case deviceMoves
    case ambientLightDetected
    case single
    case tamperDetect
}

public class MKSwiftBXTriggerTapViewModel {
    /// 0:Start and keep advertising,1:Start advertising for,2:Stop advertising for
    private var _index: Int = 0
    public var index: Int {
        get { return _index }
        set { _index = newValue }
    }
    
    private var _viewType: MKSwiftBXTriggerTapViewType = .double
    public var viewType: MKSwiftBXTriggerTapViewType {
        get { return _viewType }
        set { _viewType = newValue }
    }
    
    private var _startValue: String?
    public var startValue: String? {
        get { return _startValue }
        set {
            _startValue = nil
            _startValue = newValue
        }
    }
    
    private var _stopValue: String?
    public var stopValue: String? {
        get { return _stopValue }
        set {
            _stopValue = nil
            _stopValue = newValue
        }
    }
    
    public init() {}
}

public protocol MKSwiftBXTriggerTapViewDelegate: AnyObject {
    
    /// 用户选择了触发方式
    /// - Parameters:
    ///   - index: 0:Start and keep advertising,1:Start advertising for,2:Stop advertising for
    ///   - viewType: 当前触发回调的view类型
    func MKSwiftBXTriggerTapViewIndexChanged(_ index: Int, viewType: MKSwiftBXTriggerTapViewType)
    
    /// index=1的时候，输入框的值
    func MKSwiftBXTriggerTapViewStartValueChanged(_ startValue: String, viewType: MKSwiftBXTriggerTapViewType)
    /// index=2的时候，输入框的值
    func MKSwiftBXTriggerTapViewStopValueChanged(_ stopValue: String, viewType: MKSwiftBXTriggerTapViewType)
}

public class MKSwiftBXTriggerTapView: UIView {
    
    public weak var delegate: MKSwiftBXTriggerTapViewDelegate?
    
    public var dataModel: MKSwiftBXTriggerTapViewModel? {
        didSet {
            updateContent()
        }
    }
    
    private var currentIndex: Int = 0
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
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
        addSubview(icon1)
        addSubview(icon2)
        addSubview(icon4)
        addSubview(msgLabel1)
        addSubview(msgLabel2)
        addSubview(msgLabel4)
        addSubview(unitLabel1)
        addSubview(unitLabel2)
        addSubview(startField)
        addSubview(stopField)
        addSubview(noteMsgLabel)
    }
    
    private func setupConstraints() {
        let textFieldWidth: CGFloat = 65
        let unitLabelWidth: CGFloat = 75
        let msgLabelWidth = bounds.width - textFieldWidth - unitLabelWidth - 15 - 10
        
        icon1.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        msgLabel1.snp.makeConstraints { make in
            make.left.equalTo(icon1.snp.right).offset(2)
            make.width.equalTo(msgLabelWidth)
            make.top.equalToSuperview().offset(5)
        }
        
        icon1.snp.makeConstraints { make in
            make.centerY.equalTo(msgLabel1.snp.centerY)
        }
        
        icon2.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        msgLabel2.snp.makeConstraints { make in
            make.left.equalTo(icon2.snp.right).offset(2)
            make.width.equalTo(msgLabelWidth)
            make.top.equalTo(msgLabel1.snp.bottom).offset(10)
        }
        
        icon2.snp.makeConstraints { make in
            make.centerY.equalTo(msgLabel2.snp.centerY)
        }
        
        startField.snp.makeConstraints { make in
            make.right.equalTo(unitLabel1.snp.left).offset(-1)
            make.width.equalTo(textFieldWidth)
            make.centerY.equalTo(msgLabel2.snp.centerY)
            make.height.equalTo(25)
        }
        
        unitLabel1.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(unitLabelWidth)
            make.centerY.equalTo(msgLabel2.snp.centerY)
            make.height.equalTo(25)
        }
        
        icon4.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        msgLabel4.snp.makeConstraints { make in
            make.left.equalTo(icon4.snp.right).offset(2)
            make.width.equalTo(msgLabelWidth)
            make.top.equalTo(msgLabel2.snp.bottom).offset(10)
        }
        
        icon4.snp.makeConstraints { make in
            make.centerY.equalTo(msgLabel4.snp.centerY)
        }
        
        stopField.snp.makeConstraints { make in
            make.right.equalTo(unitLabel2.snp.left).offset(-1)
            make.width.equalTo(textFieldWidth)
            make.centerY.equalTo(msgLabel4.snp.centerY)
            make.height.equalTo(25)
        }
        
        unitLabel2.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(unitLabelWidth)
            make.centerY.equalTo(msgLabel4.snp.centerY)
            make.height.equalTo(25)
        }
        
        noteMsgLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(stopField.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: - Actions
    
    @objc private func msgLabel1Pressed() {
        if currentIndex == 0 { return }
        currentIndex = 0
        updateSelectedIcon()
        updateNoteMsg()
        delegate?.MKSwiftBXTriggerTapViewIndexChanged(currentIndex, viewType: dataModel?.viewType ?? .double)
    }
    
    @objc private func msgLabel2Pressed() {
        if currentIndex == 1 { return }
        currentIndex = 1
        updateSelectedIcon()
        updateNoteMsg()
        delegate?.MKSwiftBXTriggerTapViewIndexChanged(currentIndex, viewType: dataModel?.viewType ?? .double)
    }
    
    @objc private func msgLabel4Pressed() {
        if currentIndex == 2 { return }
        currentIndex = 2
        updateSelectedIcon()
        updateNoteMsg()
        delegate?.MKSwiftBXTriggerTapViewIndexChanged(currentIndex, viewType: dataModel?.viewType ?? .double)
    }
    
    @objc private func startTextFieldValueChanged(text:String) {
        guard currentIndex == 1 else { return }
        updateNoteMsg()
        delegate?.MKSwiftBXTriggerTapViewStartValueChanged(text, viewType: dataModel?.viewType ?? .double)
    }
    
    @objc private func stopTextFieldValueChanged(text:String) {
        guard currentIndex == 2 else { return }
        updateNoteMsg()
        delegate?.MKSwiftBXTriggerTapViewStopValueChanged(text, viewType: dataModel?.viewType ?? .double)
    }
    
    // MARK: - Helper Methods
    
    private func createMessageLabel() -> UILabel {
        let label = UILabel()
        label.textColor = Color.defaultText
        label.textAlignment = .left
        label.font = Font.MKFont(11.0)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }
    
    private func createTextField() -> UITextField {
        let field = UITextField()
        field.textColor = .black
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 12)
        field.borderStyle = .none
        field.keyboardType = .numberPad
        
        let lineView = UIView()
        lineView.backgroundColor = .black
        field.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return field
    }
    
    private func attributedUnitText() -> NSAttributedString {
        return MKSwiftUIAdaptor.createAttributedString(strings: ["s","   (1~65535)"], fonts: [Font.MKFont(11),Font.MKFont(10)], colors: [Color.defaultText,Color.rgb(223, 223, 223)])
    }
    
    private func updateSelectedIcon() {
        icon1.image = moduleIcon(name: currentIndex == 0 ? "mk_swift_bx_slotConfigSelectedIcon" : "mk_swift_bx_slotConfigUnselectedIcon")
        icon2.image = moduleIcon(name: currentIndex == 1 ? "mk_swift_bx_slotConfigSelectedIcon" : "mk_swift_bx_slotConfigUnselectedIcon")
        icon4.image = moduleIcon(name: currentIndex == 2 ? "mk_swift_bx_slotConfigSelectedIcon" : "mk_swift_bx_slotConfigUnselectedIcon")
    }
    
    private func updateNoteMsg() {
        guard let dataModel = dataModel else { return }
        
        switch dataModel.viewType {
        case .deviceMoves:
            updateDeviceMovesNote()
        case .ambientLightDetected:
            updateAmbientLightNote()
        case .single:
            updateSingleTapNote()
        case .tamperDetect:
            updateTamperDetectNote()
        default:
            updateMultiTapNote()
        }
        
        setNeedsLayout()
    }
    
    private func updateDeviceMovesNote() {
        switch currentIndex {
        case 0:
            noteMsgLabel.text = "*The Beacon will start and keep advertising once a movement occurred."
        case 1:
            noteMsgLabel.text = "*The Beacon will start advertising after device keep static for \(startField.text ?? "")s and it stops broadcasting again once a movement occurred."
        case 2:
            noteMsgLabel.text = "*The Beacon will stop advertising after device keep static for \(stopField.text ?? "")s and it starts advertising again once a movement occurred."
        default:
            break
        }
    }
    
    private func updateAmbientLightNote() {
        switch currentIndex {
        case 0:
            noteMsgLabel.text = "*The Beacon will start and keep advertising after ambient light detected."
        case 1:
            noteMsgLabel.text = "*The Beacon will start advertising after device detected ambient light continuously for \(startField.text ?? "")s."
        case 2:
            noteMsgLabel.text = "*The Beacon will stop advertising after device detected ambient light continuously for \(stopField.text ?? "")s."
        default:
            break
        }
    }
    
    private func updateSingleTapNote() {
        switch currentIndex {
        case 0:
            noteMsgLabel.text = "*The Beacon will start and keep advertising after single click button."
        case 1:
            noteMsgLabel.text = "*The Beacon will start advertising for \(startField.text ?? "")s after single click button."
        case 2:
            noteMsgLabel.text = "*The Beacon will stop advertising for \(stopField.text ?? "")s after single click button."
        default:
            break
        }
    }
    
    private func updateTamperDetectNote() {
        switch currentIndex {
        case 0:
            noteMsgLabel.text = "*The Beacon will start and keep advertising after the tamper wire is disconnected"
        case 1:
            noteMsgLabel.text = "*The Beacon will start advertising for \(startField.text ?? "")s after the tamper wire is disconnected"
        case 2:
            noteMsgLabel.text = "*The Beacon will stop advertising for \(stopField.text ?? "")s after the tamper wire is disconnected"
        default:
            break
        }
    }
    
    private func updateMultiTapNote() {
        let typeString = dataModel?.viewType == .triple ? "three times" : "twice"
        
        switch currentIndex {
        case 0:
            noteMsgLabel.text = "*The Beacon will start and keep advertising after press the button \(typeString)."
        case 1:
            noteMsgLabel.text = "*The Beacon will start advertising for \(startField.text ?? "")s after press the button \(typeString)."
        case 2:
            noteMsgLabel.text = "*The Beacon will stop advertising for \(stopField.text ?? "")s after press the button \(typeString)."
        default:
            break
        }
    }
    
    private func updateContent() {
        guard let dataModel = dataModel else { return }
        
        currentIndex = dataModel.index
        startField.text = dataModel.startValue
        stopField.text = dataModel.stopValue
        
        updateSelectedIcon()
        updateNoteMsg()
        
        switch dataModel.viewType {
        case .deviceMoves:
            msgLabel2.text = "Start advertising after device keep static for"
            msgLabel4.text = "Stop advertising after device keep static for"
        case .ambientLightDetected:
            msgLabel2.text = "Start advertising after ambient light continuously detected for"
            msgLabel4.text = "Stop advertising after ambient light continuously detected for"
        default:
            msgLabel2.text = "Start advertising for"
            msgLabel4.text = "Stop advertising for"
        }
        
        setNeedsLayout()
    }
    
    // MARK: - UI Components
    
    private lazy var icon1: UIImageView = {
        let view = UIImageView()
        view.image = moduleIcon(name: "mk_swift_bx_slotConfigSelectedIcon")
        return view
    }()
    
    private lazy var icon2: UIImageView = {
        let view = UIImageView()
        view.image = moduleIcon(name: "mk_swift_bx_slotConfigUnselectedIcon")
        return view
    }()
    
    private lazy var icon4: UIImageView = {
        let view = UIImageView()
        view.image = moduleIcon(name: "mk_swift_bx_slotConfigUnselectedIcon")
        return view
    }()
    
    private lazy var msgLabel1: UILabel = {
        let label = createMessageLabel()
        label.text = "Start and keep advertising"
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(msgLabel1Pressed)))
        return label
    }()
    
    private lazy var msgLabel2: UILabel = {
        let label = createMessageLabel()
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(msgLabel2Pressed)))
        return label
    }()
    
    private lazy var msgLabel4: UILabel = {
        let label = createMessageLabel()
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(msgLabel4Pressed)))
        return label
    }()
    
    private lazy var unitLabel1: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.attributedText = attributedUnitText()
        return label
    }()
    
    private lazy var unitLabel2: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.attributedText = attributedUnitText()
        return label
    }()
    
    private lazy var startField: MKSwiftTextField = {
        let field = MKSwiftTextField(textFieldType: .realNumberOnly)
        field.textChangedBlock = { [weak self] text in
            self?.startTextFieldValueChanged(text: text)
        }
        field.textColor = Color.defaultText
        field.textAlignment = .center
        field.font = Font.MKFont(12.0)
        field.borderStyle = .none
        field.text = "30"
        field.maxLength = 5
        
        
        let lineView = UIView()
        lineView.backgroundColor = Color.line
        field.addSubview(lineView)
        field.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
        return field
    }()
    
    private lazy var stopField: UITextField = {
        let field = MKSwiftTextField(textFieldType: .realNumberOnly)
        field.textChangedBlock = { [weak self] text in
            self?.stopTextFieldValueChanged(text: text)
        }
        field.textColor = Color.defaultText
        field.textAlignment = .center
        field.font = Font.MKFont(12.0)
        field.borderStyle = .none
        field.text = "30"
        field.maxLength = 5
        
        
        let lineView = UIView()
        lineView.backgroundColor = Color.line
        field.addSubview(lineView)
        field.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
        return field
    }()
    
    private lazy var noteMsgLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.rgb(229, 173, 140)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = Font.MKFont(11.0)
        return label
    }()
}

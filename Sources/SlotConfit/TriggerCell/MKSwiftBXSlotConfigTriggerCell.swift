//
//  MKSwiftBXSlotConfigTriggerCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/25.
//

import UIKit
import SnapKit
import MKBaseSwiftModule

public class MKSwiftBXSlotConfigTriggerCellModel {
    
    /// 软件版本是否包含BXP-C字符
    public var isBXPC: Bool = false
    
    /// 固件版本是否包含BXP-DH01或BXP-DH_W7或BXP-D04
    public var tamperDetect: Bool = false
    
    /// 是否打开触发条件
    public var isOn: Bool = false
    
    /// 00:无触发,01:温度触发,02:湿度触发.03:双击触发.04:三击触发.05:移动触发.06:光感触发.07:单击触发.08:防拆
    public var type: String = "00"
    
    /// 00:无传感器,01:带LIS3DH3轴加速度计,02:带SHT3X温湿度传感器,03:同时带有LIS3DH及SHT3X传感器,04:带光感,05:同时带有LIS3DH3轴加速度计和光感
    public var deviceType: String = "00"
    /*
     触发条件，根据type类型展示不同的值
     //无触发条件
     type=00,conditions = @{},
     
     //温度触发
     type=01,conditions = @{
     @"above":@(YES),       //YES:高于temperature值，NO:低于temperature值
     @"temperature":@"15.0",    //当前触发温度值
     @"start":@(YES),       //YES:开始广播，NO:停止广播
     }
     
     //湿度触发
     type=02,conditions = @{
     @"above":@(YES),       //YES:高于humidity值，NO:低于humidity值
     @"humidity":@"1.0",    //当前触发湿度值
     @"start":@(YES),       //YES:开始广播，NO:停止广播
     }
     
     //双击触发
     type=03,conditions = @{
     @"time":@"3",          //持续时长
     @"start":@(YES),       //YES:开始广播，NO:停止广播
     }
     
     //三击触发
     type=04,conditions = @{
     @"time":@"3",          //持续时长
     @"start":@(YES),       //YES:开始广播，NO:停止广播
     }
     
     //移动触发
     type=05,conditions = @{
     @"time":@"3",          //持续时长
     @"start":@(YES),       //YES:开始广播，NO:停止广播
     }
     
     //光感触发
     type=06,conditions = @{
     @"time":@"3",          //持续时长
     @"start":@(YES),       //YES:开始广播，NO:停止广播
     }
     
     //单击触发
     type=07,conditions = @{
     @"time":@"3",          //持续时长
     @"start":@(YES),       //YES:开始广播，NO:停止广播
     }
     */
    public var conditions: [String: Any] = [:]
    
    public init() {}
}

public protocol MKSwiftBXSlotConfigTriggerCellDelegate: AnyObject {
    func triggerSwitchStatusChanged(_ isOn: Bool)
}

public class MKSwiftBXSlotConfigTriggerCell: MKSwiftBaseCell, @preconcurrency MKSwiftBXSlotConfigCellProtocol {
    
    //MARK: - MKSwiftBXSlotConfigCellProtocol
    public func slotConfigCellParams() -> [String : Any] {
        return getSlotConfigParams()
    }
    
    
    // MARK: - Properties
    
    public weak var delegate: MKSwiftBXSlotConfigTriggerCellDelegate?
    
    public var dataModel: MKSwiftBXSlotConfigTriggerCellModel? {
        didSet {
            updateContent()
        }
    }
    
    private var selectedTriggerIndex: Int = 0
    private var triggerTypeList: [String] = []
    
    public class func initCell(with tableView: UITableView) -> MKSwiftBXSlotConfigTriggerCell {
        let identifier = "MKSwiftBXSlotConfigTriggerCellIdenty"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MKSwiftBXSlotConfigTriggerCell
        if cell == nil {
            cell = MKSwiftBXSlotConfigTriggerCell(style: .default, reuseIdentifier: identifier)
        }
        return cell!
    }
    
    // MARK: - Initialization
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
    
    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.addSubview(leftIcon)
        contentView.addSubview(msgLabel)
        contentView.addSubview(switchButton)
        contentView.addSubview(triggerTypeLabel)
        contentView.addSubview(triggerLabel)
        contentView.addSubview(temperView)
        contentView.addSubview(humidityView)
        contentView.addSubview(doubleTapView)
        contentView.addSubview(tripleTapView)
        contentView.addSubview(movesView)
        contentView.addSubview(lightDetectedView)
        contentView.addSubview(singleTapView)
        contentView.addSubview(tamperDetectView)
    }
    
    private func setupConstraints() {
        leftIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(22)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(22)
        }
        
        msgLabel.snp.makeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).offset(5)
            make.right.equalTo(switchButton.snp.left).offset(-5)
            make.centerY.equalTo(leftIcon)
            make.height.equalTo(UIFont.systemFont(ofSize: 15).lineHeight)
        }
        
        switchButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(40)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
        
        triggerTypeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(100)
            make.centerY.equalTo(triggerLabel)
            make.height.equalTo(MKFont.font(15.0).lineHeight)
        }
        
        triggerLabel.snp.makeConstraints { make in
            make.left.equalTo(triggerTypeLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(switchButton.snp.bottom).offset(10)
            make.height.equalTo(25)
        }
        
        temperView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(triggerLabel.snp.bottom).offset(5)
            make.height.equalTo(230)
        }
        
        [humidityView, doubleTapView, tripleTapView, movesView, lightDetectedView, singleTapView, tamperDetectView].forEach {
            $0.snp.makeConstraints { make in
                make.edges.equalTo(temperView)
            }
        }
    }
    
    // MARK: - Event Handlers
    
    @objc private func switchButtonPressed() {
        switchButton.isSelected = !switchButton.isSelected
        updateSwitchButtonIcon()
        delegate?.triggerSwitchStatusChanged(switchButton.isSelected)
    }
    
    @objc private func triggerLabelPressed() {
        var index = 0
        for i in 0..<triggerTypeList.count {
            if triggerLabel.text == triggerTypeList[i] {
                index = i
                break
            }
        }
        
        let pickerView = MKSwiftPickerView()
        pickerView.showPickView(with: triggerTypeList, selectedRow: index) { [weak self] currentRow in
            guard let self = self else { return }
            self.triggerLabel.text = self.triggerTypeList[currentRow]
            self.selectedTriggerIndex = currentRow
            self.setupUIForSelectedTrigger()
        }
    }
    
    // MARK: - Private Methods
    
    private func updateContent() {
        guard let dataModel = dataModel else { return }
        
        triggerTypeList.removeAll()
        loadTriggerTypes()
        switchButton.isSelected = dataModel.isOn
        updateSwitchButtonIcon()
        updateSelectedTriggerIndex()
        reloadSubViews()
    }
    
    private func reloadSubViews() {
        if switchButton.isSelected {
            //开关打开
            triggerTypeLabel.isHidden = false
            triggerLabel.isHidden = false
            setupUIForSelectedTrigger()
            return
        }
        //开关关闭
        [triggerTypeLabel, triggerLabel, temperView, humidityView, doubleTapView,
         tripleTapView, movesView, lightDetectedView, singleTapView, tamperDetectView].forEach {
            $0.isHidden = true
        }
    }
    
    private func setupUIForSelectedTrigger() {
        guard selectedTriggerIndex < triggerTypeList.count else { return }
        
        let trigger = triggerTypeList[selectedTriggerIndex]
        triggerLabel.text = trigger
        
        // Hide all views first
        [temperView, humidityView, doubleTapView, tripleTapView, movesView,
         lightDetectedView, singleTapView, tamperDetectView].forEach { $0.isHidden = true }
        
        switch trigger {
        case "Single click button":
            setupTapView(tapView: singleTapView, tapViewModel: singleTapViewModel)
        case "Press button twice":
            setupTapView(tapView: doubleTapView, tapViewModel: doubleTapViewModel)
        case "Press button three times":
            setupTapView(tapView: tripleTapView, tapViewModel: tripleTapViewModel)
        case "Temperature above", "Temperature below":
            setupTemperatureView()
        case "Humidity above", "Humidity below":
            setupHumidityView()
        case "Device moves":
            setupMovesView()
        case "Ambient light detected":
            setupTapView(tapView: lightDetectedView, tapViewModel: lightDetectedViewModel)
        case "Tamper detect":
            setupTapView(tapView: tamperDetectView, tapViewModel: tamperDetectViewModel)
        default:
            break
        }
    }
    
    private func setupTapView(tapView: MKSwiftBXTriggerTapView,
                              tapViewModel: MKSwiftBXTriggerTapViewModel) {
        var index = 0
        var startValue = "30"
        var stopValue = "30"
        
        if let conditions = dataModel?.conditions, !conditions.isEmpty {
            let start = conditions["start"] as? Bool ?? false
            let time = conditions["time"] as? String ?? "0"
            
            if Int(time)! > 0 {
                if start {
                    index = 1
                    startValue = time
                } else {
                    index = 2
                    stopValue = time
                }
            }
        }
        
        tapViewModel.index = index
        tapViewModel.startValue = startValue
        tapViewModel.stopValue = stopValue
        tapView.isHidden = false
        tapView.dataModel = tapViewModel
    }
    
    private func setupTemperatureView() {
        if let conditions = dataModel?.conditions, !conditions.isEmpty {
            temperViewModel.sliderValue = (conditions["temperature"] as? NSNumber)?.floatValue ?? 0
            temperViewModel.above = (selectedTriggerIndex == 2)
            temperViewModel.start = (conditions["start"] as? NSNumber)?.boolValue ?? false
        }
        temperView.isHidden = false
        temperView.dataModel = temperViewModel
    }
    
    private func setupHumidityView() {
        if let conditions = dataModel?.conditions, !conditions.isEmpty {
            humidityViewModel.sliderValue = (conditions["humidity"] as? NSNumber)?.floatValue ?? 0
            temperViewModel.above = (selectedTriggerIndex == 4)
            temperViewModel.start = (conditions["start"] as? NSNumber)?.boolValue ?? false
        }
        humidityView.isHidden = false
        humidityView.dataModel = humidityViewModel
    }
    
    private func setupMovesView() {
        var index = 0
        var startValue = "30"
        var stopValue = "30"
        
        if let conditions = dataModel?.conditions, !conditions.isEmpty {
            let start = conditions["start"] as? Bool ?? false
            let time = conditions["time"] as? String ?? "0"
            
            if Int(time)! > 0 {
                if start {
                    index = 2
                    stopValue = time
                } else {
                    index = 1
                    startValue = time
                }
            }
        }
        
        movesViewModel.index = index
        movesViewModel.startValue = startValue
        movesViewModel.stopValue = stopValue
        movesView.isHidden = false
        movesView.dataModel = movesViewModel
    }
    
    private func updateSwitchButtonIcon() {
        let iconName = switchButton.isSelected ? "mk_swift_bx_switchSelectedIcon" : "mk_swift_bx_switchUnselectedIcon"
        switchButton.setImage(moduleIcon(name: iconName, in: .module), for: .normal)
    }
    
    private func loadTriggerTypes() {
        guard let dataModel = dataModel else { return }
        
        if !dataModel.isBXPC {
            triggerTypeList.append("Single click button")
        }
        
        triggerTypeList.append("Press button twice")
        triggerTypeList.append("Press button three times")
        
        switch dataModel.deviceType {
        case "01":
            //带LIS3DH3轴加速度计
            triggerTypeList.append("Device moves")
        case "02":
            triggerTypeList.append("Temperature above")
            triggerTypeList.append("Temperature below")
            triggerTypeList.append("Humidity above")
            triggerTypeList.append("Humidity below")
        case "03":
            //同时带有LIS3DH及SHT3X传感器
            triggerTypeList.append("Temperature above")
            triggerTypeList.append("Temperature below")
            triggerTypeList.append("Humidity above")
            triggerTypeList.append("Humidity below")
            triggerTypeList.append("Device moves")
        case "04":
            //带光感
            triggerTypeList.append("Ambient light detected")
        case "05":
            //同时带有LIS3DH3轴加速度计和光感
            triggerTypeList.append("Device moves")
            triggerTypeList.append("Ambient light detected")
        default:
            break
        }
        
        if dataModel.tamperDetect {
            triggerTypeList.append("Tamper detect")
        }
    }
    
    private func updateSelectedTriggerIndex() {
        guard let dataModel = dataModel, !dataModel.conditions.isEmpty else {
            return
        }
        
        switch dataModel.type {
        case "01":
            //温度
            let above = dataModel.conditions["above"] as? Bool ?? false
            selectedTriggerIndex = above ?
                triggerTypeList.firstIndex(of: "Temperature above") ?? 0 :
                triggerTypeList.firstIndex(of: "Temperature below") ?? 0
        case "02":
            //湿度
            let above = dataModel.conditions["above"] as? Bool ?? false
            selectedTriggerIndex = above ?
                triggerTypeList.firstIndex(of: "Humidity above") ?? 0 :
                triggerTypeList.firstIndex(of: "Humidity below") ?? 0
        case "03":
            //双击
            selectedTriggerIndex = triggerTypeList.firstIndex(of: "Press button twice") ?? 0
        case "04":
            //三击
            selectedTriggerIndex = triggerTypeList.firstIndex(of: "Press button three times") ?? 0
        case "05":
            //移动触发
            selectedTriggerIndex = triggerTypeList.firstIndex(of: "Device moves") ?? 0
        case "06":
            //光感
            selectedTriggerIndex = triggerTypeList.firstIndex(of: "Ambient light detected") ?? 0
        case "07":
            //单击
            selectedTriggerIndex = triggerTypeList.firstIndex(of: "Single click button") ?? 0
        case "08":
            //防拆
            selectedTriggerIndex = triggerTypeList.firstIndex(of: "Tamper detect") ?? 0
        default:
            break
        }
    }
    
    // MARK: - Public Method
    
    private func getSlotConfigParams() -> [String: Any] {
        guard switchButton.isSelected else {
            //关闭触发
            return [
                "msg": "",
                "result": [
                    "dataType": MKSwiftBXSlotConfigKey.advTriggerType,
                    "params": [
                        "isOn": false,
                        "triggerParams": [:]
                    ]
                ]
            ]
        }
        
        guard selectedTriggerIndex < triggerTypeList.count else {
            return ["msg": "Params Error", "result": [:]]
        }
        //打开触发，需要根据不同的触发方式校验参数
        let trigger = triggerTypeList[selectedTriggerIndex]
        
        switch trigger {
        case "Single click button":
            return getTapViewParams(view: singleTapView)
        case "Press button twice":
            return getTapViewParams(view: doubleTapView)
        case "Press button three times":
            return getTapViewParams(view: tripleTapView)
        case "Temperature above", "Temperature below":
            return getTemperatureViewParams()
        case "Humidity above", "Humidity below":
            return getHumidityViewParams()
        case "Device moves":
            return getTapViewParams(view: movesView)
        case "Ambient light detected":
            return getTapViewParams(view: lightDetectedView)
        case "Tamper detect":
            return getTapViewParams(view: tamperDetectView)
        default:
            return ["msg": "Params Error", "result": [:]]
        }
    }
    
    private func getTapViewParams(view: MKSwiftBXTriggerTapView) -> [String: Any] {
        var tempModel = doubleTapViewModel
        var triggerType = "03"
        
        if view == tripleTapView {
            triggerType = "04"
            tempModel = tripleTapViewModel
        }else if view == movesView {
            triggerType = "05"
            tempModel = movesViewModel
        }else if view == lightDetectedView {
            triggerType = "06"
            tempModel = lightDetectedViewModel
        }else if view == singleTapView {
            triggerType = "07"
            tempModel = singleTapViewModel
        }else if view == tamperDetectView {
            triggerType = "08"
            tempModel = tamperDetectViewModel
        }
        
        var error = false
        if tempModel.index == 1 && (!MKValid.isStringValid(tempModel.startValue) || Int(tempModel.startValue!)! < 1 || Int(tempModel.startValue!)! > 65535) {
            error = true
        }else if tempModel.index == 2 && (!MKValid.isStringValid(tempModel.stopValue) || Int(tempModel.stopValue!)! < 1 || Int(tempModel.stopValue!)! > 65535) {
            error = true
        }
        
        if error {
            // start和stop
            return [
                "msg": "Params Error",
                "result": [:]
            ]
        }
        
        var timeValue: String = "00"
        if tempModel.index == 1 {
            timeValue = tempModel.startValue!
        }else if tempModel.index == 2 {
            timeValue = tempModel.stopValue!
        }
        var start = (tempModel.index != 2)
        if (view == movesView) {
            start = (tempModel.index != 1)
        }
        
        return [
            "msg": "",
            "result": [
                "dataType": MKSwiftBXSlotConfigKey.advTriggerType,
                "params": [
                    "isOn": true,
                    "triggerParams": [
                        "triggerType": triggerType,
                        "conditions": [
                            "time": timeValue,
                            "start": start
                        ]
                    ]
                ]
            ]
        ]
    }
    
    private func getTemperatureViewParams() -> [String: Any] {
        let temperature = String(format: "%.f", temperViewModel.sliderValue)
        
        return [
            "msg": "",
            "result": [
                "dataType": MKSwiftBXSlotConfigKey.advTriggerType,
                "params": [
                    "isOn": true,
                    "triggerParams": [
                        "triggerType": "01",
                        "conditions": [
                            "above": temperViewModel.above,
                            "temperature": temperature,
                            "start": temperViewModel.start
                        ]
                    ]
                ]
            ]
        ]
    }
    
    private func getHumidityViewParams() -> [String: Any] {
        let humidity = String(format: "%.f", humidityViewModel.sliderValue)
        
        return [
            "msg": "",
            "result": [
                "dataType": MKSwiftBXSlotConfigKey.advTriggerType,
                "params": [
                    "isOn": true,
                    "triggerParams": [
                        "triggerType": "02",
                        "conditions": [
                            "above": humidityViewModel.above,
                            "humidity": humidity,
                            "start": humidityViewModel.start
                        ]
                    ]
                ]
            ]
        ]
    }
    
    // MARK: - UI Components (Lazy loading)
    
    private lazy var leftIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = moduleIcon(name: "mk_swift_bx_slotParamsTriggerIcon", in: .module)
        return imageView
    }()
    
    private lazy var msgLabel: UILabel = {
        let label = MKSwiftUIAdaptor.createNormalLabel(text: "Trigger")
        return label
    }()
    
    private lazy var switchButton: UIButton = {
        let button = UIButton()
        button.setImage(moduleIcon(name: "mk_swift_bx_switchUnselectedIcon", in: .module), for: .normal)
        button.addTarget(self,
                         action: #selector(switchButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var triggerTypeLabel: UILabel = {
        let label = MKSwiftUIAdaptor.createNormalLabel(text: "Trigger type")
        label.isHidden = true
        return label
    }()
    
    private lazy var triggerLabel: UILabel = {
        let label = MKSwiftUIAdaptor.createNormalLabel(font: MKFont.font(13.0),text: "Press button twice")
        label.isHidden = true
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(triggerLabelPressed)))
        return label
    }()
    
    private lazy var temperView: MKSwiftBXTriggerTemperatureView = {
        let view = MKSwiftBXTriggerTemperatureView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private lazy var temperViewModel: MKSwiftBXTriggerTemperatureViewModel = {
        return MKSwiftBXTriggerTemperatureViewModel()
    }()
    
    private lazy var humidityView: MKSwiftBXTriggerHumidityView = {
        let view = MKSwiftBXTriggerHumidityView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private lazy var humidityViewModel: MKSwiftBXTriggerHumidityViewModel = {
        return MKSwiftBXTriggerHumidityViewModel()
    }()
    
    private lazy var doubleTapView: MKSwiftBXTriggerTapView = {
        let view = MKSwiftBXTriggerTapView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private lazy var doubleTapViewModel: MKSwiftBXTriggerTapViewModel = {
        let model = MKSwiftBXTriggerTapViewModel()
        model.viewType = .double
        return model
    }()
    
    private lazy var tripleTapView: MKSwiftBXTriggerTapView = {
        let view = MKSwiftBXTriggerTapView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private lazy var tripleTapViewModel: MKSwiftBXTriggerTapViewModel = {
        let model = MKSwiftBXTriggerTapViewModel()
        model.viewType = .triple
        return model
    }()
    
    private lazy var movesView: MKSwiftBXTriggerTapView = {
        let view = MKSwiftBXTriggerTapView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private lazy var movesViewModel: MKSwiftBXTriggerTapViewModel = {
        let model = MKSwiftBXTriggerTapViewModel()
        model.viewType = .deviceMoves
        return model
    }()
    
    private lazy var lightDetectedView: MKSwiftBXTriggerTapView = {
        let view = MKSwiftBXTriggerTapView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private lazy var lightDetectedViewModel: MKSwiftBXTriggerTapViewModel = {
        let model = MKSwiftBXTriggerTapViewModel()
        model.viewType = .ambientLightDetected
        return model
    }()
    
    private lazy var singleTapView: MKSwiftBXTriggerTapView = {
        let view = MKSwiftBXTriggerTapView()
        view.delegate = self
        return view
    }()
    
    private lazy var singleTapViewModel: MKSwiftBXTriggerTapViewModel = {
        let model = MKSwiftBXTriggerTapViewModel()
        model.viewType = .single
        return model
    }()
    
    private lazy var tamperDetectView: MKSwiftBXTriggerTapView = {
        let view = MKSwiftBXTriggerTapView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private lazy var tamperDetectViewModel: MKSwiftBXTriggerTapViewModel = {
        let model = MKSwiftBXTriggerTapViewModel()
        model.viewType = .tamperDetect
        return model
    }()
}

extension MKSwiftBXSlotConfigTriggerCell: @preconcurrency MKSwiftBXTriggerHumidityViewDelegate, @preconcurrency MKSwiftBXTriggerTemperatureViewDelegate, @preconcurrency MKSwiftBXTriggerTapViewDelegate {
    public func MKSwiftBXTriggerTapViewIndexChanged(_ index: Int, viewType: MKSwiftBXTriggerTapViewType) {
        if viewType == .double {
            //双击
            doubleTapViewModel.index = index
            return
        }
        if viewType == .triple {
            //三击
            tripleTapViewModel.index = index
            return
        }
        if viewType == .deviceMoves {
            //移动触发
            movesViewModel.index = index
            return
        }
        if viewType == .ambientLightDetected {
            //光感
            lightDetectedViewModel.index = index
            return
        }
        if viewType == .single {
            //单击
            singleTapViewModel.index = index
            return
        }
        if viewType == .tamperDetect {
            //防拆
            tamperDetectViewModel.index = index
            return
        }
    }
    
    //index = 1的时候，输入框的值
    public func MKSwiftBXTriggerTapViewStartValueChanged(_ startValue: String, viewType: MKSwiftBXTriggerTapViewType) {
        if viewType == .double {
            //双击
            doubleTapViewModel.startValue = startValue
            return
        }
        if viewType == .triple {
            //三击
            tripleTapViewModel.startValue = startValue
            return
        }
        if viewType == .deviceMoves {
            //移动触发
            movesViewModel.startValue = startValue
            return
        }
        if viewType == .ambientLightDetected {
            //光感
            lightDetectedViewModel.startValue = startValue
            return
        }
        if viewType == .single {
            //单击
            singleTapViewModel.startValue = startValue
            return
        }
        if viewType == .tamperDetect {
            //防拆
            tamperDetectViewModel.startValue = startValue
            return
        }
    }
    
    //index = 2的时候，输入框的值
    public func MKSwiftBXTriggerTapViewStopValueChanged(_ stopValue: String, viewType: MKSwiftBXTriggerTapViewType) {
        if viewType == .double {
            //双击
            doubleTapViewModel.stopValue = stopValue
            return
        }
        if viewType == .triple {
            //三击
            tripleTapViewModel.stopValue = stopValue
            return
        }
        if viewType == .deviceMoves {
            //移动触发
            movesViewModel.stopValue = stopValue
            return
        }
        if viewType == .ambientLightDetected {
            //光感
            lightDetectedViewModel.stopValue = stopValue
            return
        }
        if viewType == .single {
            //单击
            singleTapViewModel.stopValue = stopValue
            return
        }
        if viewType == .tamperDetect {
            //防拆
            tamperDetectViewModel.stopValue = stopValue
            return
        }
    }
    
    //MARK: - MKSwiftBXTriggerTemperatureViewDelegate
    public func triggerTemperatureStartStatusChanged(_ start: Bool) {
        temperViewModel.start = start
    }
    
    public func triggerTemperatureThresholdValueChanged(_ sliderValue: Float) {
        temperViewModel.sliderValue = sliderValue
    }
    //MARK: - MKSwiftBXTriggerHumidityViewDelegate
    public func triggerHumidityStartStatusChanged(_ start: Bool) {
        humidityViewModel.start = start
    }
    
    public func triggerHumidityThresholdValueChanged(_ sliderValue: Float) {
        humidityViewModel.sliderValue = sliderValue
    }
}

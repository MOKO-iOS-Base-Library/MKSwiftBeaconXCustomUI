//
//  MKSwiftBXQuickSwitchCell.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/24.
//

import UIKit

import SnapKit

import MKBaseSwiftModule
import MKSwiftCustomUI

// MARK: - Layout
public class MKBXQuickSwitchCellLayout: UICollectionViewFlowLayout {
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        if attributes.isEmpty || attributes.count == 1 {
            return attributes
        }
        
        // 复制属性以避免修改原始值
        let mutableAttributes = attributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        // 调整间距
        for i in 1..<mutableAttributes.count {
            let current = mutableAttributes[i]
            let previous = mutableAttributes[i-1]
            
            let maximumSpacing: CGFloat = 11.0
            let origin = previous.frame.maxX
            
            if origin + maximumSpacing + current.frame.size.width < collectionViewContentSize.width {
                current.frame.origin.x = origin + maximumSpacing
            } else {
                // 换行处理
                current.frame.origin.x = sectionInset.left
            }
        }
        
        return mutableAttributes
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // 当视图大小变化时重新布局
        return true
    }
}

// MARK: - Model
public class MKBXQuickSwitchCellModel {
    public var titleMsg: String = ""
    public var index: Int = 0
    public var isOn: Bool = false
    
    public init() {}
}

// MARK: - Delegate
public protocol MKBXQuickSwitchCellDelegate: AnyObject {
    func mk_swift_bx_quickSwitchStatusChanged(_ isOn: Bool, index: Int)
}

// MARK: - Cell
public class MKBXQuickSwitchCell: UICollectionViewCell {
    
    public weak var delegate: MKBXQuickSwitchCellDelegate?
    public var dataModel: MKBXQuickSwitchCellModel? {
        didSet {
            guard let model = dataModel else { return }
            msgLabel.text = model.titleMsg
            switchButton.isSelected = model.isOn
            updateSwitchButtonIcon()
        }
    }
    
    private let switchButtonWidth: CGFloat = 40.0
    private let switchButtonHeight: CGFloat = 30.0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backView)
        backView.addSubview(msgLabel)
        backView.addSubview(switchButton)
        backView.addSubview(switchStatusLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let msgSize = NSString(string: msgLabel.text ?? "").boundingRect(
            with: CGSize(width: contentView.frame.width - 2 * 5.0, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: msgLabel.font!],
            context: nil
        ).size
        
        msgLabel.snp.remakeConstraints { make in
            make.left.equalTo(5.0)
            make.right.equalTo(-5.0)
            make.top.equalTo(10.0)
            make.height.equalTo(msgSize.height)
        }
        
        switchButton.snp.remakeConstraints { make in
            make.left.equalTo(15.0)
            make.width.equalTo(switchButtonWidth)
            make.top.equalTo(msgLabel.snp.bottom).offset(10.0)
            make.height.equalTo(switchButtonHeight)
        }
        
        switchStatusLabel.snp.remakeConstraints { make in
            make.right.equalTo(-15.0)
            make.width.equalTo(60.0)
            make.centerY.equalTo(switchButton.snp.centerY)
            make.height.equalTo(UIFont.systemFont(ofSize: 13.0).lineHeight)
        }
    }
    
    // MARK: - Event Methods
    @objc private func switchButtonPressed() {
        switchButton.isSelected = !switchButton.isSelected
        updateSwitchButtonIcon()
        
        if let model = dataModel {
            delegate?.mk_swift_bx_quickSwitchStatusChanged(switchButton.isSelected, index: model.index)
        }
    }
    
    // MARK: - Private Methods
    private func updateSwitchButtonIcon() {
        let image = switchButton.isSelected ? moduleIcon(name: "mk_swift_bx_switchSelectedIcon", in: .module) : moduleIcon(name: "mk_swift_bx_switchUnselectedIcon", in: .module)
        switchButton.setImage(image, for: .normal)
        
        let statusColor = switchButton.isSelected ? UIColor.blue : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        switchStatusLabel.textColor = statusColor
        switchStatusLabel.text = switchButton.isSelected ? "Enabled" : "Disabled"
    }
    
    //MARK: - Lazy
    private lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .white
        backView.layer.masksToBounds = false
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.borderWidth = 0.5
        backView.layer.cornerRadius = 6.0
        backView.layer.shadowColor = UIColor.darkText.cgColor
        backView.layer.shadowOffset = CGSize(width: 1.5, height: 3)
        backView.layer.shadowOpacity = 0.8
        return backView
    }()
    
    private lazy var msgLabel: UILabel = {
        let msgLabel = UILabel()
        msgLabel.textAlignment = .center
        msgLabel.textColor = .darkText
        msgLabel.font = UIFont.systemFont(ofSize: 13.0)
        msgLabel.numberOfLines = 0
        return msgLabel
    }()
    
    private lazy var switchButton: UIButton = {
        let switchButton = UIButton(type: .custom)
        switchButton.addTarget(self,
                               action: #selector(switchButtonPressed),
                               for: .touchUpInside)
        return switchButton
    }()
    
    private lazy var switchStatusLabel: UILabel = {
        let switchStatusLabel = UILabel()
        switchStatusLabel.textAlignment = .left
        switchStatusLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        switchStatusLabel.font = UIFont.systemFont(ofSize: 13.0)
        return switchStatusLabel
    }()
}

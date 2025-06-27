//
//  MKSwiftBXSlotConfigCellProtocol.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/25.
//

// MARK: - Slot Config Cell Protocol

/// Keys used in the JSON returned by `slotConfigCellParams()`
public enum MKSwiftBXSlotConfigKey {
    public static let advContentType = "00"
    public static let advParamType = "01"
    public static let advTriggerType = "02"
    
    public static let beaconData = "beaconKey"
    public static let infoData = "infoKey"
    public static let uidData = "uidKey"
    public static let urlData = "urlKey"
}

/// Protocol for slot configuration cells
public protocol MKSwiftBXSlotConfigCellProtocol: AnyObject {
    /// Returns the configuration parameters as a dictionary
    func slotConfigCellParams() -> [String: Any]
}

//
//  MKSwiftBXSlotDataAdopter.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/24.
//

import Foundation

public class MKSwiftBXSlotDataAdopter {
    
    /// 解析设备传回来的设备类型
    /// @"00":UID,@"10":URL,@"20":TLM,@"40":设备信息,@"50":iBeacon,@"60":3轴加速度计,@"70":温湿度传感器,@"FF":NO DATA
    public static func fetchSlotFrameType(_ type: String) -> MKSwiftBXSlotFrameType {
        guard !type.isEmpty, type.lowercased() != "ff" else {
            return .null
        }
        
        switch type {
        case "00": return .uid
        case "10": return .url
        case "20": return .tlm
        case "40": return .info
        case "50": return .beacon
        case "60": return .threeASensor
        case "70": return .thSensor
        default: return .null
        }
    }
    
    /// 根据后缀名返回写入数据时候的hex
    public static func getExpansionHex(_ expansion: String) -> String {
        guard !expansion.isEmpty else {
            return ""
        }
        
        switch expansion {
        case ".com/": return "00"
        case ".org/": return "01"
        case ".edu/": return "02"
        case ".net/": return "03"
        case ".info/": return "04"
        case ".biz/": return "05"
        case ".gov/": return "06"
        case ".com": return "07"
        case ".org": return "08"
        case ".edu": return "09"
        case ".net": return "0a"
        case ".info": return "0b"
        case ".biz": return "0c"
        case ".gov": return "0d"
        default: return ""
        }
    }
    
    /// 根据设备传过来的值解析成对应的域名前缀
    /// 0x00 : @"http://www.",   0x01 : @"https://www.",    0x02 : @""http://",    0x03 : @"https://"
    public static func getUrlscheme(_ hexChar: CChar) -> String {
        switch hexChar {
        case 0x00: return "http://www."
        case 0x01: return "https://www."
        case 0x02: return "http://"
        case 0x03: return "https://"
        default: return ""
        }
    }
    
    /// 根据设备传过来的值解析成对应的域名结尾
    public static func getEncodedString(_ hexChar: CChar) -> String {
        switch hexChar {
        case 0x00: return ".com/"
        case 0x01: return ".org/"
        case 0x02: return ".edu/"
        case 0x03: return ".net/"
        case 0x04: return ".info/"
        case 0x05: return ".biz/"
        case 0x06: return ".gov/"
        case 0x07: return ".com"
        case 0x08: return ".org"
        case 0x09: return ".edu"
        case 0x0a: return ".net"
        case 0x0b: return ".info"
        case 0x0c: return ".biz"
        case 0x0d: return ".gov"
        default: return String(format: "%c", hexChar)
        }
    }
}

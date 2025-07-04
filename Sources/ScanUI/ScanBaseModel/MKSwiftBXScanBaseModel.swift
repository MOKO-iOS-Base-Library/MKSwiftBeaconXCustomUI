//
//  MKSwiftBXScanBaseModel.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/7/4.
//

import Foundation

public class MKSwiftBXScanBaseModel {
    //如果是TLM、温湿度、三轴传感器中的一种，并且设备信息广播帧数组里面已经包含了该种广播帧，根据原始广播数据来判断二者是否一致，如果一致则舍弃，不一致则用新的广播帧替换广播帧数组里的该广播帧
    public var advertiseData: Data?
    //用来标示数据model在设备列表或者设备信息广播帧数组里的index
    public var index: Int = 0
    /*
     用来对同一个设备的广播帧进行排序，顺序为
     MKBXSUIDFrameType,
     MKBXSURLFrameType,
     MKBXSTLMFrameType,
     MKBXSBeaconFrameType,
     注意，MKBXSTagInfoFrameType为每个section的第一个row数据，不在此进行排列了
     */
    public var frameIndex: Int = 0
    
    public init() {}
}

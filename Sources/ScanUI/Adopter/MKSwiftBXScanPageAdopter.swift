//
//  MKSwiftBXScanPageAdopter.swift
//  MKSwiftBeaconXCustomUI
//
//  Created by aa on 2025/6/24.
//

import UIKit

public struct MKSwiftBXScanPageAdopter {
    
    /// Supported cell types
    public enum CellType {
        case beacon(MKSwiftBXScanBeaconCellModel)
        case ht(MKSwiftBXScanHTCellModel)
        case threeASensor(MKSwiftBXScanThreeASensorCellModel)
        case tlm(MKSwiftBXScanTLMCellModel)
        case uid(MKSwiftBXScanUIDCellModel)
        case url(MKSwiftBXScanURLCellModel)
        case unknown
    }
    
    /// Load appropriate cell based on data model type
    @MainActor public static func loadCell(with tableView: UITableView, dataModel: Any) -> UITableViewCell {
        switch cellType(for: dataModel) {
        case .uid(let model):
            let cell = MKSwiftBXScanUIDCell.initCell(with: tableView)
            cell.dataModel = model
            return cell
            
        case .url(let model):
            let cell = MKSwiftBXScanURLCell.initCell(with: tableView)
            cell.dataModel = model
            return cell
            
        case .tlm(let model):
            let cell = MKSwiftBXScanTLMCell.initCell(with: tableView)
            cell.dataModel = model
            return cell
            
        case .beacon(let model):
            let cell = MKSwiftBXScanBeaconCell.initCell(with: tableView)
            cell.dataModel = model
            return cell
            
        case .ht(let model):
            let cell = MKSwiftBXScanHTCell.initCell(with: tableView)
            cell.dataModel = model
            return cell
            
        case .threeASensor(let model):
            let cell = MKSwiftBXScanThreeASensorCell.initCell(with: tableView)
            cell.dataModel = model
            return cell
            
        case .unknown:
            return UITableViewCell(style: .default, reuseIdentifier: "MKSwiftBXScanPageAdopterIdenty")
        }
    }
    
    /// Get cell height based on data model type
    @MainActor public static func loadCellHeight(with dataModel: Any) -> CGFloat {
        switch cellType(for: dataModel) {
        case .uid: return 85
        case .url: return 70
        case .tlm: return 110
        case .beacon(let model): return MKSwiftBXScanBeaconCell.getCellHeight(with: model.uuid)
        case .ht: return 105
        case .threeASensor: return 140
        case .unknown: return 0
        }
    }
    
    /// Get frame index based on data model type
    public static func fetchFrameIndex(_ dataModel: Any) -> Int {
        switch cellType(for: dataModel) {
        case .uid: return 0
        case .url: return 1
        case .tlm: return 2
        case .beacon: return 3
        case .threeASensor: return 4
        case .ht: return 5
        case .unknown: return 6
        }
    }
    
    // MARK: - Private Helpers
    
    private static func cellType(for dataModel: Any) -> CellType {
        switch dataModel {
        case let model as MKSwiftBXScanUIDCellModel: return .uid(model)
        case let model as MKSwiftBXScanURLCellModel: return .url(model)
        case let model as MKSwiftBXScanTLMCellModel: return .tlm(model)
        case let model as MKSwiftBXScanBeaconCellModel: return .beacon(model)
        case let model as MKSwiftBXScanHTCellModel: return .ht(model)
        case let model as MKSwiftBXScanThreeASensorCellModel: return .threeASensor(model)
        default: return .unknown
        }
    }
}

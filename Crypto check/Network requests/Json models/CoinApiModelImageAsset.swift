//
//  CoinApiModelImageAsset.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import Foundation
import ObjectMapper
import RealmSwift

class CoinApiModelImageAsset: Object, Mappable {
    
    @objc dynamic var assetId: String = "it doesn't get data"
    @objc dynamic var url: String = "it doesn't get data"
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
            return "assetId"
    }
    
    func mapping(map: ObjectMapper.Map) {
        assetId <- map["asset_id"]
        url <- map["url"]
    }
}

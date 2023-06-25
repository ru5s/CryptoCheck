//
//  CoinApiModelPeriodOfCoin.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import Foundation
import ObjectMapper
import RealmSwift

class AllDataByPeriod: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var coinName: String = "name to coin"
    
    var allCoinsDataByPeriod = List<CoinDataByPeriod>()
    
    override static func primaryKey() -> String? {
            return "id"
    }
    
    
}


class CoinDataByPeriod: Object, Mappable {
    
    @objc dynamic var periodStart: String = "it doesn't get data"
    @objc dynamic var periodEnd: String = "it doesn't get data"
    @objc dynamic var timeOpen: String = "it doesn't get data"
    @objc dynamic var timeClose: String = "it doesn't get data"
    @objc dynamic var priceOpen: Double = 0.0
    @objc dynamic var priceClose: Double = 0.0
    @objc dynamic var priceHigh: Double = 0.0
    @objc dynamic var priceLow: Double = 0.0
    @objc dynamic var tradesCount: Int = 0
    @objc dynamic var volumeTrades: Double = 0.0
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
            return "periodStart"
    }
    
    func mapping(map: ObjectMapper.Map) {
        periodStart <- map["time_period_start"]
        periodEnd <- map["time_period_end"]
        timeOpen <- map["time_open"]
        timeClose <- map["time_close"]
        priceOpen <- map["price_open"]
        priceClose <- map["price_close"]
        priceHigh <- map["price_high"]
        priceLow <- map["price_low"]
        tradesCount <- map["trades_count"]
        volumeTrades <- map["volume_traded"]
    }
    
    
}


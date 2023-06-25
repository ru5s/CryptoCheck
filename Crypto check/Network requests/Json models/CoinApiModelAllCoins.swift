//
//  CoinApiModelAllCoins.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import Foundation
import ObjectMapper
import RealmSwift


class DateToAllCoins: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date: String = ""
    var allCoinsData = List<AllCoins>()
    
    override static func primaryKey() -> String? {
            return "id"
    }
    
}


class AllCoins: Object, Mappable{
    
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var price_usd: Double = 0.0
    @objc dynamic var type_is_crypto: Int = 0
    @objc dynamic var data_quote_start: String = ""
    @objc dynamic var data_quote_end: String = ""
    @objc dynamic var data_orderbook_start: String = ""
    @objc dynamic var data_orderbook_end: String = ""
    @objc dynamic var data_trade_start: String = ""
    @objc dynamic var data_trade_end: String = ""
    @objc dynamic var data_symbols_count: Int = 0
    @objc dynamic var volume_1hrs_usd: Double = 0.0
    @objc dynamic var volume_1day_usd: Double = 0.0
    @objc dynamic var volume_1mth_usd: Double = 0.0
    @objc dynamic var id_icon: String = ""
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
            return "id"
    }
    
    
    func mapping(map: ObjectMapper.Map) {
        id <- map ["asset_id"]
        name <- map ["name"]
        volume_1mth_usd <- map ["volume_1mth_usd"]
        price_usd <- map ["price_usd"]
        type_is_crypto <- map ["type_is_crypto"]
        data_quote_start <- map ["data_quote_start"]
        data_quote_end <- map ["data_quote_end"]
        data_orderbook_start <- map ["data_orderbook_start"]
        data_orderbook_end <- map ["data_orderbook_end"]
        data_trade_start <- map ["data_trade_start"]
        data_trade_end <- map ["data_trade_end"]
        data_symbols_count <- map ["data_symbols_count"]
        volume_1hrs_usd <- map ["volume_1hrs_usd"]
        volume_1day_usd <- map ["volume_1day_usd"]
        id_icon <- map ["id_icon"]
    }
    
    
}

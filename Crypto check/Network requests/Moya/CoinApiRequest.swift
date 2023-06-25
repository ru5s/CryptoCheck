//
//  CoinApiRequest.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import Foundation
import Moya

private let coinApiKey = "FF47C6A8-4D78-4272-A007-2B0C84A06DD2"
private let coinApiKey2 = "4E1F7602-6F61-418D-9CA4-3368396543EA"


enum CoinApiRequest: TargetType {
    case getData(coins: String)
    case coinData(period: String, timeStart: String, timeEnd: String, limit: Int, coinName: String)
    case coinsIcon
    
    var baseURL: URL {
        guard let url = URL(string: "https://rest.coinapi.io") else {fatalError()}
        return url
    }
    
    var path: String{
        switch self {
        case .getData:
            return "/v1/assets"
        case .coinData(let coin):
            return "/v1/ohlcv/BITSTAMP_SPOT_\(coin.coinName)_USD/history"
        case .coinsIcon:
            return "/v1/assets/icons/32"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self{
        case let .getData(coins):
            return .requestParameters(parameters: ["filter_asset_id" : coins], encoding: URLEncoding.queryString)
        case let .coinData(period, timeStart, timeEnd, limit, _):
            return .requestParameters(parameters: ["period_id" : period, "time_start" : timeStart, "time_end" : timeEnd, "limit" : limit], encoding: URLEncoding.queryString)
        case .coinsIcon:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["X-CoinAPI-Key": coinApiKey]
    }
    
}



//
//  GetAllCoinFromRealmService.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import Foundation
import UIKit
import RealmSwift


class RealmDataModel {
    
    var allCoinsRealm: Results<AllCoins>? {
        let predicate = NSPredicate(format: "type_is_crypto == 1")
        let items = realm.objects(AllCoins.self).filter(predicate)
        
        return items.sorted(byKeyPath: "volume_1mth_usd", ascending: false)
    }
    
    var allCoinsByDate: Results<DateToAllCoins>? {
        return realm.objects(DateToAllCoins.self)
    }
    
    var iconsUrl: Results<CoinApiModelImageAsset>? {
        return realm.objects(CoinApiModelImageAsset.self)
    }
    
    let realm = try! Realm()
    
    //---------------------
    
    private func didFinishLounchingWithOptions(){
        
        let config = Realm.Configuration(
            schemaVersion: realmSchema,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
            })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
    }
    
    func saveToBaseFromApi(coins: [AllCoins]?, completition: @escaping (Bool?) -> ()) {
        var array: [AllCoins] = []
        
        guard let coins = coins else {
            return completition(false)
        }
        
        try! self.realm.write({
            
            let realmDataDB = DateToAllCoins()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
            realmDataDB.date = dateFormatter.string(from: Date())
            
            for coin in coins {
                let realmDB = AllCoins()
                realmDB.id = coin.id
                realmDB.name = coin.name
                realmDB.volume_1mth_usd = coin.volume_1mth_usd
                realmDB.price_usd = coin.price_usd
                realmDB.type_is_crypto = coin.type_is_crypto
                realmDB.data_quote_start = coin.data_quote_start
                realmDB.data_quote_end = coin.data_quote_end
                realmDB.data_orderbook_start = coin.data_orderbook_start
                realmDB.data_orderbook_end = coin.data_orderbook_end
                realmDB.data_trade_start = coin.data_trade_start
                realmDB.data_trade_end = coin.data_trade_end
                realmDB.data_symbols_count = coin.data_symbols_count
                realmDB.volume_1hrs_usd = coin.volume_1hrs_usd
                realmDB.volume_1day_usd = coin.volume_1day_usd
                realmDB.id_icon = coin.id_icon
                array.append(realmDB)
            }
            
            realmDataDB.allCoinsData.append(objectsIn: array)
            self.realm.add(realmDataDB, update: .all)
            completition(true)
        })
        
    }
    
    func saveIconLinkToDB(links: [CoinApiModelImageAsset]?, completition: @escaping (Bool) -> ()) {
        
        guard let links = links else {
            return completition(false)
        }
        
        try! self.realm.write ({
            
            for link in links {
                let linksDB = CoinApiModelImageAsset()
                
                linksDB.assetId = link.assetId
                linksDB.url = link.url
                
                realm.add(linksDB, update: .all)
            }
            
            completition(true)
        })
    }
    
    func getNameIcon(_ nameCoin: String, completition: @escaping (URL?) -> ()) {
        
        let predicate = NSPredicate(format: "assetId CONTAINS [c]%@", nameCoin)
        
        let result = iconsUrl?.filter(predicate).first
        
        guard result != nil else {return completition(nil)}
        
        guard let result = result else {return completition(nil)}
        
        let url = URL(string: result.url)
        
        guard let url = url else {return completition(nil)}
        
        completition(url)
    }
    
}


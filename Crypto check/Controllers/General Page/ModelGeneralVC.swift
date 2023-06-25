//
//  ModelGeneralVC.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import Foundation
import UIKit
import RealmSwift

class ModelGeneralVC {
    let realm = try? Realm()
    
    let networkService = AllCoinService()
    let dataBaseService = RealmDataModel()
    
    var allCoinsRealm: Results<AllCoins>? {
        return dataBaseService.allCoinsRealm
    }
    
    var allCoinsRealmExceptFirstThreeCoin: Results<AllCoins>? {
        let result = dataBaseService.allCoinsRealm
        return result
    }
    
    var allCoinsByDate: Results<DateToAllCoins>? {
        return dataBaseService.allCoinsByDate
    }
    
    var iconsUrl: Results<CoinApiModelImageAsset>? {
        return dataBaseService.iconsUrl
    }
    
    func getDataFromApi(specialCoin: String, completition: @escaping (Bool?) -> ()) {
        
        networkService.getAllCoinData(coins: specialCoin) { bool, coins in
            if bool == true {
                self.dataBaseService.saveToBaseFromApi(coins: coins) { bool in
                    if bool == true {
                        completition(true)
                    } else {
                        completition(false)
                    }
                }
            } else {
                completition(false)
            }
        }
        
    }
    
    func getIconsFromApi(completition: @escaping () -> ()) {
        networkService.getImageFromApi { icons in
            if icons != nil {
                self.dataBaseService.saveIconLinkToDB(links: icons) { bool in
                    if bool == true {
                        completition()
                    } else {
                        print("++ error with saved links data to data base")
                    }
                }
            }
        }
    }
    
    func setIconToCollection(_ coin: String, completition: @escaping (UIImage?) -> ()) {
        
        dataBaseService.getNameIcon(coin) { url in
            
            guard let url = url else {return completition(nil)}
            
            self.networkService.getSetIcons(url) { icon in
                completition(icon)
            }
            
        }
        
    }
    
    func formatNumber(number: Double) -> String {
        let billion = 1_000_000_000.0
        let trillion = 1_000_000_000_000.0
        let quadrillion = 1_000_000_000_000_000.0
        let quintillion = 1_000_000_000_000_000_000.0
        let sextillion = 1_000_000_000_000_000_000_000.0
        
        
        if number >= sextillion {
            let formattedNumber = number / sextillion
            return String(format: "%.1fSx", formattedNumber)
        }else if number >= quintillion {
            let foramattedNumber = number / quintillion
            return String(format: "%.1fQi", foramattedNumber)
        }else if number >= quadrillion {
            let formattedNumber = number / quadrillion
            return String(format: "%.1fQ", formattedNumber)
        } else if number >= trillion {
            let formattedNumber = number / trillion
            return String(format: "%.1fT", formattedNumber)
        } else if number >= billion {
            let formattedNumber = number / billion
            return String(format: "%.1fB", formattedNumber)
        } else {
            return String(format: "%.0f", number)
        }
    }
    
    func formatDecimalNumber(number: Double) -> String {
       
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.positivePrefix = "$ "
        
        return String(formatter.string(from: number as NSNumber) ?? "0")
    }
    
}


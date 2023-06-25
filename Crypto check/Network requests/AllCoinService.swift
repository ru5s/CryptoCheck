//
//  AllCoinService.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import UIKit
import Moya
import RealmSwift
import Alamofire
import ObjectMapper

class AllCoinService {
    
    let iconsCache = NSCache <NSString, UIImage>()
    
    let coinApiRequest = MoyaProvider<CoinApiRequest>()
    lazy var realm:Realm = {
        let config = Realm.Configuration(
            schemaVersion: realmSchema,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
            })
        
        Realm.Configuration.defaultConfiguration = config
        
        return try! Realm()
    }()
    
    func getAllCoinData(coins: String, complete: @escaping (Bool, [AllCoins]?) -> ()){
        
        coinApiRequest.request(.getData(coins: coins)){result in
            switch result{
            case .success(let response):
                
                let data = response.data
                let jsonString = String(data: data, encoding: .utf8)
                guard let coins: [AllCoins] = Mapper<AllCoins>().mapArray(JSONString: jsonString!) else {
                    complete(false, nil)
                    return print("can't response data")
                }
                
                complete(true, coins)

            case .failure(let error):
                print("error \(error)")
                complete(false, nil)
            }
        }
    }
    
    func getImageFromApi(completition: @escaping ([CoinApiModelImageAsset]?) -> ()) {
        coinApiRequest.request(.coinsIcon) { result in
            switch result {
            case .success(let response):
                
                let data = response.data
                let jsonString = String(data: data, encoding: .utf8)
                
                guard let jsonString = jsonString else {
                    completition(nil)
                    return print("error from icons request")
                }
                
                guard let icons: [CoinApiModelImageAsset] = Mapper<CoinApiModelImageAsset>().mapArray(JSONString: jsonString) else {
                    completition(nil)
                    return print("error from icons request")
                }
                
                completition(icons)
                
            case .failure(let error):
                print("request error \(error.localizedDescription)")
                completition(nil)
            }
        }
    }
    
    func getSetIcons(_ iconUrl: URL, completition: @escaping (UIImage) -> ()) {
        
        if let cachedIcon = iconsCache.object(forKey: iconUrl.absoluteString as NSString) {
            completition(cachedIcon)
        } else {
            
            let request = URLRequest(url: iconUrl, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            
            let downloadTask = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil,
                      let unwrData = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    return
                }
                
                guard let icon = UIImage(data: unwrData) else {
                    return
                }
                
                self.iconsCache.setObject(icon, forKey: iconUrl.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completition(icon)
                }
            }
            
            downloadTask.resume()
        }
        
    }
    
}


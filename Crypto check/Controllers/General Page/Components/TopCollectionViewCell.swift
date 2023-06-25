//
//  TopCollectionViewCell.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    
    let coinName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    let coinFullName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "coin name"
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(displayP3Red: 117 / 255, green: 119 / 255, blue: 128 / 255, alpha: 1.0)
        label.textAlignment = .left
        
        return label
    }()
    
    let coinImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.tintColor = .darkGray
        image.image = UIImage(named: "empty coin")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = UIColor(displayP3Red: 20 / 255, green: 18 / 255, blue: 30 / 255, alpha: 1.0)
        
        
        return image
    }()
    
    let usd: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$... "
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    var emtyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        
        return label
    }()
    
    let model = ModelGeneralVC()
    
    var date: AllCoins? {
        didSet {
            guard let unwrData = date else {return}
            
            coinName.text = unwrData.id
            coinFullName.text = unwrData.name
            
            usd.text = "$\(model.formatNumber(number: unwrData.volume_1mth_usd))"
            
            model.setIconToCollection(unwrData.id) { icon in
                if icon != nil {
                    self.coinImage.image = icon
                } else {
//                    self.coinImage.image = UIImage(named: "temp")?.withTintColor(.systemGray)
                    self.emtyLabel.text = "\(self.date?.id.prefix(1) ?? "")"
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coinImage)
        coinImage.addSubview(emtyLabel)
        contentView.addSubview(coinName)
        contentView.addSubview(coinFullName)
        contentView.addSubview(usd)
        
        NSLayoutConstraint.activate([
            
            
            coinImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            coinImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            coinImage.heightAnchor.constraint(equalToConstant: 50),
            coinImage.widthAnchor.constraint(equalToConstant: 50),
            emtyLabel.centerXAnchor.constraint(equalTo: coinImage.centerXAnchor),
            emtyLabel.centerYAnchor.constraint(equalTo: coinImage.centerYAnchor),
            coinName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  15),
            coinName.topAnchor.constraint(equalTo: coinImage.bottomAnchor, constant: 15),
            coinFullName.topAnchor.constraint(equalTo: coinName.bottomAnchor, constant: 5),
            coinFullName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            coinFullName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            usd.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            usd.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  10),
            usd.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
        ])
        
        coinImage.layer.cornerRadius = coinImage.bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


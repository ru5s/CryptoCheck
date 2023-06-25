//
//  FabButton.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import Foundation
import UIKit

class FabButton: UIView {
    
    let roundView: UIView
    let color: UIColor = UIColor.systemIndigo
    let image: UIImageView = UIImageView(image: UIImage(systemName: "plus"))
    
    init() {
        roundView = UIView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        roundView.translatesAutoresizingMaskIntoConstraints = false
        roundView.layer.cornerRadius = roundView.bounds.height / 2
        roundView.backgroundColor = color.withAlphaComponent(0.85)
        
        image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .white
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(roundView)
        roundView.addSubview(image)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.heightAnchor.constraint(equalToConstant: 75).isActive = true
        self.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        roundView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        roundView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        roundView.frame = bounds
        image.centerYAnchor.constraint(equalTo: roundView.centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: roundView.centerXAnchor).isActive = true
    }
}

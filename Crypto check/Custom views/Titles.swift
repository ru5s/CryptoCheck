//
//  Titles.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import Foundation
import UIKit

class Titles: UIView {
    
    var label: UILabel
    let defaultFrame = CGRect(x: 0, y: 0, width: 200, height: 50)
    var textColor: UIColor = .white
    var aligment: NSTextAlignment = .left
    var fontSize: CGFloat = 20
    
    init(text: String) {
        
        label = UILabel(frame: defaultFrame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        label.text = text
        label.textColor = textColor
        label.textAlignment = aligment
        
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.frame = bounds
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
    }
    
}

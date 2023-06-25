//
//  ViewController.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import UIKit
import RealmSwift

class GeneralVC: UIViewController {
    
    var myScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        
        return sv
    }()
    
    var topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let countOfCell = 3
        let space = 18
        layout.minimumLineSpacing = CGFloat(space)
        let sizeToCell = ((Int(UIScreen.main.bounds.width - 40) - ((countOfCell - 1) * space)) / countOfCell)
        layout.itemSize = CGSize(width: sizeToCell, height: 200)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        cv.showsVerticalScrollIndicator = false
        cv.autoresizingMask = .flexibleHeight
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        return cv
    }()
    
    var belowCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let countOfCell = 1
        let space = 15
        layout.minimumLineSpacing = CGFloat(space)
        let sizeToCell = ((Int(UIScreen.main.bounds.width - 40) - ((countOfCell - 1) * space)) / countOfCell)
        layout.itemSize = CGSize(width: sizeToCell, height: 80)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BelowCollectionViewCell.self, forCellWithReuseIdentifier: "BelowCollectionCell")
        cv.showsVerticalScrollIndicator = false
        cv.autoresizingMask = .flexibleHeight
        
        return cv
    }()
    
    let navigationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Market"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    let subNavigationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "by vol"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .left
        
        return label
    }()
    
    let timeIntervalButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.setTitle(" Month     ", for: .normal)
        
        btn.tintColor = UIColor(displayP3Red: 123 / 255, green: 90 / 255, blue: 255 / 255, alpha: 1.0)
        
        btn.layer.cornerRadius = 20
        
        btn.backgroundColor = UIColor(displayP3Red: 20 / 255, green: 18 / 255, blue: 30 / 255, alpha: 1.0)
        btn.setTitleColor(UIColor(displayP3Red: 123 / 255, green: 90 / 255, blue: 255 / 255, alpha: 1.0), for: .normal)
        
        return btn
    }()
    
    let iconImage: UIImageView = UIImageView.init(image: UIImage(systemName: "chevron.down"))
    
    let backgroundToNavigation: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.backgroundColor = .red.withAlphaComponent(0.8)
        
        return view
    }()
    
    var topThreeLabel: Titles?
    var showcaseLabel: Titles?
    var fabButton: FabButton?
    
    let modelGeneralVC = ModelGeneralVC()
    
    var amountOfBalowCollectionItems = 20
    
    var canChangeNavigation = false
    
    var navigationLabelTopConstraint: NSLayoutConstraint?
    var backgroundToNavigationBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllCoinData()
        
        //        setGradientBackground()
        view.backgroundColor = .black
        
        navigationController?.isNavigationBarHidden = true
        
        topThreeLabel = Titles(text: "Top 🏆")
        showcaseLabel = Titles(text: "List of coins")
        
        fabButton = FabButton()
        fabButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        view.addSubview(myScrollView)
        myScrollView.delegate = self
        
        
        //        view.addSubview(fabButton!)
        
        view.addSubview(backgroundToNavigation)
        view.addSubview(navigationLabel)
        view.addSubview(subNavigationLabel)
        view.addSubview(timeIntervalButton)
        
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        timeIntervalButton.addSubview(iconImage)
        
        myScrollView.addSubview(topThreeLabel!)
        myScrollView.addSubview(showcaseLabel!)
        
        myScrollView.addSubview(topCollectionView)
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.backgroundColor = .clear
        
        
        myScrollView.addSubview(belowCollectionView)
        belowCollectionView.delegate = self
        belowCollectionView.dataSource = self
        belowCollectionView.backgroundColor = .clear
        belowCollectionView.isScrollEnabled = false
        
        let safeArea = view.layoutMarginsGuide
        
        navigationLabelTopConstraint = navigationLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20)
        navigationLabelTopConstraint?.isActive = true
        
        backgroundToNavigationBottomConstraint = backgroundToNavigation.bottomAnchor.constraint(equalTo: navigationLabel.bottomAnchor, constant: 10)
        backgroundToNavigationBottomConstraint?.isActive = true
        
        
    }
    
    func getAllCoinData(){
        
        print("++ >>> REALM PATH FILE: \(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")")
        
        modelGeneralVC.getIconsFromApi {
            self.topCollectionView.reloadData()
            self.belowCollectionView.reloadData()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let curentDate = dateFormatter.string(from: Date())
        
        let check = modelGeneralVC.allCoinsByDate?.where({$0.date == curentDate}).first
        
        if check?.date == nil {
            
            modelGeneralVC.getDataFromApi(specialCoin: "") { bool in
                if bool == true {
                    //                    print("++ \(String(describing: self.modelGeneralVC.allCoinsRealm?.count))")
                    self.topCollectionView.reloadData()
                    self.belowCollectionView.reloadData()
                } else {
                    print("somthig wrong with data base or network")
                }
            }
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        let safeArea = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            backgroundToNavigation.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundToNavigation.widthAnchor.constraint(equalToConstant: view.bounds.width),
            navigationLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            subNavigationLabel.leadingAnchor.constraint(equalTo: navigationLabel.trailingAnchor, constant: 5),
            subNavigationLabel.topAnchor.constraint(equalTo: navigationLabel.topAnchor, constant: 3),
            timeIntervalButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            timeIntervalButton.bottomAnchor.constraint(equalTo: navigationLabel.bottomAnchor, constant: 0),
            timeIntervalButton.topAnchor.constraint(equalTo: navigationLabel.topAnchor, constant: 0),
            timeIntervalButton.widthAnchor.constraint(equalToConstant: 110),
            iconImage.trailingAnchor.constraint(equalTo: timeIntervalButton.trailingAnchor, constant: -15),
            iconImage.centerYAnchor.constraint(equalTo: timeIntervalButton.centerYAnchor),
            myScrollView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
            myScrollView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            myScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            myScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topThreeLabel!.topAnchor.constraint(equalTo: myScrollView.topAnchor, constant: 70),
            topThreeLabel!.leadingAnchor.constraint(equalTo: myScrollView.leadingAnchor),
            topCollectionView.topAnchor.constraint(equalTo: topThreeLabel!.bottomAnchor, constant: 10),
            topCollectionView.trailingAnchor.constraint(equalTo: myScrollView.trailingAnchor),
            topCollectionView.leadingAnchor.constraint(equalTo: myScrollView.leadingAnchor),
            topCollectionView.heightAnchor.constraint(equalToConstant: 200),
            topCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topCollectionView.centerXAnchor.constraint(equalTo: myScrollView.centerXAnchor),
            showcaseLabel!.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 20),
            showcaseLabel!.leadingAnchor.constraint(equalTo: myScrollView.leadingAnchor),
            belowCollectionView.topAnchor.constraint(equalTo: showcaseLabel!.bottomAnchor, constant: 10),
            belowCollectionView.leadingAnchor.constraint(equalTo: myScrollView.leadingAnchor),
            belowCollectionView.trailingAnchor.constraint(equalTo: myScrollView.trailingAnchor),
            belowCollectionView.bottomAnchor.constraint(equalTo: myScrollView.bottomAnchor),
            belowCollectionView.heightAnchor.constraint(equalToConstant: 900),
        ])
        
        
        //        fabButton?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        //        fabButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        belowCollectionView.reloadData()
    }
    
    func setGradientBackground() {
        let colorTop = UIColor.darkGray.cgColor
        let colorBottom = UIColor.gray.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop as Any, colorBottom as Any]
        gradientLayer.locations = [0.2, 0.75]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
}

extension GeneralVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == topCollectionView {
            return 3
        }
        
        if collectionView == belowCollectionView {
            return amountOfBalowCollectionItems
        }
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? TopCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.backgroundColor = UIColor(displayP3Red: 20 / 255, green: 18 / 255, blue: 30 / 255, alpha: 1.0)
            cell.layer.cornerRadius = 15
            
            if self.modelGeneralVC.allCoinsRealm?.count != 0 && indexPath.row <= 2{
                
                UIView.transition(with: collectionView, duration: 0.3, options: .allowAnimatedContent, animations: {
                    
                    cell.date = self.modelGeneralVC.allCoinsRealmExceptFirstThreeCoin?[indexPath.item]
                    
                }, completion: nil)
                
            }
            
            return cell
        }
        
        if collectionView == belowCollectionView{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BelowCollectionCell", for: indexPath) as? BelowCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.backgroundColor = UIColor(displayP3Red: 20 / 255, green: 18 / 255, blue: 30 / 255, alpha: 1.0)
            cell.layer.cornerRadius = 15
            
            if self.modelGeneralVC.allCoinsRealm?.count != 0 {
                
                UIView.transition(with: collectionView, duration: 0.3, options: .allowAnimatedContent, animations: {
                    
                    cell.date = self.modelGeneralVC.allCoinsRealmExceptFirstThreeCoin?[indexPath.item]
                    
                }, completion: nil)
                
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension GeneralVC: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        let safeArea = view.layoutMarginsGuide
        
        let contentHeight = myScrollView.contentSize.height
        let scrollHeight = scrollView.bounds.height
        let scrollOffset = scrollView.contentOffset.y
        
        let result = scrollHeight + scrollOffset >= contentHeight
        
        if result {
            let currentItems = amountOfBalowCollectionItems
            amountOfBalowCollectionItems = currentItems + 20
            belowCollectionView.reloadData()
        }
        
        let scrollToBelowCollection = scrollHeight + scrollOffset >= contentHeight
        
        if scrollToBelowCollection {
            belowCollectionView.isScrollEnabled = true
        } else {
            belowCollectionView.isScrollEnabled = false
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = myScrollView.contentOffset.y
        
        let safeArea = view.layoutMarginsGuide
        
        if scrollOffset >= 15 && canChangeNavigation == false {
            //short navigation
            UIView.animate(withDuration: 0.5) {
                
                self.navigationLabelTopConstraint?.constant = 0
                self.backgroundToNavigationBottomConstraint?.constant = 10
                
                self.navigationLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
                self.navigationLabel.text = "Market by vol"
                self.subNavigationLabel.isHidden.toggle()
                
                self.canChangeNavigation.toggle()
                self.view.layoutIfNeeded()
            }
            
        }
        
        if scrollOffset <= 15 && canChangeNavigation == true {
            //big navigation
            UIView.animate(withDuration: 0.5) {
                
                self.navigationLabelTopConstraint?.constant = 20
                self.backgroundToNavigationBottomConstraint?.constant = 10
                
                self.navigationLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
                self.navigationLabel.text = "Market"
                self.subNavigationLabel.isHidden.toggle()
                
                self.canChangeNavigation.toggle()
                self.view.layoutIfNeeded()
            }
        }
        
        print("++ scroll offset \(-Int(scrollOffset))")
        
        if scrollOffset < 0 && scrollOffset >= -47{
            self.backgroundToNavigationBottomConstraint?.constant = CGFloat(10 + -Int(scrollOffset))
        }
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
}



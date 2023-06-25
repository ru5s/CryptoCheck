//
//  TabBarVC.swift
//  Crypto check
//
//  Created by Ruslan Ismailov on 18/06/23.
//

import UIKit

class TabBar: UITabBarController {

    let firstPage = GeneralVC()
    let secondPage = GeneralVC()
    let thirdPage = GeneralVC()
    
    var navigationColor = UIColor.white
    var tabBarActiveColor = UIColor.white
    var tabBarPassiveColor = UIColor.gray

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = tabBarActiveColor
        tabBar.unselectedItemTintColor = tabBarPassiveColor
        tabBar.backgroundColor = .black.withAlphaComponent(0.5)
        tabBar.isTranslucent = true
        
        setupVCs()
    }
    
    func setupVCs(){
        viewControllers = [
            createNavController(for: firstPage, title: "All coins", image: UIImage(systemName: "bonjour")!),
            createNavController(for: secondPage, title: "Charts", image: UIImage(systemName: "chart.line.uptrend.xyaxis")!),
            createNavController(for: thirdPage, title: "Settings", image: UIImage(systemName: "slider.vertical.3")!),
        ]
        
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = false
        navController.navigationController?.hidesBarsOnSwipe = true
        
        navController.navigationBar.titleTextAttributes = [.foregroundColor: navigationColor as Any]
        navController.navigationBar.isTranslucent = true
        
        navController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(backBtn))
        
        rootViewController.navigationItem.title = title
        return navController
    }
    
    @objc private func backBtn(){
        dismiss(animated: true)
    }
    

}

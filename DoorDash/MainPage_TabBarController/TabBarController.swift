//
//  TabBarController.swift
//  DoorDash
//
//  Created by Chen Wang on 4/13/19.
//  Copyright © 2019 utopia incubator. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //basic setting
        self.tabBar.isTranslucent = false
        self.title = "DoorDash"
        
        addLeftNavItemOnView()
        
        //add Explore and Favorites 
        addChilds()
    
    }
    
    public func addChilds(){
        let exploreController = ExploreController()
        exploreController.tabBarItem.title = "Explore"
        exploreController.tabBarItem.image = UIImage(named:"tab-explore")
        exploreController.tabBarItem.selectedImage = UIImage(named:"tab-explore")
        self.addChild(exploreController)
        
        
        
        let favoritesController = FavoritesController()
        favoritesController.tabBarItem.title = "Favorites"
        favoritesController.tabBarItem.image = UIImage(named:"tab-star")
        favoritesController.tabBarItem.selectedImage = UIImage(named:"star-white")
        self.addChild(favoritesController)
    }
    
    
    func addLeftNavItemOnView ()
    {
        let img = UIImage(named: "nav-address")
        
        let leftBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(leftNavButtonClick))
        self.navigationItem.leftBarButtonItem = leftBtn
        
        
        
    }
    
    @objc func leftNavButtonClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    
    

}

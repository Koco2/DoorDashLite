//
//  TabBarController.swift
//  DoorDash
//
//  Created by Chen Wang on 4/13/19.
//  Copyright © 2019 utopia incubator. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var lat:Double!
    var lng:Double!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tabBar.isTranslucent = false
        
        let exploreController = ExploreController()
        exploreController.lat = self.lat
        exploreController.lng = self.lng
        exploreController.tabBarItem.title = "Explore"
        //exploreController.tabBarItem.image = UIImage(named:"Explore")
        //exploreController.tabBarItem.selectedImage = UIImage(named:"tarbar1_yes")
        self.addChild(exploreController)
        
        
        
        let favoritesController = FavoritesController()
        favoritesController.tabBarItem.title = "Favorites"
        //favoritesController.tabBarItem.image = UIImage(named:"Favorites")
        self.addChild(favoritesController)
        

    }
    
    

}

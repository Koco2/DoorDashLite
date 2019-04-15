//
//  ExploreController.swift
//  DoorDash
//
//  Created by Chen Wang on 4/12/19.
//  Copyright © 2019 utopia incubator. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

//Users can browse a list of stores available to the location selected previously.
class ExploreController: UIViewController {
    
    //store data for nearby resturants
    var resturantList:[ResturantModel] = []
    var exploreTableView : UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : DoorDashRed]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //load the tableView
        display()
    }
}






//MARK: - to get and update resturant data--------------------------------------------------------------------
extension ExploreController{
    
    
    private func display(){
        //show progresshud untill all the resturant data have been added to resturantList
        SVProgressHUD.show()
        let urlString = "https://api.doordash.com/v1/store_search"
        let param = ["lat":String(lat),"lng":String(lng)]
        getResturants(url: urlString, parameters: param)
    }
    
    
    func getResturants(url:String, parameters:[String:String])
    {
        Alamofire.request(url, method:.get, parameters:parameters).responseJSON
            {
                response in
                if response.result.isSuccess
                {
                    print("Success! Got the resturant data!")
                    let jsonData : JSON = JSON(response.result.value!)
                    //print(jsonData[0]["cover_img_url"])
                    //print(jsonData.count)
                    //print(weatherJSON)
                    //self.updateWeatherData(json:weatherJSON)
                    
                    
                    //add retrieved data to resturantList
                    self.updateResturantData(jsonData: jsonData)
                }
                else
                {
                    print("Error \(String(describing: response.result.error))")
                }
        }
    }
    
    
    func updateResturantData(jsonData:JSON){
        var i = 0
        while i < jsonData.count{
            let data = jsonData[i]
            
            let newResturant = ResturantModel()
            newResturant.name = data["business"]["name"].stringValue
            //print(newResturant.name)
            newResturant.tag = data["tags"][0].stringValue
            //print(newResturant.tag)
            newResturant.imageURL = data["cover_img_url"].stringValue
            //print(newResturant.imageURL)
            newResturant.deliveryFee = data["delivery_fee"].intValue
            //print(newResturant.deliveryFee)
            newResturant.deliveryTime = data["asap_time"].intValue
            //print(newResturant.deliveryTime)
            
            resturantList.append(newResturant)
            i += 1
        }
        SVProgressHUD.dismiss()
        
        setUpTableView()
        exploreTableView.reloadData()
    }
}





//MARK: - for tableView -----------------------------------------------------------------------------------------

extension ExploreController:UITableViewDelegate,UITableViewDataSource{

    private func setUpTableView(){
        exploreTableView = UITableView(frame: view.bounds)
        self.view.addSubview(exploreTableView)

        //TODO: Set yourself as the delegate and datasource here:
        exploreTableView.delegate = self
        exploreTableView.dataSource = self
        
        //TODO: Register your MessageCell.xib file here:
        exploreTableView.register(ExploreCell.self, forCellReuseIdentifier: "exploreCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resturantList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        var cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell") as? ExploreCell
        if cell == nil {
            cell = ExploreCell(style: .default, reuseIdentifier: "exploreCell")
            cell!.setUp()
        }
        cell!.updateDate(data: resturantList[indexPath.row])
        return cell!
    }

}



//MARK: - to load image from Alamofire's response for tableView -----------------------------------------------
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

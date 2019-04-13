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

//https:\/\/cdn.doordash.com\/media\/restaurant\/cover\/The-Halal-Guys-RESIZED_2.png
class ExploreController: UIViewController {
    

    var lat:Double!
    var lng:Double!
    var resturantList:[ResturantModel] = []
    
    var exploreTableView : UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        setUpTableView()
        // Do any additional setup after loading the view.
//        print("lat: \(lat!), lon: \(lng!)")
//        let urlString = "https://api.doordash.com/v1/store_search"
//        let param = ["lat":String(lat),"lng":String(lng)]
        
//        getResturants(url: urlString, parameters: param)
        
//        let s = "https://cdn.doordash.com/media/restaurant/cover/The-Halal-Guys-RESIZED_2.png"
//        guard let url = URL(string: s) else {
//            print("String to URL failed")
//            return
//        }
//
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        imageView.load(url: url)
//
//        self.view.addSubview(imageView)
        
    }
    
}






//MARK: - to get and update resturant data
extension ExploreController{
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
                    self.updateResturantData(jsonData: jsonData)
                }
                else
                {
                    print("Error \(String(describing: response.result.error))")
                    //self.cityLabel.text = "Connecting Issue"
                }
        }
    }
    
    
    func updateResturantData(jsonData:JSON){
        var i = 0
        while i < jsonData.count{
            let data = jsonData[i]
            
            let newResturant = ResturantModel()
            newResturant.name = data["business"]["name"].stringValue
            print(newResturant.name)
            newResturant.tag = data["tags"][0].stringValue
            print(newResturant.tag)
            newResturant.imageURL = data["cover_img_url"].stringValue
            print(newResturant.imageURL)
            newResturant.deliveryFee = data["delivery_fee"].intValue
            print(newResturant.deliveryFee)
            newResturant.deliveryTime = data["asap_time"].intValue
            print(newResturant.deliveryTime)
            
            resturantList.append(newResturant)
            i += 1
        }
    }
}





//MARK: - for tableView

extension ExploreController:UITableViewDelegate,UITableViewDataSource{

    private func setUpTableView(){
        exploreTableView = UITableView(frame: view.bounds)
        self.view.addSubview(exploreTableView)

        //TODO: Set yourself as the delegate and datasource here:
        exploreTableView.delegate = self
        exploreTableView.dataSource = self
        
        //TODO: Register your MessageCell.xib file here:
        exploreTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        exploreTableView.register(ExploreCell.self, forCellReuseIdentifier: "exploreCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath)
        
        return cell
    }

}



//MARK: - to load image from Alamofire's response for tableView
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

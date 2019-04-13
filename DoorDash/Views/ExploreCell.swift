//
//  ExploreCell.swift
//  DoorDash
//
//  Created by Chen Wang on 4/13/19.
//  Copyright © 2019 utopia incubator. All rights reserved.
//

import UIKit
import SnapKit

class ExploreCell: UITableViewCell {
    
    var coverImage : UIImageView!
    var nameLabel : UILabel!
    var tagLabel : UILabel!
    var deliveryFeeLabel : UILabel!
    var deliveryTimeLabel : UILabel!

    
    
    
    
}

// MARK: - Views
extension ExploreCell{
    //setup UI
    public func setUp(data: ResturantModel){
        addCoverImage(urlString:data.imageURL)
        addNameLabel(name:data.name)
        addTagLabel(tag:data.tag)
        addDeliveryFeeLabel(fee:data.deliveryFee)
        addDeliveryTimeLabel(time:data.deliveryTime)
    }
    
    private func addCoverImage(urlString:String){
        
    }
    private func addNameLabel(name:String){
        
    }
    private func addTagLabel(tag:String){
        
    }
    private func addDeliveryFeeLabel(fee:Int){
        
    }
    private func addDeliveryTimeLabel(time:Int){
        
    }
    
    //SnapKit layout
    private func addLayout(){
        
    }
}

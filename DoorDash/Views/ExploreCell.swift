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

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UI setup ----------------------------------------------------------------------------------------
extension ExploreCell{
    //setup UI
    public func setUp(){
        addCoverImage()
        addNameLabel()
        addTagLabel()
        addDeliveryFeeLabel()
        addDeliveryTimeLabel()
        addLayout()
    }
    
    private func addCoverImage(){
        coverImage = UIImageView()
        coverImage.layer.cornerRadius = 4.0
        coverImage.clipsToBounds = true
        self.addSubview(coverImage)
    }
    private func addNameLabel(){
        nameLabel = UILabel()
        self.addSubview(nameLabel)
    }
    private func addTagLabel(){
        tagLabel = UILabel()
        self.addSubview(tagLabel)
    }
    private func addDeliveryFeeLabel(){
        deliveryFeeLabel = UILabel()
        self.addSubview(deliveryFeeLabel)
        
    }
    private func addDeliveryTimeLabel(){
        deliveryTimeLabel = UILabel()
        self.addSubview(deliveryTimeLabel)
    }
    
    //SnapKit layout
    private func addLayout(){
        coverImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH/3.5, height: SCREEN_HEIGHT/10))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(coverImage.snp.right).offset(15)
            make.size.equalTo(CGSize(width: 200, height: 20))
        }
        tagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalTo(deliveryFeeLabel.snp.top)
            make.left.equalTo(coverImage.snp.right).offset(15)
            make.height.equalTo(20)
        }
        deliveryFeeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.left.equalTo(coverImage.snp.right).offset(15)
            make.size.equalTo(CGSize(width: 200, height: 20))
        }
        deliveryTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(15)
            make.bottom.equalTo(15)
            make.size.equalTo(CGSize(width:SCREEN_HEIGHT/10 , height: SCREEN_HEIGHT/10))
        }
    }
    
    
    
    // MARK: - UI update-----------------------------------------------------------------------------------
    
    public func updateDate(data: ResturantModel){
        updateCoverImage(urlString:data.imageURL)
        updateNameLabel(name:data.name)
        updateTagLabel(tag:data.tag)
        updateDeliveryFeeLabel(fee:data.deliveryFee)
        updateDeliveryTimeLabel(time:data.deliveryTime)
    }
    
    
    private func updateCoverImage(urlString:String){
        guard let url = URL(string: urlString) else {
            print("String to URL failed")
            return
        }
        coverImage.load(url: url)
    }
    private func updateNameLabel(name:String){
        nameLabel.text = name
    }
    private func updateTagLabel(tag:String){
        tagLabel.text = tag
    }
    private func updateDeliveryFeeLabel(fee:Int){
        deliveryFeeLabel.text = String(fee)
    }
    private func updateDeliveryTimeLabel(time:Int){
        deliveryTimeLabel.text = String(time)
    }
    
}

//
//  ChooseAnAddressView.swift
//  DoorDash
//
//  Created by Chen Wang on 4/14/19.
//  Copyright © 2019 utopia incubator. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

class ChooseAnAddressView: UIView {

    public var map : MKMapView!
    public var addressLabel: UILabel!
    public var confirmButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        add_UI_components()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //add all UI components
    private func add_UI_components(){
        addAdressLabel()
        addConfirmButton()
        addMap()
        addLayout()
    }
    
    private func addAdressLabel(){
        addressLabel = UILabel()
        self.addSubview(addressLabel)
        addressLabel.backgroundColor = UIColor.white
        addressLabel.text = "Loading..."
        addressLabel.textAlignment = .center
        addressLabel.textColor = UIColor.lightGray
    }
    
    private func addConfirmButton(){
        confirmButton = UIButton()
        self.addSubview(confirmButton)
        
        confirmButton.backgroundColor = UIColor(red: 254/255, green: 26/255, blue: 64/255, alpha: 1)
        confirmButton.setTitle("Confirm Address", for: .normal)
    }
    
    private func addMap(){
        map = MKMapView()
        self.addSubview(map)
        
        //config
        //self.customMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        map.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        
    }
    
    
    //SnapKit layout
    private func addLayout(){
        confirmButton.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT/12)
            make.bottom.equalTo(0)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT/12)
            make.bottom.equalTo(confirmButton.snp.top)
        }
        
        map.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(addressLabel.snp.top)
        }
    }
        
    

}

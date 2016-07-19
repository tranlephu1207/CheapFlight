//
//  DayCollectionViewCell.swift
//  FlightTicketTracking
//
//  Created by lephu on 7/16/16.
//  Copyright © 2016 lephu. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    var textLabel:UILabel!
    var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(image: UIImage(named: "selectRound"))
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.center.equalTo(self.snp_center)
            make.height.equalTo(self.snp_height)
            make.width.equalTo(self.snp_width)
        }
        
        textLabel = UILabel()
        textLabel.textAlignment = .Center
        textLabel.font = UIFont(name: (textLabel.font?.fontName)!, size: 18)
        self.addSubview(textLabel)
        textLabel.snp_makeConstraints { (make) in
            make.center.equalTo(self.snp_center)
            make.height.equalTo(self.snp_height).multipliedBy(1)
            make.width.equalTo(textLabel.snp_height)
        }
        textLabel.layoutIfNeeded()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

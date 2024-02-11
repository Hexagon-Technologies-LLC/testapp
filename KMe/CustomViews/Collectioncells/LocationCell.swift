//
//  LocationCell.swift
//  KMe
//
//  Created by CSS on 13/09/23.
//

import UIKit

class LocationCell: UICollectionViewCell {
    @IBOutlet weak var locationNameLabel: UILabel!;
        
    

        var locationName: String
        {
            didSet
            {
                locationNameLabel.text = locationName;
            }
        }
        
        override var isSelected: Bool
        {
            didSet
            {
                locationNameLabel.textColor = isSelected ? UIColor.yellow : UIColor.white;
            }
        }


        required init?(coder aDecoder: NSCoder)
        {
            self.locationName = "";
            super.init(coder: aDecoder);
        }
}

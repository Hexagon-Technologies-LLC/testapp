//
//  ActivityTableViewCell.swift
//  KMe
//
//  Created by CSS on 19/09/23.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var profilename: UILabel!
    @IBOutlet weak var timesince: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  self.contentView.applyGradient(colours: [UIColor(named: "gradient_top")!,UIColor(named: "gradient_bottom")!])

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

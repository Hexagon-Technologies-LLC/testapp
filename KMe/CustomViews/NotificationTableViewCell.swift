//
//  NotificationTableViewCell.swift
//  KMe
//
//  Created by CSS on 21/09/23.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var profilename: UILabel!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var timesago: UILabel!
    @IBOutlet weak var descriptionlbl: UILabel!
    @IBOutlet weak var allowedlbl: UILabel!
    @IBOutlet weak var allowview: UIView!
    @IBOutlet weak var denyview: UIView!
    @IBOutlet weak var actionview: UIStackView!
    @IBOutlet weak var actionwidth: NSLayoutConstraint!
    @IBOutlet weak var okimage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updatecelldata(profile : Notify)
    {
        profilename.text = profile.profileName
        timesago.text = profile.timesince
        profileimage.loadImageUsingCache(withUrl: profile.image ?? "")
        descriptionlbl.text = profile.description
        if(profile.type == 2)
        {
            actionview.isHidden = false
            allowview.isHidden = false
            denyview.isHidden = false
            allowedlbl.text = "Allow"
            allowedlbl.textColor = .white
            actionwidth.constant = 100
            okimage.tintColor = .green.withAlphaComponent(1.0)

        }else if(profile.type == 3)
        {
            actionview.isHidden = false
            denyview.isHidden = true
            allowedlbl.text = "Allowed"
            allowedlbl.textColor = UIColor.white.withAlphaComponent(0.5)
            actionwidth.constant = 110
            okimage.tintColor = .green.withAlphaComponent(0.5)
        }else
        {
            actionview.isHidden = true
        }
    }
    
}

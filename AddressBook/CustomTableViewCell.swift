//
//  CustomTableViewCell.swift
//  AddressBook
//
//  Created by Seven on 11/24/15.
//  Copyright © 2015 Seven. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
// MARK: properties
    
    @IBOutlet weak var AvatarImg: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var phoneLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

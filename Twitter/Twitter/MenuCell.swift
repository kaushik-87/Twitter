//
//  MenuCell.swift
//  Twitter
//
//  Created by Kaushik on 10/7/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

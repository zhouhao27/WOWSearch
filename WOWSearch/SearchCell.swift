//
//  SearchCell.swift
//  WOWSearch
//
//  Created by Zhou Hao on 01/11/16.
//  Copyright © 2016年 Zhou Hao. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var searchBar: WOWSearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

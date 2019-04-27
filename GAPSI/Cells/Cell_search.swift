//
//  Cell_search.swift
//  GAPSI
//
//  Created by Isaac Rosas on 27/04/19.
//  Copyright © 2019 Isaac Rosas. All rights reserved.
//

import UIKit

class Cell_search: UITableViewCell {
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var historial: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

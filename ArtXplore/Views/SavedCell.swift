//
//  SavedCell.swift
//  ArtXplore
//
//  Created by Casey on 10/24/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import SDWebImage


class SavedCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    func configCell(art: Art) {
        title.text = art.name
        artist.text = art.artist
        img.sd_setImage(with: URL(string: art.jpg!), placeholderImage: UIImage(named: "Spinner.gif"))
        
    }

}

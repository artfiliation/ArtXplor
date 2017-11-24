//
//  ArtCell.swift
//  ArtXplore
//
//  Created by Casey on 10/10/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
//import Alamofire
import SDWebImage
import CoreData

class ArtCell: UITableViewCell {

    @IBOutlet weak var artTitle: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var typeArt: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    func configureCell(_ object: All) {
        artTitle.text = object.name
        artist.text = object.artist
        typeArt.text = "Type: \(object.type!.capitalized)"
        let url = URL(string: object.jpg!)
//        Alamofire.download(url!).responseData { response in
//            if let data = response.result.value {
//                self.img.image = UIImage(data: data)
//            }
//        }
        
        //let data = try? Data(contentsOf: url!)
        //img.image = UIImage(data: data!)
        img.sd_setImage(with: URL(string: object.jpg!), placeholderImage: UIImage(named: "Spinner.gif"))
    }

}

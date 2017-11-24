//
//  ArtDetailsVC.swift
//  ArtXplore
//
//  Created by Casey on 10/16/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class ArtDetailsVC: UIViewController {

    @IBOutlet weak var picTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var nation: UILabel!
    @IBOutlet weak var techn: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var museum: UILabel!
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var button: UIButton!
    var btnStarred = false

    var artworkToLoad: All?
    var savedToLoad: Art?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadArt()
    }
    
    func loadArt() {
        if let item = artworkToLoad {
            print("Item Received")
            picTitle.text = item.name
            //let url = URL(string: item.jpg)
            img.sd_setImage(with: URL(string: item.jpg!), placeholderImage: UIImage(named: "Spinner.gif"))
            author.text = "  Author: \(item.artist ?? "Unknown")"
            nation.text = "  Nation: \(item.school ?? "Unknown")"
            genre.text =  "  Genre: \(item.genre?.capitalized ?? "Unknown")"
            museum.text = "  Found at: \(item.loc ?? "Unknown")"
            year.text = "  Year: \(item.time ?? "Unknown")"
            techn.text = "  Technique: \(item.tech ?? "Unknown")"
        }
        if let item = savedToLoad {
            print("Item Recieved")
            picTitle.text = item.name
            //let url = URL(string: item.jpg)
            img.sd_setImage(with: URL(string: item.jpg!), placeholderImage: UIImage(named: "Spinner.gif"))
            author.text = "  Author: \(item.artist ?? "Unknown")"
            nation.text = "  Nation: \(item.school ?? "Unknown")"
            genre.text =  "  Genre: \(item.genre?.capitalized ?? "Unknown")"
            museum.text = "  Found at: \(item.location ?? "Unknown")"
            year.text = "  Year: \(item.time ?? "Unknown")"
            techn.text = "  Technique: \(item.tec ?? "Unknown")"
            button.isHidden = true
        }
    }
   
    @IBAction func backPressed(_ sender: UIButton) {
        print("Button Pressed")
        self.dismiss(animated: true)
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        if btnStarred == false {
            let favAlert = UIAlertController(title: "Favorite?", message: "Photo will be saved to Favorite for later viewing.", preferredStyle: UIAlertControllerStyle.alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Okayed")
                self.button.setImage(#imageLiteral(resourceName: "starB"), for: .normal)
                self.btnStarred = true
                print("Starred The Photo")
                //Save the photo to favorites
                let newArt = Art(context: context)
                if let item = self.artworkToLoad {
                    print("Item Received")
                    newArt.name = item.name
                    newArt.artist = item.artist
                    newArt.jpg = item.jpg
                    newArt.type = item.type
                    newArt.location = item.loc
                    newArt.tec = item.tech
                    newArt.time = item.time
                    newArt.genre = item.genre
                    newArt.school = item.school
                    
                    ad.saveContext()
                }
            }
            
            favAlert.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("Canceled")
            }
            
            favAlert.addAction(cancelAction)
            present(favAlert, animated: true, completion: nil)
            
        } else {
            print("Already faved")
        }
    }
    
}

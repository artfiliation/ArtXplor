//
//  table.swift
//  ArtXplore
//
//  Created by Casey on 10/10/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import CSV
import Alamofire
import CoreData


class TableArtVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var artTableView: UITableView!
    
    //var artwork = [ArtWork]()
    var filteredArt: [All]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artTableView.delegate = self
        artTableView.dataSource = self
        
        //parseArtCSV()
    }
    
    //table-functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return ARTWORKS.count
        return (filteredArt?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = artTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArtCell
        //cell.configureCell(ARTWORKS[indexPath.row])
        cell.configureCell(filteredArt![indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let item = ARTWORKS[indexPath.row]
        let item = filteredArt![indexPath.row]
        
        print("\nItem passed: " ,item.name)
        let destination = ArtDetailsVC()
        destination.artworkToLoad = item
        
        performSegue(withIdentifier: "artSegue", sender: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "artSegue"
        {
            if let destination = segue.destination as? ArtDetailsVC{
                if let item = sender as? All{
                    destination.artworkToLoad = item
                }
            }
        }
    }
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        print("Button Pressed")
        self.dismiss(animated: true)
        
    }
    
//    func parseArtCSV() {
//        print("Trying to parse CSV")
//        let path = Bundle.main.path(forResource: "artworks", ofType: "csv")!
//        let stream = InputStream(fileAtPath: path)!
//
//        let csv = try! CSVReader(stream: stream, hasHeaderRow: true)
//        let headerRow = csv.headerRow!
//        print("Header: \(headerRow)")
//
//        while let row = csv.next() {
//            print("\n\(row)")
//            let arttitle = csv["TITLE"]!
//            let name = csv["AUTHOR"]!
//            let url = csv["URL"]!
//            print("ArtName: \(arttitle) \nAuthor: \(name)")
//
//
//
//            let art = ArtWork(title: arttitle, artist: name)
//            artwork.append(art)
//        }
//
//    }
    
}

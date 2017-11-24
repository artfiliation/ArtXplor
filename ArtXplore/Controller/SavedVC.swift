//
//  SavedVC.swift
//  ArtXplore
//
//  Created by Casey on 10/24/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import CoreData

class SavedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var savedTableView: UITableView!
    var listOfArt = [Art]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedTableView.delegate = self
        savedTableView.dataSource = self
        print("Saved Art")
        //generateData()
        
        getArt()
        for name in listOfArt {
            print(name.artist)
        }
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfArt.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savedTableView.dequeueReusableCell(withIdentifier: "Saved", for: indexPath) as! SavedCell
        cell.configCell(art: listOfArt[indexPath.row])
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let item = ARTWORKS[indexPath.row]
        let item = listOfArt[indexPath.row]
        
        print("\nItem passed: " ,item.name!)
        let destination = ArtDetailsVC()
        destination.savedToLoad = item
        
        performSegue(withIdentifier: "savedDetailsSegue", sender: item)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savedDetailsSegue"
        {
            if let destination = segue.destination as? ArtDetailsVC{
                if let item = sender as? Art{
                    destination.savedToLoad = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            print("Deleting Saved Art")
            context.delete(listOfArt[indexPath.row])
            listOfArt.remove(at: indexPath.row)
            savedTableView.deleteRows(at: [indexPath], with: .fade)
            
            ad.saveContext()
        }
    }
  
    @IBAction func backPressed(_ sender: UIButton) {
        print("Button Pressed")
        self.dismiss(animated: true)
    }
    
    func getArt() {
        let fetchReq: NSFetchRequest<Art> = Art.fetchRequest()
        do {
            listOfArt = try context.fetch(fetchReq)
        } catch {
            print("Could not get Core Data")
        }
        
    }
    
    
    
    //Testing Core Data
    
    func generateData() {
        let newArt = Art(context: context)
        newArt.name = "Mona Lisa"
        newArt.artist = "de Vinci"
        newArt.jpg = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/1200px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg"
        
        
        ad.saveContext()
        
    }
    
    
    
    
    
    
}

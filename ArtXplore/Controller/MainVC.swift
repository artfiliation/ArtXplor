//
//  ViewController.swift
//  ArtXplore
//
//  Created by Casey on 10/10/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import CSV
import CoreData

class MainVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var currentTextField: UITextField?
    
    @IBOutlet weak var keyWordS: UITextField!
    
    @IBOutlet weak var formfield: UITextField!
    
    @IBOutlet weak var fromField: UITextField!
    
    @IBOutlet weak var tillField: UITextField!
    
    @IBOutlet weak var nationField: UITextField!
    
    @IBOutlet weak var typeField: UITextField!
    
    var filteredArt = [All]()
    
    var forms = ["painting", "sculpture", "metalwork", "graphics", "illumination", "architecture", "ceramics", "mosaic"]
    var types = ["mythological","genre","portrait","landscape","religious","other","historical","interior","study","still-life"]
    var nations = ["german","italian","danish","spanish","french","dutch","swiss","greek","american","austrian","portuguese","english","irish","catalan","scottish","flemish","netherlandish"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getArt()
        // Do any additional setup after loading the view, typically from a nib.
        if !(ARTWORKS.count > 0) {
            print("Empty array")
            parseArtCSV()
            getArt()
        } else {
            print("Already filled")
        }
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(cancelPicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        
        let formPickerView = UIPickerView()
        formPickerView.tag = 1
        formPickerView.showsSelectionIndicator = true
        formPickerView.delegate = self
        formfield.inputAccessoryView = toolBar
        formfield.inputView = formPickerView
        
        let nationPickerView = UIPickerView()
        nationPickerView.tag = 2
        nationPickerView.showsSelectionIndicator = true
        nationPickerView.delegate = self
        nationField.inputAccessoryView = toolBar
        nationField.inputView = nationPickerView
        
        let typePickerView = UIPickerView()
        typePickerView.tag = 3
        typePickerView.showsSelectionIndicator = true
        typePickerView.delegate = self
        typeField.inputAccessoryView = toolBar
        typeField.inputView = typePickerView
    }

    func parseArtCSV() {
        print("Trying to parse CSV")
        let path = Bundle.main.path(forResource: "artworks", ofType: "csv")!
        let stream = InputStream(fileAtPath: path)!
        
        let csv = try! CSVReader(stream: stream, hasHeaderRow: true)
        let headerRow = csv.headerRow!
        print("Header: \(headerRow)")
        
        while let row = csv.next() {
            print("\n\(row)")
            let arts = All(context: context)
            var artArr = [String]()
            let arttitle = csv["TITLE"]!
            artArr.append(arttitle)
            arts.name = arttitle
            let name = csv["AUTHOR"]!
            artArr.append(name)
            arts.artist = name
            let url = csv["URL"]!
            artArr.append(url)
            let jpg = getJPG(artist: name, url: url)
            arts.jpg = jpg
            let form = csv["FORM"]!
            artArr.append(form)
            arts.type = form
            let tech = csv["TYPE"]!
            artArr.append(tech)
            arts.genre = tech
            let date = csv["TIMELINE"]!
            artArr.append(date)
            arts.time = date
            let nation = csv["SCHOOL"]!
            artArr.append(nation)
            arts.school = nation
            let location = csv["LOCATION"]!
            artArr.append(location)
            arts.loc = location
            let techn = csv["TECHNIQUE"]!
            artArr.append(techn)
            arts.tech = techn
            print("ArtName: \(arttitle) \nAuthor: \(name)")
            ad.saveContext()
            //let art = ArtWork(art: artArr)
            
            //ARTWORKS.append(art)
        }
        
    }
    
    func getJPG(artist: String, url: String) -> String {
        if !artist.contains("ARCHITECT") {
            let firstLetter = String(artist.characters.first!).lowercased()
            
            let range = url.range(of: "/"+firstLetter+"/")
            let newURL = url.suffix(from: (range?.upperBound)!)
            print(newURL)
            let endIndex = newURL.index(newURL.endIndex, offsetBy: -5)
            let truncated = newURL[..<endIndex]
            print(truncated)
            let fullURL = BASE_URL + firstLetter + "/" + truncated + END_URL
            print(fullURL)
            return fullURL
        } else {
            let range = url.range(of: "/zzzarchi/")
            let newURL = url.suffix(from: (range?.upperBound)!)
            print(newURL)
            let endIndex = newURL.index(newURL.endIndex, offsetBy: -5)
            let truncated = newURL[..<endIndex]
            print(truncated)
            let fullURL = "https://www.wga.hu/art/zzzarchi/" + truncated + END_URL
            print(fullURL)
            return fullURL
        }
        
    }
    
    func getArt() {
        let fetchReq: NSFetchRequest<All> = All.fetchRequest()
        do {
            ARTWORKS = try context.fetch(fetchReq)
        } catch {
            print("Could not get Core Data")
        }
        
    }
    
    
    
    
    
    @IBAction func searchPressed(_ sender: Any) {
        let stringS = keyWordS.text!.lowercased()
        
        filteredArt = ARTWORKS.filter({$0.name?.lowercased().range(of: stringS) != nil || $0.artist?.lowercased().range(of: stringS) != nil})
        if (filteredArt.count > 0) {
            let destination = TableArtVC()
            destination.filteredArt = filteredArt
            
            performSegue(withIdentifier: "tableSegue", sender: filteredArt)
            keyWordS.text = ""
        } else {
            print("No search results found!")
            var searched = keyWordS.text
            let warnAlert = UIAlertController(title: "No Results!", message: "No artWork with parameters: " + searched!, preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    print("Okayed")
                }
            
            warnAlert.addAction(okAction)
            present(warnAlert, animated: true, completion: nil)
            keyWordS.text = ""
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableSegue"
        {
            if let destination = segue.destination as? TableArtVC{
                if let item = sender as? [All] {
                    destination.filteredArt = item
                }
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return forms.count
        }
        
        if pickerView.tag == 2 {
            return nations.count
        }
        
        if pickerView.tag == 3 {
            return types.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return forms[row].capitalized as String
        }
        
        if pickerView.tag == 2 {
            return nations[row].capitalized as String
        }
        
        if pickerView.tag == 3 {
            return types[row].capitalized as String
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            formfield.text = forms[row].capitalized
        }
        
        if pickerView.tag == 2 {
            nationField.text = nations[row].capitalized
        }
        
        if pickerView.tag == 3 {
            typeField.text = types[row].capitalized
        }
    }
    
    @objc func donePicker() {
        if formfield.isEditing {
            formfield.resignFirstResponder()
        }
        if nationField.isEditing {
            nationField.resignFirstResponder()
        }
        if typeField.isEditing {
            typeField.resignFirstResponder()
        }
    }
    
    @objc func cancelPicker() {
        
        if formfield.isEditing {
            formfield.resignFirstResponder()
            formfield.text = ""
        }
        if nationField.isEditing {
            nationField.resignFirstResponder()
            nationField.text = ""
        }
        if typeField.isEditing {
            typeField.resignFirstResponder()
            typeField.text = ""
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    @IBAction func filteredSearchPressed(_ sender: Any) {
        filteredArt = ARTWORKS
        if formfield.text != "" {
            var text = formfield.text?.lowercased()
            filteredArt = ARTWORKS.filter({$0.type?.lowercased().range(of: text!) != nil})
        }
        if typeField.text != "" {
            var text = typeField.text?.lowercased()
            if (filteredArt.count > 0) {
                filteredArt = filteredArt.filter({$0.genre?.lowercased().range(of: text!) != nil})
            } else {
                filteredArt = ARTWORKS.filter({$0.genre?.lowercased().range(of: text!) != nil})
            }
        }
        
        if nationField.text != "" {
            var text = nationField.text?.lowercased()
            if (filteredArt.count > 0) {
                filteredArt = filteredArt.filter({$0.school?.lowercased().range(of: text!) != nil})
            } else {
                filteredArt = ARTWORKS.filter({$0.school?.lowercased().range(of: text!) != nil})
            }
        }
        
        if (filteredArt.count > 0) {
            let destination = TableArtVC()
            destination.filteredArt = filteredArt
            
            performSegue(withIdentifier: "tableSegue", sender: filteredArt)
        } else {
            print("No search results found!")
            let warnAlert = UIAlertController(title: "No Results!", message: "No ArtWork with parameters", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Okayed")
            }
        
            warnAlert.addAction(okAction)
            present(warnAlert, animated: true, completion: nil)
        }
    
    
    }
}

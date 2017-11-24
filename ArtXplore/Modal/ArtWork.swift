//
//  ArtWork.swift
//  ArtXplore
//
//  Created by Casey on 10/11/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import Foundation

class ArtWork {
    
    private var _title: String!
    private var _artist: String!
    private var _url: String!
    private var _jpg: String!
    private var _type: String!
    private var _genre: String!
    private var _school: String!
    private var _time: String!
    private var _loc: String!
    private var _tec: String!
    
    init(art: [String]) {
        self._title = art[0]
        self._artist = art[1]
        self._url = art[2]
        self._type = art[3]
        self._genre = art[4]
        self._school = art[6]
        self._time = art[5]
        self._loc = art[7]
        self._tec = art[8]
        self._jpg = getJPG()
    }
    
    
    var title: String {
        if _title == nil {
            _title = ""
            
        }
        return _title
    }
    
    var artist: String {
        if _artist == nil {
            _artist = ""
            
        }
        return _artist
    }
    
    var url: String {
        if _url == nil {
            _url = ""
            
        }
        return _url
    }
    
    var jpg: String {
        if _jpg == nil {
            _jpg = ""
            
        }
        return _jpg
    }
    
    var type: String {
        if _type == nil {
            _type = ""
            
        }
        return _type
    }
    
    var genre: String {
        if _genre == nil {
            _genre = ""
            
        }
        return _genre
    }
    
    var school: String {
        if _school == nil {
            _school = ""
            
        }
        return _school
    }
    
    var loc: String {
        if _loc == nil {
            _loc = ""
            
        }
        return _loc
    }
    
    var tec: String {
        if _tec == nil {
            _tec = ""
            
        }
        return _tec
    }
    
    var time: String {
        if _time == nil {
            _time = ""
            
        }
        return _time
    }
    
    func getJPG() -> String {
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
}

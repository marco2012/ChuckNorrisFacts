//
//  API.swift
//  ChuckNorris
//
//  Created by Marco on 03/09/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import Foundation
import SwiftSoup
import Alamofire
import SwiftyJSON

class API {
    
    // current document
    var document: Document = Document.init("")
    
    //Download HTML
    func getJokeITAold() -> [String] {
        
        let link = "https://www.frisby.cc/chuck-norris-facts.html"
        let url = URL(string: link)
        var jokes : [String] = []
        
        do {
            // content of url
            let html = try String.init(contentsOf: url!)
            // parse it into a Document
            document = try SwiftSoup.parse(html)
            
            let text: Elements = try document.select("p")
            for (index, element) in text.enumerated() {
                let t = try element.text()
                if (index > 12) && (t != "") {
                    jokes.append(t)
                }
            }
            
        } catch let error {
            // an error occurred
            print("Error: \(error)")
        }
        
        return jokes
        
    }
    
    func getJokeITA(completionHandler: @escaping ((String) -> Void)) {
        
        let index = Int.random(in: 1 ... 4667) //numero massimo di post nel blog
        let url = "https://welovechucknorris.blogspot.com/feeds/posts/summary?alt=json&start-index=\(index)&max-results=2"
        let pattern = "^\\s+|\\s+$|\\s+(?=\\s)" //Strip leading, trailing and more than 1 space from String https://stackoverflow.com/a/30375449
        
        // Fetch Request
        Alamofire.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    print("\(url)")
                    
                    var joke = JSON(response.result.value!)["feed"]["entry"][1]["summary"]["$t"]
                        .stringValue
                        .replacingOccurrences(of: pattern, with: "", options: .regularExpression)
                    
                    let id = index
                
                    joke = String( joke.characters.prefix(upTo: joke.characters.index( of: "(")! ) ) //remove text between parentheses
                    
                    completionHandler(joke) //returns newly created albums array with all the pictures
                    
                }
                else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                    
                }
        }
    }
    
    func getJokeENG(completionHandler: @escaping ((String) -> Void)) {

        let url = "https://api.chucknorris.io/jokes/random"
        
        // Fetch Request
        Alamofire.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    print("\(url)")

                    let data = JSON(response.result.value!)
                    let joke = data["value"].stringValue
                    let id   = data["id"].stringValue
                    
                    completionHandler(joke) //returns newly created albums array with all the pictures
                    
                }
                else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                    
                }
        }
    }

}


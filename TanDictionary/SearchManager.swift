//
//  SearchManager.swift
//  TanDictionary
//
//  Created by dinh trong thang on 8/11/16.
//  Copyright © 2016 dinh trong thang. All rights reserved.
//

import Foundation
import UIKit
class SearchManager {
    var tus = [Tuc]()
    var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask : NSURLSessionDataTask?
    var delegate:SearchManagerDelegate!
    static var shareSearchManager = SearchManager()

    func getDataFromSearchText(searchText:String,dictionIndex:Int) {
        if searchText != "" {
            if dataTask != nil {
                dataTask?.cancel()
            }
            let charSet = NSCharacterSet.URLQueryAllowedCharacterSet()
            let stringTerm = searchText.stringByAddingPercentEncodingWithAllowedCharacters(charSet)
            var url:NSURL!
            switch dictionIndex {
            case 0:
                url = NSURL(string: "https://glosbe.com/gapi/translate?from=eng&dest=vie&format=json&phrase=\(stringTerm!)&pretty=true")
            case 1:
                url = NSURL(string: "https://glosbe.com/gapi/translate?from=vie&dest=eng&format=json&phrase=\(stringTerm!)&pretty=true")
            default:
                print("error")
            }
//            let url = NSURL(string: "https://glosbe.com/gapi/translate?from=eng&dest=vie&format=json&phrase=\(stringTerm!)&pretty=true")
            dataTask = session.dataTaskWithURL(url!) {
                data,response,error in
                if let error = error {
                    print(error)
                }
                
                if let httpReponse = response as? NSHTTPURLResponse {
                    if httpReponse.statusCode == 200 {

                        self.updateData(data!)
                   
                        
                    }
                }
            }
            dataTask?.resume()
        }
    }
    func updateData(data:NSData) {
        do {
            if let response = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [String:AnyObject] {
                if let array:AnyObject = response["tuc"] {
                    for tuc in array as! [AnyObject] {
                        if let tuc = tuc as? [String:AnyObject] {
                            let tu = Tuc()
                            if let phrase = tuc["phrase"] as? [String:AnyObject]{
                                if let text = phrase["text"]! as? String{
                                    tu.phrase.text = text
                                }
                            }
                            if let meanings:[AnyObject] = tuc["meanings"] as? [AnyObject] {
                                for meaning in meanings  {
                                    if let meaning = meaning as? [String:AnyObject] {
                                        if let mean = meaning["text"] as? String {
                                            tu.meanings.append(Meaning(text: mean))
                                        }
                                    }
                                    
                                }
                            }
                            self.tus.append(tu)
                        }
                    }
                }
            }
        } catch {
        }
        self.delegate.assignData(self.tus)
        self.tus.removeAll()
    }
}
protocol SearchManagerDelegate {
    func assignData(tus:[Tuc])
}
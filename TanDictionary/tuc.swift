//
//  tuc.swift
//  TanDictionary
//
//  Created by dinh trong thang on 8/11/16.
//  Copyright © 2016 dinh trong thang. All rights reserved.
//

import Foundation
class Meaning {
    var language = ""
    var text = ""
    init(text:String) {
        self.text=text
    }
}
class Phrase {
    var language = ""
    var text = ""
}
class Tuc {
    var phrase=Phrase()
    var meanings = [Meaning]()
    
}


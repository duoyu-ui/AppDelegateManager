//
//  File.swift
//  Project
//
//  Created by 汤姆 on 2019/8/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

import Foundation
import HandyJSON
import UIKit


struct HaderWavesIconModel {
    
    var icon :String?
    var title :String?
    var content :String?
    var gameId: String?
    var tag: Int?
    
   
    init(icon: String, title: String) {
        self.icon = icon
        self.title = title
    }
    
    init(icon: String, title: String, tag: Int) {
        self.icon = icon
        self.title = title
        self.tag = tag
    }
    
    init(icon: String, title: String, gameId: String) {
        self.icon = icon
        self.title = title
        self.gameId = gameId
    }
    
    init(icon: String, title: String, content: String) {
        self.icon = icon
        self.title = title
        self.content = content
    }
}

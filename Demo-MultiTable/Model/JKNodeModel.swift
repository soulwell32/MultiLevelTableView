//
//  JKNodeModel.swift
//  Demo-MultiTable
//
//  Created by 梅霖 on 2019/1/3.
//  Copyright © 2019 梅霖. All rights reserved.
//

import Foundation

class JKNodeModel {
    var parentID: String!
    var childrenID: String!
    var name: String?
    var isExpand: Bool = false
    var level: Int?
    var isLeaf: Bool = false
    var isRoot: Bool = false
    var isSelected: Bool = false
    
    convenience init(parentID:String, name:String,childrenID:String) {
        self.init(parentID: parentID, name: name, childrenID: childrenID, level: nil)
    }
    
    init (parentID:String, name:String, childrenID:String, level:Int?) {
        self.parentID = parentID
        self.name = name
        self.childrenID = childrenID
        self.level = level
    }
    
    var description: String {
        return "\(String(describing: name)) level:\(String(describing: level)) isExpand:\(isExpand)"
    }
}


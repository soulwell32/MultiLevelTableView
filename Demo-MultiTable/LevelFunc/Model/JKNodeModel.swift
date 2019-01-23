//
//  JKNodeModel.swift
//  Demo-MultiTable
//
//  Created by 梅霖 on 2019/1/3.
//  Copyright © 2019 梅霖. All rights reserved.
//

import Foundation

class JKNodeModel:NSObject,NSCoding {
    
    var hasChildrenRegion: String!
    var parentID: String!
    var childrenID: String!
    var name: String?
    var isExpand: Bool = false
    var level: Int?
    var isLeaf: Bool = false
    var isRoot: Bool = false
    var isSelected: Bool = false
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
    }
    
    convenience init(parentID:String, name:String, childrenID:String, hasChildrenRegion:String) {
        self.init(parentID: parentID, name: name, childrenID: childrenID, level: nil, hasChildrenRegion: hasChildrenRegion)
    }
    
    init (parentID:String, name:String, childrenID:String, level:Int?, hasChildrenRegion:String) {
        self.parentID = parentID
        self.name = name
        self.childrenID = childrenID
        self.level = level
        self.hasChildrenRegion = hasChildrenRegion
        
        //项目特性可以直接判断
        self.isRoot = parentID == "-1" ? true : false
        self.isLeaf = hasChildrenRegion == "0" ? true : false
    }
    
    override var description: String {
        return "parentID:\(String(describing: parentID)) childrenID:\(String(describing: childrenID)) name:\(String(describing: name)) level:\(String(describing: level)) isExpand:\(isExpand)"
    }
}

// MARK: - Important: Always use the same properties in both your == and hash(into:) methods
// MARK: - NSObject已经遵守了Hashable协议
extension JKNodeModel {
    override var hash:Int {
        var hasher = Hasher()
        hasher.combine(parentID)
        hasher.combine(childrenID)
        hasher.combine(name)
        return hasher.finalize()
    }
}

// MARK: - NSObject已经遵守了Equatable协议
extension JKNodeModel {
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? JKNodeModel else { return false }
        return self.parentID == other.parentID && self.childrenID == other.childrenID && self.name == other.name
    }
}

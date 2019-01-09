//
//  ViewController.swift
//  Demo-MultiTable
//
//  Created by 梅霖 on 2019/1/2.
//  Copyright © 2019 梅霖. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var displayLevelView: JKMultiLevelTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
    }

    func initUI() {
        let frame = self.view.frame
        let rect = CGRect.init(x: 20, y: 20, width: frame.width - 40, height: frame.height - 40)
        let fakeNodes = fakeData()
        displayLevelView = JKMultiLevelTableView.init(frame: rect, nodes: fakeNodes, rootID: nil, selectBlock: { (selectedNode) in
            print("选中节点" + (selectedNode.name ?? "name is nil"))
        })
        self.view.addSubview(displayLevelView!)
    }
    
    func fakeData() -> [JKNodeModel] {
        
        let list = [["parentID":"-1", "name":"Node1", "ID":"1", "hasChildrenRegion":"1"],
                    ["parentID":"1", "name":"Node10", "ID":"10", "hasChildrenRegion":"1"],
                    ["parentID":"1", "name":"Node11", "ID":"11", "hasChildrenRegion":"1"],
                    ["parentID":"10", "name":"Node100", "ID":"100", "hasChildrenRegion":"0"],
                    ["parentID":"10", "name":"Node101", "ID":"101", "hasChildrenRegion":"0"],
                    ["parentID":"11", "name":"Node110", "ID":"110", "hasChildrenRegion":"0"],
                    ["parentID":"11", "name":"Node111", "ID":"111", "hasChildrenRegion":"1"],
                    ["parentID":"111", "name":"Node1110", "ID":"1110", "hasChildrenRegion":"0"],
                    ["parentID":"111", "name":"Node1111", "ID":"1111", "hasChildrenRegion":"0"],
                    ["parentID":"-1", "name":"Node2", "ID":"2", "hasChildrenRegion":"1"],
                    ["parentID":"2", "name":"Node20", "ID":"20", "hasChildrenRegion":"1"],
                    ["parentID":"20", "name":"Node200", "ID":"200", "hasChildrenRegion":"0"],
                    ["parentID":"20", "name":"Node201", "ID":"201", "hasChildrenRegion":"0"],
                    ["parentID":"20", "name":"Node202", "ID":"202", "hasChildrenRegion":"0"],
                    ["parentID":"2", "name":"Node21", "ID":"21", "hasChildrenRegion":"1"],
                    ["parentID":"21", "name":"Node210", "ID":"210", "hasChildrenRegion":"0"],
                    ["parentID":"21", "name":"Node211", "ID":"211", "hasChildrenRegion":"1"],
                    ["parentID":"21", "name":"Node212", "ID":"212", "hasChildrenRegion":"0"],
                    ["parentID":"211", "name":"Node2110", "ID":"2110", "hasChildrenRegion":"0"],
                    ["parentID":"211", "name":"Node2111", "ID":"2111", "hasChildrenRegion":"0"]]
        var array = [JKNodeModel]()
        for dic in list {
            if let pID = dic["parentID"],let name = dic["name"],let id = dic["ID"],let hasChild = dic["hasChildrenRegion"] {
                let node = JKNodeModel.init(parentID: pID, name: name, childrenID: id, hasChildrenRegion: hasChild)
                array.append(node)
            }
        }
        return array as [JKNodeModel]
    }
}


//
//  JKMultiLevelTableView.swift
//  Demo-MultiTable
//
//  Created by 梅霖 on 2019/1/3.
//  Copyright © 2019 梅霖. All rights reserved.
//

import UIKit


class JKMultiLevelTableView: UITableView {
    var preservation: Bool = false
    var rootID: String!
    /// 原始的节点数据
    var nodes: [JKNodeModel]!
    /// 当前显示的节点数据
    var tempNodes: [JKNodeModel]!
    /// 需要插入或删除的RowIndex
    var reloadArray: [IndexPath]?
    var selectBlock:((JKNodeModel) -> Void)?
    var selectedNodeID:String?
    static let cellHeight:CGFloat = 45.0

    // MARK: - init
    convenience init(frame:CGRect, nodes:[JKNodeModel], rootID:String?, selectBlock:((JKNodeModel) -> Void)?) {
        self.init(frame: frame, style: .plain)
        self.rootID = rootID ?? "-1"
        self.selectBlock = selectBlock
        self.preservation = false
        configNodes(nodes: nodes)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.backgroundColor = UIColor.white
        tempNodes = [JKNodeModel]()
        reloadArray = [IndexPath]()
        self.separatorStyle = .none
        self.dataSource = self
        self.delegate = self
        self.rowHeight = JKMultiLevelTableView.cellHeight
        self.register(UINib.init(nibName: "JKMultiLevelCell", bundle: nil), forCellReuseIdentifier: "JKMultiLevelCell")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("JKMultiLevelTableView deinit ---~~~---")
    }
    
    // MARK: - Nodes Config
    func configNodes(nodes:[JKNodeModel]) {
        self.nodes = nodes
//        judgeLeafAndRootNodes()
        updateNodesLevel()
        addFirstLoadNodes()
        reloadData()
    }
    
    func addNodesFromRequest(newNodes:[JKNodeModel]) {
        nodes.append(contentsOf: newNodes)
        updateNodesLevel()
    }
    
    //项目自带root、leaf属性
    /*
    func judgeLeafAndRootNodes() {
        for node in nodes {
            var isLeaf = true
            var isRoot = true
            for anotherNode in nodes {
                if anotherNode.parentID == node.childrenID {
                    isLeaf = false
                }
                if anotherNode.childrenID == node.parentID {
                    isRoot = false
                }
                if (isLeaf == false && isRoot == false) {
                    break
                }
            }
            node.isRoot = isRoot
            node.isLeaf = isLeaf
        }
    }
    */
    
    func updateNodesLevel() {
        setDepthWithParentIdAndChildrenNodes(nodeLevel: 1, parentIDs: [rootID], childrenNodes: nodes)
    }
    
    func setDepthWithParentIdAndChildrenNodes(nodeLevel:Int, parentIDs:[String], childrenNodes:[JKNodeModel]) {
        var newParentIDs = [String]()
        var leftNodes = childrenNodes
        
        for node in childrenNodes {
            if parentIDs.contains(node.parentID) {
                node.level = nodeLevel
                leftNodes = leftNodes.filter({ (leftNode) -> Bool in
                    leftNode.childrenID != node.childrenID
                })
                newParentIDs.append(node.childrenID)
            }
        }
        
        if leftNodes.count > 0 {
            let nextLevel = nodeLevel + 1
            setDepthWithParentIdAndChildrenNodes(nodeLevel: nextLevel, parentIDs: newParentIDs, childrenNodes: leftNodes)
        }
    }
    
    func addFirstLoadNodes() {
        for node in nodes {
            if node.isRoot == true {
                tempNodes.append(node)
            }
        }
        reloadArray = [IndexPath]()
    }
    
    func updateSelectedNode(nodeID:String) {
        selectedNodeID = nodeID
        nodes.forEach { (node) in
            if node.childrenID != selectedNodeID {
                node.isSelected = false
            } else {
                node.isSelected = true
            }
        }
        reloadData()
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension JKMultiLevelTableView : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempNodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JKMultiLevelCell") as! JKMultiLevelCell
        cell.node(node: tempNodes[indexPath.row])
        cell.cellIndicatorBlock = {[weak self] node in
            if self?.selectBlock != nil {
                self?.selectBlock!(node)
            }
            self?.updateSelectedNode(nodeID: node.childrenID)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = tempNodes[indexPath.row] as JKNodeModel
        
        if node.isLeaf {
            //1.LeafNode处理点击事件
            if selectBlock != nil {
                selectBlock!(node)
            }
            updateSelectedNode(nodeID: node.childrenID)
            return
        } else {
            node.isExpand = !node.isExpand
        }
        
        //单独刷新一次cell
        tableView.reloadRows(at: [indexPath], with: .none)
        
        reloadArray?.removeAll()
        if node.isExpand {
            //2.展开节点
            //2.1新增网络请求判断
            /*
            if needRequestExpandNodes(node: node) {
                FakeNetwork.shared.queryChildrenRegion(region: node.childrenID) {[weak self] (bool, nodeArray) in
                    if bool {
                        self?.addNodesFromRequest(newNodes: nodeArray!)
                        self?.expandNodesFor(parentID: node.childrenID!, insertIndex: indexPath.row)
                        tableView.insertRows(at: (self?.reloadArray)!, with: .none)
                    }
                }
            } else {
                expandNodesFor(parentID: node.childrenID!, insertIndex: indexPath.row)
                tableView.insertRows(at: reloadArray!, with: .none)
            }
            */
            
            expandNodesFor(parentID: node.childrenID!, insertIndex: indexPath.row)
            tableView.insertRows(at: reloadArray!, with: .none)
        } else {
            //3.收起节点
            foldNodesFor(level: node.level!, currentIndex: indexPath.row)
            tableView.deleteRows(at: reloadArray!, with: .none)
        }
        
    }
}

// MARK: - Cells Expand or Fold
extension JKMultiLevelTableView {
    func needRequestExpandNodes(node: JKNodeModel) -> Bool {
        for everyNode in nodes {
            if everyNode.parentID == node.childrenID {
                return false
            }
        }
        return true
    }
    
    func expandNodesFor(parentID:String, insertIndex: Int) -> Void {
        var theInsertIndex = insertIndex
        for node in nodes {
            if node.parentID == parentID {
                node.isExpand = false
                theInsertIndex = theInsertIndex + 1
                tempNodes.insert(node, at: theInsertIndex)
                reloadArray?.append(IndexPath.init(row: theInsertIndex, section: 0))
            }
        }
    }
    
    func foldNodesFor(level:Int, currentIndex:Int) -> Void {
        if currentIndex + 1 < tempNodes.count {
            let copyTempNodes = tempNodes!
            
            for i in stride(from: currentIndex + 1, to: tempNodes.count, by: 1) {
                if copyTempNodes[i].level! <= copyTempNodes[currentIndex].level! {
                    break
                } else {
                    tempNodes = tempNodes.filter({ (node) -> Bool in
                        node.childrenID != copyTempNodes[i].childrenID
                    })
                    reloadArray?.append(IndexPath.init(row: i, section: 0))
                }
            }
        }
    }
}

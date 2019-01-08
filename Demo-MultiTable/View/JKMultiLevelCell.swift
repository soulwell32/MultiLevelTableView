//
//  JKMultiLevelCell.swift
//  Demo-MultiTable
//
//  Created by 梅霖 on 2019/1/3.
//  Copyright © 2019 梅霖. All rights reserved.
//

import UIKit

class JKMultiLevelCell: UITableViewCell {

    @IBOutlet weak var arrowView: UIImageView!
    @IBOutlet weak var selectIndicatorView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var arrowViewLeadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var arrowViewWidthConstrain: NSLayoutConstraint!
    var cellIndicatorBlock:((JKNodeModel) -> Void)?
    var cellNode:JKNodeModel!
    let levelMarginDistance: CGFloat = 25
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func node(node:JKNodeModel) {
        self.cellNode = node
        nameLabel.text = node.name
        arrowViewLeadingConstrain.constant = 10 + levelMarginDistance * CGFloat((node.level! - 1))
        
        if node.isExpand {
            arrowView.image = UIImage.init(named: "upArrow")
        } else {
            arrowView.image = UIImage.init(named: "downArrow")
        }
        
        if node.isLeaf {
            arrowView.alpha = 0.0
        } else {
            arrowView.alpha = 1.0
        }
        
        if node.isSelected {
            selectIndicatorView.image = UIImage.init(named: "selectedCircle")
        } else {
            selectIndicatorView.image = UIImage.init(named: "unselectedCircle")
        }
    }
    
    @IBAction func indicatorSelected(_ sender: UITapGestureRecognizer) {
        guard cellIndicatorBlock != nil else {
            return
        }
        cellIndicatorBlock!(cellNode)
    }
    
    
}
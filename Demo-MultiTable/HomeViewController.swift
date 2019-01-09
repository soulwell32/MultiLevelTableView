//
//  HomeViewController.swift
//  Demo-MultiTable
//
//  Created by 梅霖 on 2019/1/9.
//  Copyright © 2019 梅霖. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var regionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func regionButtonClicked(_ sender: UIButton) {
        let regionVC = TreeViewController()
        regionVC.selectedRegionBlock = { selectedNode in
            self.regionButton.setTitle(selectedNode.name, for: .normal)
        }
        self.navigationController?.pushViewController(regionVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

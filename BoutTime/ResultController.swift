//
//  ResultController.swift
//  BoutTime
//
//  Created by XuanWang on 6/12/16.
//  Copyright © 2016 XuanWang. All rights reserved.
//

import UIKit

class ResultController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    var receivedString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = receivedString

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

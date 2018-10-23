//
//  ViewController.swift
//  LivePlayer
//
//  Created by yuan on 2018/10/22.
//  Copyright © 2018年 com.liveplayer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func PlayAction(_ sender: Any) {
        let board = UIStoryboard(name: "PlayController", bundle: nil)
        let controller : PlayController = board.instantiateInitialViewController() as! PlayController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func LiveAction(_ sender: Any) {
        let board = UIStoryboard(name: "LiveController", bundle: nil)
        let controller : LiveController = board.instantiateInitialViewController() as! LiveController
        navigationController?.pushViewController(controller, animated: true)
    }
}


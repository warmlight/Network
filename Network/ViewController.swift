//
//  ViewController.swift
//  Network
//
//  Created by lyy on 2017/10/10.
//  Copyright © 2017年 lyy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        RequestApi
            .delete(from: "https://www.easy-mock.com/mock/5a041457ee02577ac4bb528b/example/deleteTest")
            .addParam(["name": "sb"])
            .request(success: { (response) in
                print(response)
            })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


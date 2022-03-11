//
//  ViewController.swift
//  ZTTools_Swift
//
//  Created by git on 03/01/2022.
//  Copyright (c) 2022 git. All rights reserved.
//

import UIKit
import ZTToolsSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.green
        button.setTitle("点击", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(test), for: .touchUpInside)
        button.frame = CGRect(x: 20, y: 200, width: 100, height: 30)
        view.addSubview(button)
    }

    @objc private func test() {
        print(ZTDeviceManager.buildVersion)
        print(ZTDeviceManager.version)
        print(ZTDeviceManager.bundleIdentifier)
        print("-------------------------\n\n")
        
        kLog("log")
    }
}

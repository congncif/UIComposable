//
//  ViewController.swift
//  UIComposable
//
//  Created by NGUYEN CHI CONG on 10/23/2020.
//  Copyright (c) 2020 NGUYEN CHI CONG. All rights reserved.
//

import UIComposable
import UIKit

class ViewController: DiffComposableListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInsetAdjustmentBehavior = .automatic

        let element1 = UIElement(identifier: "1", contentViewController: {
            let newVC = UIViewController()
            newVC.view.backgroundColor = UIColor.red

            NSLayoutConstraint.activate([
                newVC.view.heightAnchor.constraint(equalToConstant: 100)
            ])

            return newVC
        }())

        let element2 = UIElement(identifier: "2", contentViewController: {
            let newVC = UIViewController()
            newVC.view.backgroundColor = UIColor.blue

            NSLayoutConstraint.activate([
                newVC.view.heightAnchor.constraint(equalToConstant: 200)
            ])

            return newVC
        }())

        putUIElementAction(.update(element: element1))
        putUIElementAction(.update(element: element2))
        
        self.composeInterface(elements: [element1, element2])

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            let element2x = UIElement(identifier: "2", contentViewController: {
                let newVC = UIViewController()
                newVC.view.backgroundColor = UIColor.green
                
                NSLayoutConstraint.activate([
                    newVC.view.heightAnchor.constraint(equalToConstant: 400)
                ])
                
                return newVC
            }())
            self.putUIElementAction(.update(element: element2x))
        }
    }
}

//
//  ViewController.swift
//  UIComposable
//
//  Created by NGUYEN CHI CONG on 10/23/2020.
//  Copyright (c) 2020 NGUYEN CHI CONG. All rights reserved.
//

import UIComposable
import UIKit

class ViewController: UIViewController {
    let listViewController = ComposableListViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        let listView: UIView = listViewController.view
        view.addSubview(listView)

        listView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            listView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listView.topAnchor.constraint(equalTo: view.topAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let element1 = UIElement(identifier: "1", contentViewController: {
            let newVC = UIViewController()
            newVC.view.backgroundColor = UIColor.red
            return newVC
        }())

        let element2 = UIElement(identifier: "2", contentViewController: {
            let newVC = UIViewController()
            newVC.view.backgroundColor = UIColor.blue
            return newVC
        }())

        listViewController.composeInterface(elements: [element1, element2])

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            let element3 = UIElement(identifier: "2", contentViewController: {
                let newVC = UIViewController()
                newVC.view.backgroundColor = UIColor.green
                return newVC
            }())
            self.listViewController.composeInterface(elements: [element1, element3, element2])
        }
    }
}

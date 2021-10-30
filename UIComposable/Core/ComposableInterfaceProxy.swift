//
//  ComposableInterfaceProxy.swift
//  UIComposable
//
//  Created by NGUYEN CHI CONG on 10/30/21.
//

import Foundation

public protocol ComposableInterfaceProxy: ComposableInterface {
    var composableInterface: ComposableInterface { get }
}

public extension ComposableInterfaceProxy {
    var composedElements: [UIElement] {
        composableInterface.composedElements
    }

    var elementSortRule: ((UIElement, UIElement) -> Bool)? {
        composableInterface.elementSortRule
    }

    func composeInterface(elements: [UIElement]) {
        composableInterface.composeInterface(elements: elements)
    }
}

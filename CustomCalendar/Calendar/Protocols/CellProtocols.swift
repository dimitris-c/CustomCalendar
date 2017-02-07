//
//  CellProtocols.swift
//  CustomCalendar
//
//  Created by Dimitris C. on 07/02/2017.
//  Copyright © 2017 Decimal. All rights reserved.
//

import UIKit

protocol Reusable: class {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

protocol PrototypableCell {
    associatedtype Item
    func configurePrototype(with item: Item, size: CGSize)
}

protocol ConfigurableCell {
    associatedtype Item
    func configure(with item: Item)
}

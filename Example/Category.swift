//
//  Category.swift
//  Example
//
//  Created by khara on 10/19/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Magnetic

protocol CategoryColorProtocol {
    var normalFillColor: UIColor { get }
    var normalStrokeColor: UIColor { get }
    var normalFontColor: UIColor { get }
    var selectedFillColor: UIColor { get }
    var selectedStrokeColor: UIColor { get }
    var selectedFontColor: UIColor { get }
}

extension CategoryColorProtocol {
    var normalFillColor: UIColor { return UIColor.white }
    var normalStrokeColor: UIColor { return UIColor.black }
    var normalFontColor: UIColor { return UIColor.black }
    var selectedFillColor: UIColor { return UIColor.gray }
    var selectedStrokeColor: UIColor { return UIColor.black }
    var selectedFontColor: UIColor { return UIColor.white }
}

protocol MainCategoryProtocol: CategoryColorProtocol {
    var subCategoryRadiuses: [CGFloat] { get }
}

extension MainCategoryProtocol {
    var subCategoryRadiuses: [CGFloat] { return [40, 50, 60, 70] }
}

protocol SubCategoryProtocol: CategoryColorProtocol {
}

class MainCategory: Node, MainCategoryProtocol {
    init(text: String?, radius: CGFloat) {
        super.init(text: text, image: nil, color: UIColor.white, radius: radius)

        self.fillColor = self.normalFillColor
        self.strokeColor = self.normalStrokeColor
        self.label.fontColor = self.normalFontColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open var isSelected: Bool {
        didSet {
            guard self.isSelected != oldValue else { return }
            self.fillColor = self.selectedFillColor
            self.strokeColor = self.selectedStrokeColor
            self.label.fontColor = self.selectedFontColor
        }
    }
}

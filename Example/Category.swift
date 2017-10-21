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

    func changeColors(toSelected: Bool)
}

extension CategoryColorProtocol where Self: Node {
    var normalFillColor: UIColor { return UIColor.white }
    var normalStrokeColor: UIColor { return UIColor.black }
    var normalFontColor: UIColor { return UIColor.black }
    var selectedFillColor: UIColor { return UIColor(red: 0, green: 73/255, blue: 89/255, alpha: 1.0) }
    var selectedStrokeColor: UIColor { return UIColor.black }
    var selectedFontColor: UIColor { return UIColor.white }

    func changeColors(toSelected: Bool) {
        if toSelected {
            self.color = self.selectedFillColor
            self.fillColor = self.selectedFillColor
            self.strokeColor = self.selectedStrokeColor
            self.label.fontColor = self.selectedFontColor
        } else {
            self.color = self.normalFillColor
            self.fillColor = self.normalFillColor
            self.strokeColor = self.normalStrokeColor
            self.label.fontColor = self.normalFontColor
        }
    }
}

protocol MainCategoryProtocol {
    var subCategoryRadiuses: [CGFloat] { get }
    var numberOfSubCategories: Int { get }
    func generateSubCategories(notifySubCategory: (_ subCategory: SubCategory) -> Void)
}

extension MainCategoryProtocol {
    var subCategoryRadiuses: [CGFloat] { return [40, 50, 60, 70] }
    var numberOfSubCategories: Int { return 6 }
    func generateSubCategories(notifySubCategory: (_ subCategory: SubCategory) -> Void) {
        for _ in 0 ..< self.numberOfSubCategories {
            let radius = self.subCategoryRadiuses.randomItem()
            let subCategory = SubCategory(text: "\(radius)", radius: radius)
            notifySubCategory(subCategory)
        }
    }
}

protocol SubCategoryProtocol {
}

class Category: Node, CategoryColorProtocol {
    init(text: String?, radius: CGFloat) {
        super.init(text: text, image: nil, color: UIColor.white, radius: radius)

        self.changeColors(toSelected: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open var isSelected: Bool {
        didSet {
            guard self.isSelected != oldValue else { return }
            self.changeColors(toSelected: self.isSelected)
        }
    }

    var isMovable: Bool {
        get { return self.physicsBody?.isDynamic ?? false }
        set { self.physicsBody?.isDynamic = newValue }
    }
}

class MainCategory: Category, MainCategoryProtocol {
}

class SubCategory: Category, SubCategoryProtocol {
}

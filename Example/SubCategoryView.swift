//
//  SubCategoryView.swift
//  Example
//
//  Created by khara on 10/20/17.
//

import UIKit
import Magnetic

class SubCategoryView: UIView {
    private var magneticView: MagneticView!

    static func make(withFrame: CGRect, mainCategory: MainCategory) -> SubCategoryView {
        let subCategoryView = SubCategoryView(frame: withFrame)
        subCategoryView.backgroundColor = UIColor.clear

        subCategoryView.magneticView = MagneticView(frame: withFrame)
        subCategoryView.addSubview(subCategoryView.magneticView)

        subCategoryView.setup(withMainCategory: mainCategory)

        return subCategoryView
    }

    private func setup(withMainCategory: MainCategory) {
        self.magneticView.magnetic.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 0.74)
        self.magneticView.backgroundColor = UIColor.clear

        let radius = CGFloat(Int(withMainCategory.frame.width / 2) - 1) // Node.init 内で physicsBody を作る時に入力の radius に +2 しているのの補正
        let selectedCategory = MainCategory(text: withMainCategory.text, radius: radius)
        selectedCategory.isSelected = true
        let center = CGPoint(x: withMainCategory.frame.midX, y: withMainCategory.frame.midY)
        selectedCategory.physicsBody?.isDynamic = false

        self.magneticView.magnetic.magneticField.position = center
        self.magneticView.magnetic.addChild(selectedCategory)
        selectedCategory.position = center

        self.addSubCategories(withMainCategory: withMainCategory)
    }

    private let numberOfSubCategories = Int(6)

    func addSubCategories(withMainCategory: MainCategory) {
        for _ in 0 ..< self.numberOfSubCategories {
            let radius = withMainCategory.subCategoryRadiuses.randomItem()
            let subCategory = SubCategory(text: "\(radius)", radius: radius)
            self.magneticView.magnetic.addChild(subCategory)
        }
    }
}

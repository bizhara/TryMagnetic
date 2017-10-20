//
//  SubCategoryViewProtocol.swift
//  Example
//
//  Created by khara on 10/20/17.
//

import UIKit
import Magnetic

protocol SubCategoryViewProtocol {
    func setup(withMainCategory: MainCategory)
}

extension SubCategoryViewProtocol where Self: MagneticView {
    func setup(withMainCategory: MainCategory) {
        self.magnetic.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 0.74)
        self.backgroundColor = UIColor.clear

        let radius = CGFloat(Int(withMainCategory.frame.width / 2) - 1) // Node.init 内で physicsBody を作る時に入力の radius に +2 しているのの補正
        let selectedCategory = MainCategory(text: withMainCategory.text, radius: radius)
        selectedCategory.isSelected = true
        let center = CGPoint(x: withMainCategory.frame.midX, y: withMainCategory.frame.midY)
        selectedCategory.physicsBody?.isDynamic = false

        self.magnetic.magneticField.position = center
        self.magnetic.addChild(selectedCategory)
        selectedCategory.position = center
    }
}

extension MagneticView: SubCategoryViewProtocol {
}

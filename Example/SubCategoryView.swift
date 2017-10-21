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
    private var whenClosed: (() -> Void)?
    private var selected: Node?

    static func make(withFrame: CGRect, mainCategory: MainCategory, whenClosed: (() -> Void)?) -> SubCategoryView {
        let subCategoryView = SubCategoryView(frame: withFrame)

        subCategoryView.magneticView = MagneticView(frame: subCategoryView.bounds)
        subCategoryView.addSubview(subCategoryView.magneticView)

        subCategoryView.setup(withMainCategory: mainCategory)
        subCategoryView.whenClosed = whenClosed

        return subCategoryView
    }

    private let animationSpeed = CGFloat(4.0)

    private func setup(withMainCategory: MainCategory) {
        self.backgroundColor = UIColor.clear
        self.magneticView.backgroundColor = UIColor.clear
        self.magneticView.magnetic.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 0.74)
        self.magneticView.magnetic.magneticDelegate = self
        self.magneticView.magnetic.physicsWorld.speed = self.animationSpeed // これでアニメーション速度の調整ができるが、この中で起こる全てに影響してしまう

        let radius = CGFloat(Int(withMainCategory.frame.width / 2) - 1) // Node.init 内で physicsBody を作る時に入力の radius に +2 しているのの補正
        let selectedCategory = MainCategory(text: withMainCategory.text, radius: radius)
        selectedCategory.isSelected = true
        selectedCategory.isMovable = false
        let center = CGPoint(x: withMainCategory.frame.midX, y: withMainCategory.frame.midY)

        self.magneticView.magnetic.magneticField.position = center // magnetic.addChild したものがここに集まるように動く点
        self.magneticView.magnetic.addChild(selectedCategory)
        selectedCategory.position = center // magnetic.addChild 内で child の位置調整をしているので、意図した位置に置くにはここで設定

        withMainCategory.generateSubCategories { [weak self] (subCategory) in
            self?.magneticView.magnetic.addChild(subCategory)
        }
    }
}

extension SubCategoryView: MagneticDelegate {
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        self.selected?.isSelected = false
        self.selected = node
        // 選択された状態で呼び出されるので注意
        // self.selected?.isSelected = true
    }

    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        if node is MainCategory {
            self.whenClosed?()
            self.removeFromSuperview()
        }
    }
}

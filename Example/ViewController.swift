//
//  ViewController.swift
//  Example
//
//  Created by Lasha Efremidze on 3/8/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import SpriteKit
import Magnetic

class ViewController: UIViewController {
    
    @IBOutlet weak var magneticView: MagneticView! {
        didSet {
            magnetic.magneticDelegate = self
            #if DEBUG
                magneticView.showsFPS = true
                magneticView.showsDrawCount = true
                magneticView.showsQuadCount = true
            #endif
        }
    }
    
    var magnetic: Magnetic {
        return magneticView.magnetic
    }

    private let initialItems = Int(12)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.magnetic.magneticField.position = CGPoint(x: 40, y: 280)
    }

    private func makeOne(withRadius: CGFloat) -> MainCategory {
        return MainCategory(text: "\(withRadius)", radius: withRadius)
    }

    @IBAction func load(_ sender: UIControl?) {
        let lastFrame = self.magneticView.frame
        self.magneticView.removeFromSuperview()
        let magneticView = MagneticView(frame: lastFrame)
        self.view.addSubview(magneticView)
        self.magneticView = magneticView

        for _ in 0 ..< self.initialItems {
            let one = self.makeOne(withRadius: CGFloat.radiuses.randomItem())
            self.magnetic.addChild(one)
        }
    }

    @IBAction func add(_ sender: UIControl?) {
        let one = self.makeOne(withRadius: CGFloat.radiuses.randomItem())
        magnetic.addChild(one)
    }
    
    @IBAction func reset(_ sender: UIControl?) {
        let speed = magnetic.physicsWorld.speed
        magnetic.physicsWorld.speed = 0
        let sortedNodes = magnetic.children.flatMap { $0 as? Node }.sorted { node, nextNode in
            let distance = node.position.distance(from: magnetic.magneticField.position)
            let nextDistance = nextNode.position.distance(from: magnetic.magneticField.position)
            return distance < nextDistance && node.isSelected
        }
        var actions = [SKAction]()
        for (index, node) in sortedNodes.enumerated() {
            node.physicsBody = nil
            let action = SKAction.run { [unowned magnetic, unowned node] in
                if node.isSelected {
                    let point = CGPoint(x: magnetic.size.width / 2, y: magnetic.size.height + 40)
                    let movingXAction = SKAction.moveTo(x: point.x, duration: 0.2)
                    let movingYAction = SKAction.moveTo(y: point.y, duration: 0.4)
                    let resize = SKAction.scale(to: 0.3, duration: 0.4)
                    let throwAction = SKAction.group([movingXAction, movingYAction, resize])
                    node.run(throwAction) { [unowned node] in
                        node.removeFromParent()
                    }
                } else {
                    node.removeFromParent()
                }
            }
            actions.append(action)
            let delay = SKAction.wait(forDuration: TimeInterval(index) * 0.002)
            actions.append(delay)
        }
        magnetic.run(.sequence(actions)) { [unowned magnetic] in
            magnetic.physicsWorld.speed = speed
        }
    }
    
}

// MARK: - MagneticDelegate
extension ViewController: MagneticDelegate {
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        print("didSelect -> \(node)")

        if let mainCategory = node as? MainCategory {
            self.magneticView.isUserInteractionEnabled = false
            mainCategory.physicsBody?.isDynamic = false
            mainCategory.isSelected = false

            let subCategoryView = SubCategoryView.make(withFrame: self.magneticView.bounds, mainCategory: mainCategory)
            self.magneticView.addSubview(subCategoryView)
        }
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        print("didDeselect -> \(node)")
    }
    
}

// MARK: - ImageNode
class ImageNode: Node {
    override var image: UIImage? {
        didSet {
            sprite.texture = image.map { SKTexture(image: $0) }
        }
    }
    override func selectedAnimation() {}
    override func deselectedAnimation() {}
}

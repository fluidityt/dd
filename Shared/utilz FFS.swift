//
//  utilz FFS.swift

import SpriteKit

// MARK: - My funcs:
func killNode(_ node: SKNode) {
  node.physicsBody = nil
  node.removeAllChildren()
  node.removeAllActions()
  node.removeFromParent()
}

func changeFont(_ labels: [SKLabelNode]) {
  for label in labels {
    label.fontName = "Chalkduster"
    label.fontColor = .black
  }
}

/// Top label is [0]
func offSetLabel(_ labels: [SKLabelNode], by amount: CGFloat = 50) {
  var counter = CGFloat(0); for label in labels {
    if label == labels[0] { continue } else { counter += 1 }
    label.position.y = labels[0].position.y - (labels[0].frame.height + amount) * counter
  }
}

/// For use with anchorpoints and pbs
func pbCenter(on node: SKSpriteNode) -> CGPoint {
  return  CGPoint(x: CGFloat(node.size.width * (node.anchorPoint.x - 0.5) - node.size.width),
                  y: CGFloat(node.size.height * (0.5 - node.anchorPoint.y)))
}

func setBackGroundColor(forScene: SKScene) {
  forScene.backgroundColor = SKColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
}

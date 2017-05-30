//
//  Winby3.swift
//  dd

import SpriteKit
//
// PLAYER
//

class Player3: SKSpriteNode {
  
  var platform: Platform3?
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
    isUserInteractionEnabled = true
  }
  
  func keepInBounds() {
    if let scene = scene {
      if position.y < scene.frame.minY {
        position.y = scene.frame.minY
        physicsBody?.velocity = CGVector.zero
      }
      
    }
  }
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")  }
}

//
// PLATFORM
//

class Platform3: SKSpriteNode {
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
    isUserInteractionEnabled = true
  }
  
  let dir_left  = "left"
  let dir_right = "right"
  let vec_left  = CGVector(dx: -60, dy: 0)
  let vec_right = CGVector(dx: 60, dy: 0)
  var going = "left"
  
  required init?(coder aDecoder: NSCoder) {    fatalError("init(coder:) has not been implemented")  }
}

//
// WINBY 3
//

class Winby3: SKScene, SKPhysicsContactDelegate {
  
  let player = Player3(color: .yellow, size: CGSize(width: 50, height: 50))
  
  var platforms: [String: Platform3] = [:]
  
  let PLAT_HEIGHT = 35.f
  let vec_jump = CGVector(dx: 0, dy: 20)
  
  var platformCount = 0
  
  var nextLine = 0
  
  var baseSpawnPos = CGPoint() // needs to be configured, lazy?
  
  var lastSpawnSide = "right"
  
  var commands: [()->()] = []
  
}

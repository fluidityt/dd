//
//  Winby3.swift
//  dd

import SpriteKit
//
// PLAYER
//

class Player3: SKSpriteNode {
  
  var platform: Platform3?
  
  let vec_jump = CGVector(dx: 0, dy: 20)
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
    isUserInteractionEnabled = true
  }
  
  
  func resetPB() {
    physicsBody = SKPhysicsBody(rectangleOf: size, category: UInt32(1), collision: UInt32(2), contact: UInt32(2))
    physicsBody!.allowsRotation = false
  }
  
  func jump() {
    resetPB()
    position.y += 1
    platform = nil
    physicsBody?.affectedByGravity = true
    physicsBody!.applyImpulse(vec_jump)
  }

  
  func keepInBounds() {
    func resetVelocity() {  physicsBody?.velocity = CGVector.zero }
    
    if let scene = scene {
      let offsetY = size.halfHeight
      let offsetX = size.halfWidth
      
      if position.y < scene.frame.minY {
        position.y = scene.frame.minY + offsetY
        resetVelocity()
      } else if position.y > scene.frame.maxY {
        position.y = scene.frame.maxY - offsetY
        resetVelocity()
      } else if position.x < scene.frame.minX {
        position.x = scene.frame.minX + offsetX
        resetVelocity()
      } else if position.x > scene.frame.maxX {
        position.x = scene.frame.maxX - offsetX
        resetVelocity()
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
  
  var going = "left"
  //var yVal = 0.f
  
  let dir_left  = "left"
  let dir_right = "right"
  let vec_left  = CGVector(dx: -60, dy: 0)
  let vec_right = CGVector(dx: 60, dy: 0)
  
  required init?(coder aDecoder: NSCoder) {    fatalError("init(coder:) has not been implemented")  }

/*  func keepAtYVal() {
    position.y = yVal
  }*/
  
}

//
// WINBY 3
//

class Winby3: SKScene, SKPhysicsContactDelegate {
  
  let player = Player3(color: .yellow, size: CGSize(width: 50, height: 50))
  
  var platforms: [String: Platform3] = [:]
  
  let PLAT_HEIGHT = 35.f
  
  var platformCount = 0
  
  var nextLine = 0
  
  var baseSpawnPos = CGPoint() // needs to be configured, lazy?
  
  var lastSpawnSide = "right"
  
  var commands: [()->()] = []
  
}

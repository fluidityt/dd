//
//  Winby3.swift
//  dd

import SpriteKit
//
// PLAYER
//

class Player3: SKSpriteNode {
  
  var platform: Platform3?
  
  let vec_jump = CGVector(dx: 0, dy: 400)
  
  init(color: SKColor, size: CGSize) { super.init(texture: nil, color: color, size: size) }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")  }
  
  func resetPB() {
    physicsBody = SKPhysicsBody(rectangleOf: size, category: UInt32(1), collision: UInt32(2), contact: UInt32(2))
    physicsBody!.allowsRotation = false
    physicsBody!.usesPreciseCollisionDetection = true
    
  }
  
  func jump() {
    resetPB()
    position.y += 2 // Clear enough to not trigger contact.
    platform = nil
    physicsBody?.affectedByGravity = true
    physicsBody!.applyImpulse(vec_jump)
  }

  func keepInBounds() {
    func resetVelocity() {  physicsBody!.velocity = CGVector.zero }
    
    if let scene = scene {
      let offsetY = size.halfHeight, offsetX = size.halfWidth
      
      if position.y < scene.frame.minY + offsetY {
        position.y = scene.frame.minY + offsetY
        resetVelocity()
      } else if position.y > scene.frame.maxY - offsetY {
        position.y = scene.frame.maxY - offsetY
        resetVelocity()
      } else if position.x < scene.frame.minX + offsetX {
        position.x = scene.frame.minX + offsetX
        resetVelocity()
      } else if position.x > scene.frame.maxX - offsetX {
        position.x = scene.frame.maxX - offsetX
        resetVelocity()
      }
    }
  }
};

//
// PLATFORM
//
//let label = SKLabelNode(text: "hi", fontColor: .white, fontSize: 32)

class Platform3: SKSpriteNode {
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
  }
  
  var command: Optional<()->()>
  
  var going = "left"
  
  let dir_left  = "left"
  let dir_right = "right"
  let vec_left  = CGVector(dx: -60, dy: 0)
  let vec_right = CGVector(dx: 60, dy: 0)
  
  required init?(coder aDecoder: NSCoder) {    fatalError("init(coder:) has not been implemented")  }
};

//
// WINBY 3
//
let label = SKLabelNode(fontNamed: "Chalkduster")
func debug(_ text: String) { label.text = text }

class Winby3: SKScene, SKPhysicsContactDelegate {
  
  let player = Player3(color: .yellow, size: CGSize(width: 50, height: 50))
  
  var platforms: [String: Platform3] = [:]
  
  let PLAT_HEIGHT = 35.f
  
  let GRAV_DOWN = CGVector(dx: 0, dy: -40)
  
  var nextLine = 1 // Used for positioning of next node, as well as name of node to keep track of in dict, and for collisions.
  
  lazy var baseSpawnPos: CGPoint = {
    let y = self.player.frame.maxY + self.player.size.halfHeight + 1
    return CGPoint(x: 0, y: y)
  }()
  
  
  var lastSpawnSide = "right"
  
  var skipThisFrameContact = false
  var throwDSFFlag = false
  var dsfPlatform: Platform3?
  
};

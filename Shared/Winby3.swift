//
//  Winby3.swift
//  dd

import SpriteKit
//
// PLAYER
//

class Player3: SKSpriteNode {
  
  var platform: Platform3?
  
  var isAlive = true
  
  let vec_jump = CGVector(dx: 0, dy: 100)
  
  init(color: SKColor, size: CGSize) { super.init(texture: nil, color: color, size: size) }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")  }
  
  func resetPB() {
    physicsBody = SKPhysicsBody(
      rectangleOf: size,
      category: UInt32(1),
      collision: UInt32(2),
      contact: UInt32(2)
    )
    physicsBody!.allowsRotation = false
    physicsBody!.usesPreciseCollisionDetection = true
    
  }
  
  func jump() {
    resetPB()
    position.y += 2 // Clear enough to not trigger contact.
    platform = nil
    physicsBody!.affectedByGravity = true
    physicsBody!.applyImpulse(vec_jump)
  }

  func land(on platform: Platform3) {
    self.platform = platform
    resetPB()
    physicsBody!.affectedByGravity = false
    position.y = platform.frame.point.topMiddle.y + size.halfHeight
  }
  
  func die() {
    debug("DEAD")
    print("dead")
    isAlive = true
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
  // Use SKAction as this command?
  var command: Optional<()->()>
  
  var going = "left"
  
  // The only good case for a setter:
  private var _hasBeenScored = false
  func hasBeenScored() -> Bool { return _hasBeenScored  }
  func setHasBeenScoredToTrue() { _hasBeenScored = true }
  
  let dir_left  = "left"                       // Used inside of the command to perpetuate motion:
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
  
  var score = 0
  
  var platforms: [String: Platform3] = [:]
  
  let PLAT_HEIGHT = 35.f
  
  let GRAV_DOWN = CGVector(dx: 0, dy: -20)
  
  var nextLine = 1                             // Used for positioning of next node, as well as name of node to keep track of in dict, and for collisions.
  
  lazy var baseSpawnPos: CGPoint = {
    let y = self.player.frame.maxY + self.player.size.halfHeight + 1
    return CGPoint(x: 0, y: y)
  }()
  
  var lastSpawnSide = "right"
  
  /// Because everything should be resolved next frame regardless, and it could complicate loop logic for landing.
  var flag_skipThisFrameContact = false
  
  var flag_shouldLandOnPlatform = false
  var flagdata_platformTolandOn: Platform3?
  
  /// Need to set this in didBegin() once player has been determined to be dead from  a vertical landing (or other vertical collision) to ensure that player does not die from a normal landing
  var flag_throwDSPFlag = false // TODO: I really need to rename this =/
  var flagdata_dspPlatform: Platform3?
  
  
};

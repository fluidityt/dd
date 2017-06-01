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
    let pb = SKPhysicsBody(
      rectangleOf: size,
      category: UInt32(1),
      collision: UInt32(2),
      contact: UInt32(2)
    )
    pb.allowsRotation = false
    pb.usesPreciseCollisionDetection = true
    physicsBody = pb
  }
  
  func jump() {
    resetPB()
    position.y += 2 // Clear enough to not trigger contact.
    if let platform = platform {
      platform.isCarryingPlayer = false
    }
    platform = nil
    guard let pb = physicsBody else { fatalError() }
    pb.affectedByGravity = true
    pb.applyImpulse(vec_jump)
  }

  func land(on platform: Platform3) {
    self.platform = platform
    platform.isCarryingPlayer = true
    resetPB()
    guard let pb = physicsBody else { fatalError() }
    pb.affectedByGravity = false
    position.y = platform.frame.point.topMiddle.y + size.halfHeight
  }
  
  func die() {
    debug("DEAD")
    print("dead")
    resetPB()
    isAlive = false
    guard let scene = scene else { fatalError() }
    guard let view = scene.view else { fatalError() }
    scene.removeAllChildren()
    view.presentScene(Winby3(size: scene.size))
  }
};

//
// PLATFORM
//
//let label = SKLabelNode(text: "hi", fontColor: .white, fontSize: 32)

class Platform3: SKSpriteNode {
  
  let vec_speed: Int
  
  init(color: SKColor, size: CGSize) {
    self.vec_speed = 60 + randy(60)
    super.init(texture: nil, color: color, size: size)
    
    self.size.width = 50.f + randy(100)
  }

  // Use SKAction as this command?
  var command: Optional<()->()>
  
  var going = "left"
  
  var isCarryingPlayer = false
  
  // The only good case for a setter:
  private var _hasBeenScored = false
  func hasBeenScored() -> Bool { return _hasBeenScored  }
  func setHasBeenScoredToTrue() { _hasBeenScored = true }
  
  let dir_left  = "left"                       // Used inside of the command to perpetuate motion:
  let dir_right = "right"
  lazy var vec_left: CGVector  = { return CGVector(dx: -self.vec_speed, dy: 0) }()
  lazy var vec_right: CGVector = { return CGVector(dx: self.vec_speed, dy: 0) }()
  
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
  
  let COLOR1 = SKColor.black
  
  let COLOR2 = SKColor.gray
  
  let PLAT_RANDX = 100.f
  
  let PLAT_HEIGHT = 25.f                      // Make sure this isn't smaller than depression..
  
  let GRAV_DOWN = CGVector(dx: 0, dy: -20)
  
  var nextLine = 1                             // Used for positioning of next node, as well as name of node to keep track of in dict, and for collisions.
  
  lazy var baseSpawnPos: CGPoint = {
    let y = self.player.frame.maxY + self.player.size.halfHeight + 1
    return CGPoint(x: 0, y: y)
  }()
  
  var lastSpawnSide = "right"
  
  /// Because everything should be resolved next frame regardless, and it could complicate loop logic for landing.
  var flag_skipThisFrameContact = false
  
  var flag_shouldSpawnNewPlatform = false
  
  var flag_shouldLandOnPlatform = false
  var flagdata_platformTolandOn: Platform3?
  
  /// Need to set this in didBegin() once player has been determined to be dead from  a vertical landing (or other vertical collision) to ensure that player does not die from a normal landing
  var flag_throwDSPFlag = false // TODO: I really need to rename this =/
  var flagdata_dspPlatform: Platform3?
  
  
};

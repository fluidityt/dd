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
  
  let NUM_JUMPS = 10
  
  lazy var jumps: Int = self.NUM_JUMPS
  
  let vec_jump = CGVector(dx: 0, dy: 80)
  
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
    if jumps <= 0 { return }
    jumps -= 1
    
    resetPB()
    if let p = platform {
      position.y = p.frame.point.topLeft.y + size.halfHeight
    }
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
    jumps = NUM_JUMPS
    
    self.platform = platform
    platform.isCarryingPlayer = true
    resetPB()
    guard let pb = physicsBody else { fatalError() }
    pb.affectedByGravity = false
    position.y = platform.frame.point.topMiddle.y + size.halfHeight
  }
  
  func die(from platform: Platform3) {
    debug("DEAD")
    print("dead")
    
    resetPB()
    isAlive = false
    
    // FIXME: This still isn't working:
//    position.y = platform.frame.point.topMiddle.y + size.halfHeight
    
    guard let scene = scene as? Winby3 else { fatalError("wtf is the scene?") }
    scene.flag_shouldGameOver = true
  }
};

//
// PLATFORM
//
//let label = SKLabelNode(text: "hi", fontColor: .white, fontSize: 32)

class Platform3: SKSpriteNode {

  // TODO: better initializer?
  init(color: SKColor, size: CGSize) {

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
  
  let wanderDistance = randy(75).f
  
  let dir_left  = "left"                       // Used inside of the command to perpetuate motion:
  let dir_right = "right"
  
  let vec_speed = 60 + randy(60)
  lazy var vec_left: CGVector  = CGVector(dx: -self.vec_speed, dy: 0)
  lazy var vec_right: CGVector = CGVector(dx:  self.vec_speed, dy: 0)
  
  required init?(coder aDecoder: NSCoder) {    fatalError("init(coder:) has not been implemented")  }
};

final class Camera {
  
  private var scene: Winby3

  init(scene: Winby3) {
    self.scene = scene
  }
  
  func shouldUpdate() -> Bool {
  
  return false
  }
  
  func moveDown() {
  
  
  }
  
  func update() {
  
  }
  
};

//
// MARK: - WINBY 3:
//
let label = SKLabelNode(fontNamed: "Chalkduster")
func debug(_ text: String) { label.text = text }

class Winby3: SKScene, SKPhysicsContactDelegate {
  
  let player = Player3(color: .yellow, size: CGSize(width: 50, height: 50))
  
  lazy var cam: Camera = Camera(scene: self)
  
  var platforms: [String: Platform3] = [:]
  
  var score = 0
  
  var nextLine = 1                             // Used for positioning of next node, as well as name of node to keep track of in dict, and for collisions.
  
  let COLOR1 = SKColor.black
  
  let COLOR2 = SKColor.gray
  
  let PLAT_HEIGHT = 25.f                      // Make sure this isn't smaller than depression..
  
  let GRAV_DOWN = CGVector(dx: 0, dy: -20)
  
  lazy var baseSpawnPos: CGPoint = CGPoint(x:0, y: self.player.frame.maxY + self.player.size.halfHeight + 1)
  
  var lastSpawnSide = "right"
  
  // MARK: - Flags:
  /// Because everything should be resolved next frame regardless, and it could complicate loop logic for landing.
  var flag_skipThisFrameContact = false
  
  var flag_shouldSpawnNewPlatform = false
  
  var flag_shouldGameOver = false // This flag doesn't get reset anywhere (except on new instance)
  
  var flag_skipAllContacts = false // useful for animations and menus
  
  var flag_shouldLandOnPlatform = false
  var flagdata_platformTolandOn: Platform3?
  
  /// Need to set this in didBegin() once player has been determined to be dead from  a vertical landing (or other vertical collision) to ensure that player does not die from a normal landing
  var flag_doSecondKillCheck = false // TODO: I really need to rename this =/
  var flagdata_dspPlatform: Platform3?
  
};

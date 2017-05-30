//
//  Winby2.swift

import SpriteKit
import GameplayKit

final class Platform: SKSpriteNode {
  var positionLastFrame = CGPoint.zero
  var deltaX: CGFloat { return self.position.x - self.positionLastFrame.x }
  var id: Int { return Int(name!)! }
  
  func clearBitMask() {
    assert(physicsBody != nil)
    physicsBody!.categoryBitMask = UInt32(0)
  }

  func setBitMask() {
    func clearBitMask() {
      assert(physicsBody != nil)
      physicsBody!.categoryBitMask = UInt32(2)
    }
  }
  
  // Call in DFU():
  func finishUpdate() {
    positionLastFrame = self.position
  }
};


final class Playa: SKSpriteNode {
  
  lazy var stateMachine: GKStateMachine = { GKStateMachine(states: [OnPlatform(self), Ascending(self), DoubleAscending(self), Descending(self), Dying(self), Dead(self)]) } ()
  var      currentState: GKState? { return stateMachine.currentState }

  var platform: Platform?

  var jumps = 2
  
  /// This should only be called once, in update:
  func keepOnPlatform() {
    guard let platform = platform else { return }
    position.x += platform.deltaX
  }
  
  func enter(_ stateClass: AnyClass) {
      stateMachine.enter(stateClass)
  }
  
  func jump(vector: CGVector) {

    if jumps <= 0 { return }
    
    if currentState is DoubleAscending { return }
    else if currentState is Ascending { enter(DoubleAscending.self) }
    else { enter(Ascending.self) }
  }
};


/// Design: have the world react to what the player does, or what the player collides with.
class PlayerState: GKState {
  var scene: WinbyScene2 { return player.scene! as! WinbyScene2 }
  let player: Playa 
  init(_ player: Playa) { self.player = player }
  
  /// Because guards are annoying sometimes.
  func assertPlatformAndPB() {
    assert(player.platform != nil, "platform should be assigned in contact")
    assert(player.platform!.physicsBody != nil, "pb should be assigned from ascending")
  }
};


/// Platform must be updated via contact (or other) handler prior to this being entered.
final class OnPlatform: PlayerState {
  
  override func didEnter(from previousState: GKState?) {
    assert(previousState is Descending || previousState is DoubleDescending || previousState == nil)
    guard let platform = player.platform else { fatalError("must have platform") }
    
    player.jumps = 2
    //platform.clearBitMask()
    
    // Handle scoring and spawning next spawn:
    if scene.shouldSpawnNewPlatform() {
      scene.increaseHighscore()
      scene.spawnPlatform(at: scene.getPositionToSpawnAt())
    }
  }
  
  override func update(deltaTime seconds: TimeInterval) {
    // player.keepOnPlatform()
  }
};


class Ascending: PlayerState {
  // Should be protected:
  
  var positionToCompare = CGPoint()
  var nextState: AnyClass = Descending.self
  
  func leavePlatform(player: Playa) {
    // FIXME: assertPlatformAndPB()
    player.position.y += 10                                    // Make sure we don't contat
    player.jumps -= 1
    // player.platform!.physicsBody!.categoryBitMask = UInt32(2) // FIXME: B etter masks.
    // player.platform = nil
  }
  
  func applyImpulse(player: Playa) {
    player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
    player.physicsBody!.applyImpulse(scene.JUMP_POWER)
    // Sound effect!
  }
  
  // Should only be called during update
  override func didEnter(from previousState: GKState?) {
    // FIXME: assertPlatformAndPB()
    // FIXME: assert(previousState is OnPlatform)
    
    scene.setGravityAscend()
  
    leavePlatform(player: player)
    applyImpulse(player: player)
    
    positionToCompare = player.position
  }
  
  override func update(deltaTime seconds: TimeInterval) {

    // Check for descension so can change state:
    if player.position.y < positionToCompare.y {
      player.stateMachine.enter(nextState)
    } else { positionToCompare = player.position }
  }
};


final class DoubleAscending: Ascending {
  override func didEnter(from previousState: GKState?) {
    assert(previousState is Ascending)
    nextState = DoubleDescending.self
    
    player.jumps -= 1
    applyImpulse(player: player)
    positionToCompare = player.position
  }
};


final class Descending: PlayerState {
  
  override func didEnter(from previousState: GKState?) {
    assert(previousState is Ascending)
 //   scene.setGravityDescend()
  }
};


final class DoubleDescending: PlayerState {
  override func didEnter(from previousState: GKState?) {
    assert(previousState is DoubleAscending)
    // scene.setGravityDescend()
  }
};


final class Dying: PlayerState {
  // Run animations
};


final class Dead: PlayerState {
  // End game and transition to replay scene:
  override func didEnter(from previousState: GKState?) {
    scene.view?.presentScene(SKScene()) // FIXME: lol
  }
};


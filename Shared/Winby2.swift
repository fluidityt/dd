//
//  Winby2.swift

import SpriteKit
import GameplayKit

let gPlaya = Playa()

final class Platform: SKSpriteNode {
  var positionLastFrame = CGPoint.zero
  var deltaX: CGFloat { return self.position.x - self.positionLastFrame.x }
  
  // Call in DFU():
  func finishUpdate() {
    positionLastFrame = self.position
  }
};


final class Playa: SKSpriteNode {
  
  lazy var stateMachine: GKStateMachine = { GKStateMachine(states: [OnPlatform(self), Ascending(self), Descending(self), Dying(self), Dead(self)]) } ()
  var currentState: GKState? { return stateMachine.currentState }

  var platform: Platform?

  var positionLastFrame = CGPoint.zero
  
  /// This should only be called once, in update:
  func keepOnPlatform() {
    guard let platform = platform else { return }
    position.x += platform.deltaX
  }
  
  // I'm hemming and hawing.
  func jump() {
    
    // if currentState == doubleJump { return }
    // else if currentState == jump { enter(doubleJump) }
    // else { enter(jump) }
    
    stateMachine.enter(Ascending.self)
  }
  
  
};


/// Design: have the world react to what the player does, or what the player collides with.
class PlayerState: GKState {
  let player: Playa
  let scene: WinbyScene
  init(_ player: Playa) {
    self.player = player
    self.scene = player.scene! as! WinbyScene
  }
  
  /// Because guards are annoying sometimes.
  func assertPlatformAndPB() {
    assert(player.platform != nil, "platform should be assigned in contact")
    assert(player.platform!.physicsBody != nil, "pb should be assigned from ascending")
  }
};


final class OnPlatform: PlayerState {
  
  override func didEnter(from previousState: GKState?) {
    assertPlatformAndPB()
    
    player.platform!.physicsBody!.categoryBitMask = UInt32(0) // FIXME: Better masks.
    
    if scene.shouldIncreaseHighscore() { scene.increaseHighscore() }
    if scene.shouldSpawnNewBlock()     { scene.spawnNewBlock(at: scene.getPositionToSpawnAt()) }
  }
  
  override func update(deltaTime seconds: TimeInterval) {
    // Platform will be updated via contact handler.
    player.keepOnPlatform()
  }
};


class Ascending: PlayerState {
  
  private var positionToCompare = CGPoint()
  
  private func playerLeavesPlatform() {
    player.position.y += 1                                    // Make sure we don't contat
    player.platform!.physicsBody!.categoryBitMask = UInt32(2) // FIXME: Better masks.
    player.platform = nil
  }
  
  private func playerAppliesImpulse() {
    player.physicsBody = SKPhysicsBody()
    player.physicsBody!.applyImpulse(CGVector())
    // Sound effect!
  }
  
  // Should only be called during update
  override func didEnter(from previousState: GKState?) {
    assertPlatformAndPB()
    
    scene.setGravityAscend()
    
    playerLeavesPlatform()
    playerAppliesImpulse()
    
    positionToCompare = player.position
  }
  
  override func update(deltaTime seconds: TimeInterval) {

    // Check for descension so can change state:
    if player.position.y < positionToCompare.y {
      player.stateMachine.enter(Descending.self)
    } else { positionToCompare = player.position }
  }
};


final class DoubleAscending: Ascending {
  override func didEnter(from previousState: GKState?) {
    assert(previousState is Ascending)
    
    
    
  }
};


final class Descending: PlayerState {
  
  override func didEnter(from previousState: GKState?) {
    scene.setGravityDescend()
  }
  
  override func update(deltaTime seconds: TimeInterval) {
  // Contact happens AFTER this will be checked... and the next state will be called from
  // contact.
  }
};


final class Dying: PlayerState {
  // Run animations
};


final class Dead: PlayerState {
  // End game and transition to replay scene:
};

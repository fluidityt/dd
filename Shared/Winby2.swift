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
};


/// Design: have the world react to what the player does, or what the player collides with.
class PlayerState: GKState {
  let player: Playa
  let scene: WinbyScene
  init(_ player: Playa) {
    self.player = player
    self.scene = player.scene! as! WinbyScene
  }
};


final class OnPlatform: PlayerState {
  override func didEnter(from previousState: GKState?) {
    if scene.shouldIncreaseHighscore() { scene.increaseHighscore() }
    if scene.shouldSpawnNewBlock()     { scene.spawnNewBlock(at: scene.getPositionToSpawnAt()) }
  }
  
  override func update(deltaTime seconds: TimeInterval) {
    // Platform will be updated via contact handler.
    player.keepOnPlatform()
  }
};


final class Ascending: PlayerState {
  
  override func didEnter(from previousState: GKState?) {
    player.positionLastFrame = player.position // Technically, this can only happen on jump, which is during update.
    scene.setGravityAscend()
  }
  
  override func update(deltaTime seconds: TimeInterval) {
  
    if player.position.y < player.positionLastFrame.y {
      player.stateMachine.enter(Descending.self)
    }
    else { player.positionLastFrame = player.position }
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

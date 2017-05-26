//
//  Winby2.swift

import SpriteKit
import GameplayKit

let gPlaya = Playa()

final class Playa: SKSpriteNode {
  lazy var stateMachine: GKStateMachine = { GKStateMachine(states: [OnPlatform(self), Ascending(self), Descending(self), Dying(self), Dead(self)]) } ()
  var currentState: GKState? { return stateMachine.currentState }

  func z() {
    
  }
  
}

class PlayerState: GKState {
  let player: Playa
  init(_ player: Playa) { self.player = player }
}

final class OnPlatform: PlayerState {
  // Something:
}

final class Ascending: PlayerState {
  // Set gravity lower:
}

final class Descending: PlayerState {
  // Set gravity higher:
}

final class Dying: PlayerState {
  // Run animations
}

final class Dead: PlayerState {
  // End game and transition to replay scene:
}

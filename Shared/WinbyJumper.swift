//
//  file3.swift
//  ffs2222

import SpriteKit

class Sprite: SKSpriteNode {
  
}

class PlayerJumper {
  
  func somefunc() {
    let colorSequence = SKKeyframeSequence(keyframeValues: [SKColor.green,
                                                            SKColor.yellow,
                                                            SKColor.red,
                                                            SKColor.blue],
                                           times: [0, 0.25, 0.5, 1])
  }
  
  
  let scene:  GameScene
  let player: Sprite
  
  var startingY: CGFloat { return self.scene.frame.minY             }
  var maxHeight: CGFloat { return startingY + scene.size.height / 4 }
  
  let timeTomaxHeight = TimeInterval(0.5 )
  let delayBeforeFall = TimeInterval(0.25)
  let timeToMinHeight = TimeInterval(0.30)
  
  init(player: Sprite, scene: GameScene) { self.player = player; self.scene = scene }
  
}

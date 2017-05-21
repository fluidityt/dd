//
//  Sprites.swift
//  ffs2222

import SpriteKit

// MARK: - TouchPad:
final class TouchPad: SKSpriteNode {
  
  private var playerInstance: Player
  
  init(player: Player, scene: SKScene) {
    playerInstance = player
    
    let color: SKColor
    let size: CGSize
    
    if g.mode.full.value {
      color = .clear
      size = g.gameScene.size
      assert(g.gameScene.size.height > 10) // Make sure we have a normal size.
    } else {
      color = .black
      size = CGSize(width: scene.size.width, height: (scene.size.halfHeight))
    }
    
    super.init(texture: nil, color: color, size: size)
    zPosition += 1
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
    #if os(iOS)
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    for t in touches {
  
      let dx = (t.location(in: self).x - t.previousLocation(in: self).x)
      let dy = (t.location(in: self).y - t.previousLocation(in: self).y)
  
      playerInstance.position.x += dx
      playerInstance.position.y += dy
    }
  }
  #endif
};

// MARK: - Player:
final class Player: SKSpriteNode {
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
    // isUserInteractionEnabled = true
  }
  
  func toggleColor() {
    // if color == .green  { color = .orange }
    // if color == .yellow { color = .green  }
  }
  
  func touch() {
    
  }
  #if os(iOS)
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  // position = touches.first!.location(in: self.scene!)
  touch()
  }
  #elseif os(OSX)
  override func mouseDown(with event: NSEvent) { touch()  }
  #endif
  required init?(coder aDecoder: NSCoder) { fatalError() }
};




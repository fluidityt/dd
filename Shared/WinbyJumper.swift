//
//  file3.swift
//  ffs2222

import SpriteKit

class Sprite: SKSpriteNode {
  var category = ""
  var contact = ""
  
  func touch() {
    
  }
  #if os(iOS)
  
  #elseif os(OSX)
  override func mouseDown(with event: NSEvent) {
    position = event.location(in: self.scene!)
  }
  override func mouseDragged(with event: NSEvent) {
  
    position = event.location(in: self.scene!)
  }
  #endif
};


class JumpScene: SKScene {
  
  typealias CollidedNode = (bodyA: SKSpriteNode, bodyB: SKSpriteNode)
  
  
  // Proppy:
  var categories: [String: Set<Sprite>] = ["": Set<Sprite>()]
  
  var playerIsOnPlatform = true
  
  lazy var player: Sprite = {
    let player = Sprite(color: .yellow, size: CGSize(width: 30, height: 30))
    player.isUserInteractionEnabled = true
    player.name = "player"
    player.category = "player"
    player.contact  = "enemy"
    self.addSpriteToCategory(player)
    return player
  }()
  
  lazy var playerJumper: Jump = {
    Jump(player: self.player, scene: self)
  }()
  
  lazy var enemy: Sprite = {
    let enemy = Sprite(color: .black, size: CGSize(width: 30, height: 30))
    enemy.isUserInteractionEnabled = true
    enemy.name = "enemy"
    enemy.category = "enemy"
    enemy.contact  = "player"
    self.addSpriteToCategory(enemy)
    return enemy
  }()
  
  lazy var missile: Sprite = {
    let missile = Sprite(color: .black, size: CGSize(width: 30, height: 30))
    missile.isUserInteractionEnabled = true
    missile.name = "missile"
    missile.category = "missile"
    missile.contact  = "player"
    self.addSpriteToCategory(missile)
    return missile
  }()
}

// MARK: - Physics:
extension JumpScene {
  
  func addSpriteToCategory(_ sprite: Sprite) {
    if categories[sprite.category] == nil { categories[sprite.category] = [sprite]      }
    else                                  { categories[sprite.category]!.insert(sprite) }
  }
  
  func removeSpriteFromCategory(_ sprite: Sprite) {
    if categories[sprite.category] == nil { fatalError("set not found") }
    else { categories[sprite.category]!.remove(sprite) }
  }
  
  func checkCollisions() -> [CollidedNode] {
    
    var collided: [CollidedNode] = []
    
    func canAddToCollided(sprite0: Sprite, sprite1: Sprite) -> Bool {
      
      for i in collided {
        if i.0 == sprite1 && i.1 == sprite0 { return false }
      }
      
      // Base case:
      return true
    }
    
    var checkedKeys: [String] = []
    
    for key in categories.keys {
      
      for sprite in categories[key]! {
        
        for secondKey in categories.keys {
          
          if secondKey == key { continue }
          if checkedKeys.contains(secondKey) { continue }
          
          if sprite.contact == secondKey {
            
            for secondSprite in categories[secondKey]! {
              
              if sprite.frame.intersects(secondSprite.frame) {
                
                if canAddToCollided(sprite0: sprite, sprite1: secondSprite) {
                  collided.append((sprite, secondSprite))
                }
              }
            }
          }
        }
      }
      
      checkedKeys.append(key)
    }
    
    // Check if any of our collided have collided (3+ collided):
    
    /*
     for l in collided {
     print(l.0)
     print(l.1)
     print("")
     }*/
    
    return collided
  }
}

// MARK: - Game loop:
extension JumpScene {

  override func didMove(to view: SKView) {
    addChild(player)
    addChild(enemy)
    addChild(missile)
  }
  
  // Game loop:
  override func didEvaluateActions() {
    let collidedNodes = checkCollisions()
    
    guard collidedNodes.count > 0 else { return }
    
      
    for contact in collidedNodes {
      print("hiii")
      
      
      
    }
  }
  
  override func didSimulatePhysics() {
    if player.position.y <= playerJumper.startingY || playerIsOnPlatform == true {
      
    }
  }
};

class Jump {
  
  func start() {
    
  }
  
  func advance() {
    
  }
  
  func end() {
    
  }
  
  func somefunc() {
    let colorSequence = SKKeyframeSequence(keyframeValues: [SKColor.green,
                                                            SKColor.yellow,
                                                            SKColor.red,
                                                            SKColor.blue],
                                           times: [0, 0.25, 0.5, 1])
  }
  
  
  let scene:  JumpScene
  let player: Sprite
  
  var startingY: CGFloat { return self.scene.frame.minY             }
  var maxHeight: CGFloat { return startingY + scene.size.height / 4 }
  
  let timeTomaxHeight = TimeInterval(0.5 )
  let delayBeforeFall = TimeInterval(0.25)
  let timeToMinHeight = TimeInterval(0.30)
  
  init(player: Sprite, scene: JumpScene) { self.player = player; self.scene = scene }
 
  func update() {
    
  }
}

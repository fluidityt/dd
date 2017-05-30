//
//  Winby3Test.swift

import SpriteKit


// MARK: - PHYSICS:
extension Winby3 {
  
  func didBegin(_ contact: SKPhysicsContact) {
    func findPlayer(from contact: SKPhysicsContact) -> Player3? {
      if contact.bodyA.node is Player3 { return contact.bodyA.node as! Player3 }
      else if contact.bodyB.node is Player3 { return contact.bodyB.node as! Player3 }
      else { return nil }
    }
    
    func findPlatform(from contact: SKPhysicsContact) -> Platform3? {
      if contact.bodyA.node is Platform3 { return contact.bodyA.node as! Platform3 }
      else if contact.bodyB.node is Platform3 { return contact.bodyB.node as! Platform3 }
      else { return nil }
    }
    
    guard let player = findPlayer(from: contact) else     { return }
    guard let platform = findPlatform(from: contact) else { return }
    
    player.platform = platform
    player.physicsBody?.affectedByGravity = false
    player.physicsBody?.velocity = platform.physicsBody!.velocity

    print("contact platform with player")
  }
  
}


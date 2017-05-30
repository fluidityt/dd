//
//  Winby3Test.swift

import SpriteKit


// MARK: - PHYSICS:
extension Winby3 {
  
  func didBegin(_ contact: SKPhysicsContact) {
    if skipThisFrameContact { return }
    
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
    
    typealias IsWinbyDead = Bool
    func shouldKillWinby(player: Player3, platform: Platform3) -> IsWinbyDead? {
      
      let minimumFooting = 5.f
      let maxDepression = 5.f
      
      do { // player left
        let playerPoint   = player.frame.point.middleRight.x + frame.halfWidth
        let platformPoint = platform.frame.point.middleLeft.x + frame.halfWidth
        if playerPoint < (platformPoint + minimumFooting) { return true }
      }
      do { // player right
        let playerPoint = player.frame.point.middleLeft.x + frame.halfWidth
        let platformPoint = platform.frame.point.middleRight.x + frame.halfWidth
        if playerPoint > (platformPoint - minimumFooting) { return true }
      }
      do { // player bottom
        let playerPoint = player.frame.point.bottomMiddle.y + frame.halfHeight
        let platformPoint = platform.frame.point.topMiddle.y + frame.halfHeight
        if playerPoint < platformPoint - maxDepression {
          dsfPlatform = platform
          return nil
        } // more checking
      }
      
      // Base case:
      debug("not dead")
      skipThisFrameContact = true
      return false
    }
    
    //    func putPlayerOnPlatform(player: Player3, platform: Platform3) {
    //      player.platform = platform
    //      player.physicsBody?.affectedByGravity = false
    //      player.physicsBody?.velocity = platform.physicsBody!.velocity
    //    }
    
    guard let player   = findPlayer  (from: contact) else { return }
    guard let platform = findPlatform(from: contact) else { return }
    print("contact platform with player")
    
    if let result = shouldKillWinby(player: player, platform: platform) {
      if result.isTrue {
        print("WINBY IS DEAD")
        skipThisFrameContact = true
        debug("DEAD")
      }
    } else { // more checking required
     throwDSFFlag = true
    }
    
  }
  
}


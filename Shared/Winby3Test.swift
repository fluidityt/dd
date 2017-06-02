//
//  Winby3Test.swift

import SpriteKit


// MARK: - PHYSICS:
extension Winby3 {
  
  private typealias IsWinbyDead = Bool
  
  private func findPlayer(from contact: SKPhysicsContact) -> Player3? {
    if contact.bodyA.node is Player3 { return contact.bodyA.node as! Player3 }
    else if contact.bodyB.node is Player3 { return contact.bodyB.node as! Player3 }
    else { return nil }
  }
  
  private func findPlatform(from contact: SKPhysicsContact) -> Platform3? {
    if contact.bodyA.node is Platform3 { return contact.bodyA.node as! Platform3 }
    else if contact.bodyB.node is Platform3 { return contact.bodyB.node as! Platform3 }
    else { return nil }
  }
  
  private func shouldKillWinby(player: Player3, platform: Platform3) -> IsWinbyDead? {
    
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
        flagdata_dspPlatform = platform
        print("1", playerPoint)
        // More checking signal--will trigger flag:
        return nil
      }
    }
    
    // Base case (player is alive and on platform):
    debug("not dead | \(score)")
    
    flag_shouldLandOnPlatform = true
    flagdata_platformTolandOn = platform
    
    flag_skipThisFrameContact = true  // This is probably bugged? But would resolve next frame 99.9%
    return false
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    
    if flag_skipThisFrameContact { return }
    
    guard let player   = findPlayer  (from: contact) else { return }
    guard let platform = findPlatform(from: contact) else { return }
    print("contact platform with player")
    
    guard let result = shouldKillWinby(player: player, platform: platform) else { // more checking required
      flag_doSecondKillCheck = true
      return
    }
    
    if result.isTrue {
      print("WINBY IS DEAD")
      debug("DEAD")
      player.die(from: platform)
      flag_skipThisFrameContact = true
    }
  }
}


//
//  Winby3Funcs.swift
//  dd

import SpriteKit

extension Winby3 {
  
  func spawnTestPlatform() {
    platformCount += 1
    // TODO: Random 1-2
    nextLine += 1
    // TODO: random size
    let platform = Platform3(color: .black, size: CGSize(width: 200, height: PLAT_HEIGHT))
    
    let pb = SKPhysicsBody(rectangleOf: platform.size,
                                         category: UInt32(2),
                                         collision: UInt32(1) ,
                                         contact: UInt32(1))
    pb.allowsRotation = false
    pb.affectedByGravity = false
    platform.physicsBody = pb
    // platform.constraints = [SKConstraint.zRotation(SKRange(constantValue: 0))]
    platform.name = String(platformCount)
    platforms[String(Int(platform.name!)!)] = platform
    /*
      var startX = CGFloat(0)
      if lastSpawnSide == "right" {
       startX = frame.minX - platform.size.halfWidth
       } else { startX = frame.maxX + platform.size.halfWidth }
      
      let startY = baseSpawnPos.y * nextLine.f
      platform.position = CGPoint(x: startX, y: startY)
     */
    
    platform.position = player.position
    platform.position.x += 400
    platform.position.y += 75
    platform.constraints = [SKConstraint.positionY(SKRange(constantValue: platform.position.y))]
    //platform.yVal = platform.position.y
    
    let command: ()->() = {

      if platform.position.x > self.frame.maxX + platform.size.halfWidth {
        platform.going = platform.dir_left
      }
      else if platform.position.x < self.frame.minX - platform.size.halfWidth {
        platform.going = platform.dir_right
      }
      
      if      platform.going == platform.dir_right { pb.velocity = platform.vec_right }
      else if platform.going == platform.dir_left  { pb.velocity = platform.vec_left  }
      
    }
    commands.append(command)
    
    addChild(platform)
  }
  
  func spawnPlatform() {
    platformCount += 1
    // TODO: Random 1-2
    nextLine += 1
    // TODO: random size
    let platform = Platform3(color: .black, size: CGSize(width: 200, height: PLAT_HEIGHT))
    platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size,
                                         category: UInt32(2),
                                         collision: UInt32(4) | UInt32(1) ,
                                         contact: UInt32(1))
    
    platform.name = String(platformCount)
    platforms[String(Int(platform.name!)!)] = platform
    
    var startX = CGFloat(0)
    /*if lastSpawnSide == "right" {
     startX = frame.minX - platform.size.halfWidth
     } else { startX = frame.maxX + platform.size.halfWidth }*/
    
    let startY = baseSpawnPos.y * nextLine.f
    
    // platform.position = CGPoint(x: startX, y: startY)
    
    addChild(platform)
  }
  
  // MARK: - Init:
  private func initSelf() {
    let GRAV_DOWN = CGVector(dx: 0, dy: -5)
    
    baseSpawnPos.y = frame.minY + PLAT_HEIGHT/2
    physicsWorld.contactDelegate = self
    anchorPoint = CGPoint.middle
    physicsWorld.gravity = GRAV_DOWN
    //physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    //physicsBody!.collisionBitMask = UInt32(4)
    //physicsBody?.contactTestBitMask = UInt32(4)
    
    func initPlatform() {
      let platform = Platform3(color: .black, size: CGSize(width: 200, height: PLAT_HEIGHT))
      platform.physicsBody = SKPhysicsBody(
        rectangleOf: platform.size,
        category   : UInt32(2),
        collision  : UInt32(4),
        contact    : UInt32(1)
      )
      platform.name = String(platformCount)
      platform.position.y = baseSpawnPos.y
      platforms["0"] = platform
      addChild(platform)
    }
    
     func initPlayer() {
      player.resetPB()
      player.position.y = platforms["0"]!.frame.maxY + player.size.halfHeight
    //  player.constraints = [SKConstraint.zRotation(SKRange(constantValue: 0))]
      addChild(player)
    }
    
    initPlatform()
    initPlayer()
  }
  
  override func didMove(to view: SKView) {
    initSelf()
    spawnTestPlatform()
  }
  
  override func mouseDown(with event: NSEvent) {
    player.jump()
  }
  
  override func update(_ currentTime: TimeInterval) {
    for command in commands {
      command()
    }
  }

  override func didFinishUpdate() {
    player.keepInBounds()
/*    for platform in platforms.values { if platform == platforms["0"] { continue }
      platform.keepAtYVal()
    }*/
  }
}

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
    
    // Used in update:
    let command: ()->() = {
      if player.platform == self.platforms["1"] {
       player.physicsBody?.velocity = player.platform!.physicsBody!.velocity
      }
    }
    
    commands.append(command)
    print("contact platform with player")
  }
  
}

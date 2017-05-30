//
//  Winby3Funcs.swift
//  dd

import SpriteKit

extension Winby3 {
  
  func addPlatformToDict(_ platform: Platform3) {
    platforms[platform.name!] = platform // Did you add before giving name?
  }
  
  func spawnTestPlatform() {
    
    func getStartingPosition(for platform: Platform3) -> CGPoint {
      
      var startX = CGFloat(0)
      if lastSpawnSide == "right" {
        startX = frame.minX - platform.size.halfWidth
      } else { startX = frame.maxX + platform.size.halfWidth  }
      
      let startY = baseSpawnPos.y - PLAT_HEIGHT + (PLAT_HEIGHT * nextLine.f)
      
      return CGPoint(x: startX, y: startY)
    }
    
    nextLine = 2
    
    // TODO: random size
    let platform = Platform3(color: .black, size: CGSize(width: 200, height: PLAT_HEIGHT)); do {
      
      let pb = SKPhysicsBody(rectangleOf: platform.size,
                             affectedGravity: false,
                             category: UInt32(2),
                             collision: UInt32(1) ,
                             contact: UInt32(1))
      pb.allowsRotation = false
      
      platform.physicsBody = pb
      platform.name = String(nextLine)
      platform.position = getStartingPosition(for: platform)
      platform.constraints = [SKConstraint.positionY(SKRange(constantValue: platform.position.y))]
      platform.command = {
        // TODO: put this as a property of platform (list of commands?)
        if platform.position.x > self.frame.maxX + platform.size.halfWidth {
          platform.going = platform.dir_left
        }
        else if platform.position.x < self.frame.minX - platform.size.halfWidth {
          platform.going = platform.dir_right
        }
        
        if      platform.going == platform.dir_right { pb.velocity = platform.vec_right }
        else if platform.going == platform.dir_left  { pb.velocity = platform.vec_left  }
      }
    }
    addPlatformToDict(platform)
    addChild(platform)
  }
  
  // MARK: - Init:
  private func initSelf() {
    
    func initScene() {
      physicsWorld.contactDelegate = self
      anchorPoint = CGPoint.middle
      physicsWorld.gravity = GRAV_DOWN
    }
    
    func initPlatform() {
      let platform = Platform3(color: .black, size: CGSize(width: 200, height: PLAT_HEIGHT))
      platform.physicsBody = SKPhysicsBody(
        rectangleOf: platform.size,
        affectedGravity: false,
        category   : UInt32(2),
        collision  : UInt32(4),
        contact    : UInt32(1)
      )
      platform.name = "0"
      platform.position.y = frame.minY + platform.size.halfHeight
      platforms["0"] = platform
      addChild(platform)
    }
    
     func initPlayer() {
      player.resetPB()
      player.position.y = platforms["0"]!.frame.maxY + player.size.halfHeight
      addChild(player)
    }
    
    func initLabel() {
      label.text = "adadfasdfasdfsadfas"
      label.position.y = frame.maxY - label.frame.halfHeight
      addChild(label)
    }
    
    initScene()
    initPlatform()
    initPlayer()
    initLabel()
  }
  
  override func didMove(to view: SKView) {
    initSelf()
    spawnTestPlatform()
  }
  
  override func mouseDown(with event: NSEvent) {
    player.jump()
  }

  override func keyDown(with event: NSEvent) {
    player.position = CGPoint.zero
    
  }
  override func rightMouseDown(with event: NSEvent) {
  }
  
  override func update(_ currentTime: TimeInterval) {
    for platform in platforms.values {
      if let cmd = platform.command { cmd() }
    }
  }

  override func didFinishUpdate() {
    player.keepInBounds()
    skipThisFrameContact = false // check in dbc
    
//     debug("\(player.physicsBody!.velocity.dx)")
/*    for platform in platforms.values { if platform == platforms["0"] { continue }
      platform.keepAtYVal()
    }*/
  }
}

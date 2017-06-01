//
//  Winby3Funcs.swift
//  dd

import SpriteKit

extension Winby3 {
  
  func increaseScore() {
    score += 1
    debug("\(score)")
  }
  
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
                             contact: UInt32(1)); do {
                              pb.allowsRotation = false
                              pb.mass = 45
                              pb.usesPreciseCollisionDetection = true
                              pb.restitution = 0
      }
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
        //collision  : UInt32(1),
        contact    : UInt32(1),
        restitution: 0
      )
      //      platform.physicsBody?.usesPreciseCollisionDetection = true
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
  
  override func update(_ currentTime: TimeInterval) {
    for platform in platforms.values {       // Keep platform at constant speed.
      if let cmd = platform.command { cmd() }
    }
    
    if let platform = player.platform {     // Keep player on platform.
     player.physicsBody!.velocity = platform.physicsBody!.velocity
    }
  }

  override func didSimulatePhysics() {
    
    // Check 1: To live or die
    if flag_throwDSPFlag {
      
      func maybeKillPlayer() -> Bool {          // This only works with dfu code to reset from didBegin()
        guard let platform = flagdata_dspPlatform else { fatalError("wtf how.. should be in dbc") }
        
        let maxDepression = 5.f
        let playerPoint = player.frame.point.bottomMiddle.y + frame.halfHeight
        let platformPoint = platform.frame.point.topMiddle.y + frame.halfHeight
        
        if playerPoint < platformPoint - maxDepression {
          return true
        } else {
          player.land(on: platform)
          return false                           // Player lives and may get to score.
        }
      }
      
      if maybeKillPlayer() { player.die() }

    }
    
    // Check 2: Landing:
    if flag_shouldLandOnPlatform {
      guard let platform = flagdata_platformTolandOn else { fatalError("wtf lol") }
      player.land(on: platform)
    }
    
    // Check 3: Scoring
    if player.isDead { return } else {                 // This may mess up death animations later on...
      
      //player.land(on: platform)
      
      
      guard let platform = player.platform else { return } // Player is jumping / falling.
      
      if platform.hasBeenScored().isFalse {
        platform.setHasBeenScoredToTrue()
        increaseScore()
      }
      
    }
  }
  
  override func didFinishUpdate() {
  
    func testingAtFinish() {
//    debug("\(player.physicsBody!.affectedByGravity)")
    }
    
    func resetFlags() {
      flag_throwDSPFlag = false
      flag_shouldLandOnPlatform = false
      flag_skipThisFrameContact = false
      flagdata_dspPlatform = nil
      flagdata_platformTolandOn = nil
    }
    
    func keepInBounds(player p: Player3) {
      let resetVelocity: ()->() = {  p.physicsBody!.velocity = CGVector.zero }
      let scene = self
      let offsetY = p.size.halfHeight, offsetX = p.size.halfWidth
      
      if p.position.y < scene.frame.minY + offsetY {
        p.position.y = scene.frame.minY + offsetY
        resetVelocity()
      } else if p.position.y > scene.frame.maxY - offsetY {
        p.position.y = scene.frame.maxY - offsetY
        resetVelocity()
      } else if p.position.x < scene.frame.minX + offsetX {
        p.position.x = scene.frame.minX + offsetX
        resetVelocity()
      } else if p.position.x > scene.frame.maxX - offsetX {
        p.position.x = scene.frame.maxX - offsetX
        resetVelocity()
      }
    }
  
    resetFlags()
    keepInBounds(player: player)
  
    testingAtFinish()
  }
}

//
//  Winby3Funcs.swift
//  dd

import SpriteKit

extension Winby3 {
  
  func pushTest() {
    for node in children {
      if node is SKLabelNode { continue }
      node.position.y -= 5
      if node is Platform3 { node.constraints = [SKConstraint.positionY(SKRange(constantValue: node.position.y))] }
    }
    
    if let platform = player.platform {
      platform.resetPlayerPositon()
      debug("\(Int(player.position.y))")
    }
  }
  
  func spawnTestPlatform() {

    func addPlatformToDict(_ platform: Platform3) {
      guard let name = platform.name else { fatalError("must have name") }
      platforms[name] = platform            // Did you add before giving name?
    }
    
    func getStartingPosition(for platform: Platform3) -> CGPoint {
      
      var startX = CGFloat(0)
      if lastSpawnSide == "right" {
        startX = frame.minX - platform.size.halfWidth - platform.wanderDistance
        lastSpawnSide = "left"
      } else {
        startX = frame.maxX + platform.size.halfWidth + platform.wanderDistance
        lastSpawnSide = "right"
      }
      
      let startY = baseSpawnPos.y - PLAT_HEIGHT + (PLAT_HEIGHT * nextLine.f)
      
      return CGPoint(x: startX, y: startY)
    }
    
    let color: SKColor = {
      if randy(2) == 2 { return COLOR1 }
      else { return COLOR2 }
    }()
    
    // FIXME: random
    nextLine += randy(2)
    
    // FIXME: random size
    
    let platform = Platform3(color: color, size: CGSize(width: 200, height: PLAT_HEIGHT)); do {
      
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
        var pb: SKPhysicsBody { return platform.physicsBody! }
        
        let offset: CGFloat = {
          if platform.isCarryingPlayer { return platform.size.halfWidth/2 }
          else { return platform.size.halfWidth + platform.wanderDistance }
        }()
        
        // TODO: put this as a property of platform (list of commands?)
        if platform.position.x > self.frame.maxX + offset {
          platform.going = platform.dir_left
        }
        else if platform.position.x < self.frame.minX - offset {
          platform.going = platform.dir_right
        }
        
        if      platform.going == platform.dir_right { pb.velocity = platform.vec_right }
        else if platform.going == platform.dir_left  { pb.velocity = platform.vec_left  }
      }
    }
    addPlatformToDict(platform)
    addChild(platform)
  }
  
  override func didMove(to view: SKView) {
  
    func initSelf() {
      
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
    
    initSelf()
    spawnTestPlatform()
    spawnTestPlatform()
  }
  
  override func mouseDown(with event: NSEvent) {
    player.jump()
  }

  override func keyDown(with event: NSEvent) {
    player.position = CGPoint.zero
    
  }
  
  override func update(_ currentTime: TimeInterval) {

    func gameOver() {
      guard let view = view else { fatalError("wtf is the view??") }
      removeAllChildren()             // For label
      view.presentScene(Winby3(size: size))
    }
    
    if flag_shouldGameOver {
      gameOver()
      return
    }
    
    for platform in platforms.values {       // Keep platform at constant speed.
      if let cmd = platform.command { cmd() }
    }
    
    if let platform = player.platform {     // Keep player on platform.
      guard let playerPB   = player.physicsBody   else { fatalError() }
      guard let platformPB = platform.physicsBody else { fatalError() }
      playerPB.velocity = platformPB.velocity
    }
  }

  // func didBegin(_ contact:) { ... }

  override func didSimulatePhysics() {
    
    func increaseScore() {
      score += 1
    }
    
    func maybeKillPlayer() -> Bool {
      
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

    
    // Check 1: To live or die
    if flag_doSecondKillCheck {
      if maybeKillPlayer() {
        guard let platform = flagdata_dspPlatform else { fatalError("wtf how... should be in dbc" ) }
        player.die(from: platform)
      }
    }
    
    // Check 2: Landing:
    if flag_shouldLandOnPlatform {
      guard let platform = flagdata_platformTolandOn else { fatalError("wtf lol") }
      player.land(on: platform)
      
      // Check 3: Scoring
      guard player.isAlive else              { return }      // This may mess up death animations later on...
      guard platform == player.platform else { return }
      if platform.hasBeenScored()            { return }
      
      platform.setHasBeenScoredToTrue()
      increaseScore()
      flag_shouldSpawnNewPlatform = true
      
      // Check 4: Spawning:
      if flag_shouldSpawnNewPlatform { spawnTestPlatform() }
      
    }
  }

  override func didFinishUpdate() {
  
    func testingAtFinish() {
      // debug("\(player.landingCounter)")
    }
    
    if flag_shouldLandOnPlatform {
      pushTest()
    }
    
    func resetFlags() {
      flag_doSecondKillCheck = false
      flag_shouldLandOnPlatform = false
      flag_skipThisFrameContact = false
      flag_shouldSpawnNewPlatform = false
      
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

import SpriteKit

// http://stackoverflow.com/questions/31574049/moving-node-on-top-of-a-moving-platform
// http://www.learn-cocos2d.com/2013/08/physics-engine-platformer-terrible-idea/


// try a contacter, or just do a fake physics body? 

let categoryPlayer = UInt32(1)
let categoryEnemy  = UInt32(2)

class WinbyScene: SKScene {
  
  // var:
  var
  playerIsJumping = false,
  playerIsOnPlatform = false,
  platformPlayerIsOn: SKSpriteNode? = SKSpriteNode(),
  enemyHash = ["first": SKSpriteNode()],
  hitEnemy = SKSpriteNode(),
  
  playerY = CGFloat(0),
  enemyStarting  = CGPoint.zero,
  nextPos = CGPoint(x: 0, y: 0),
  
  highestPoint = 0,
  
  dead = false
  
  // let:
  let
  gravityUp   = CGVector(dx: 0, dy: -20),
  gravityDown = CGVector(dx: 0, dy: -30),
  jumpPower   = CGVector(dx: 0, dy: 55 ),
  playerMass  = CGFloat(1)
  
  // Player:
  let player: SKSpriteNode = {
    let player2 = SKSpriteNode(color: .green, size: CGSize(width: 30, height: 50))
    player2.physicsBody = WinbyScene.makePlayerPB(player: player2)
    return player2
  }()
  
  // MARK: - Funky:
   static func makePlayerPB(player: SKSpriteNode) -> SKPhysicsBody {
    
    let newPB = SKPhysicsBody(rectangleOf: player.size)
    newPB.restitution = 0
    newPB.categoryBitMask = categoryPlayer
    newPB.contactTestBitMask = categoryEnemy
    newPB.usesPreciseCollisionDetection = true
    // newPB.mass = playerMass
    return newPB
  }
  
  private func selfInit() {
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    physicsWorld.gravity = gravityUp
    physicsWorld.contactDelegate = self
  }
  
  func putNodeOnTopOfAnother(put node1: SKSpriteNode, on node2: SKSpriteNode) {
    node1.position.y = node2.position.y
    node1.position.y += node1.size.halfHeight
    node1.position.y += node2.size.halfHeight
  }

  func jump() {
    print("jumping")
    platformPlayerIsOn = nil
    playerIsJumping    = true
    playerIsOnPlatform = false
    
    player.position.y += 1
    
    physicsWorld.gravity = gravityUp
    player.physicsBody   = WinbyScene.makePlayerPB(player: player)
    player.removeAllActions()
    player.physicsBody?.applyImpulse(jumpPower)
  }
  
  func keepPlayerOnPlatform() {
    assert(playerIsOnPlatform, "wtf happened")
    guard let ppio = platformPlayerIsOn else { fatalError("why is this called") }
    
    let enemyDX = enemyStarting.x - ppio.position.x
    // putNodeOnTopOfAnother(put: player, on: ppio)
    player.position.x -= enemyDX
  }
  
  func keepPlayerInBounds(){
    if player.position.y  < frame.minY {
      print("kpib")
      player.position.y = frame.minY + player.size.halfHeight
    }
  }
  
  func updateSpawner() {
    let wait = SKAction.wait(forDuration: TimeInterval(1 + randy(3)))
    let run = SKAction.run {
      WinbySpawner(gs: self).blackLine(pos: self.nextPos)
      self.updateSpawner()
    }
    let sequence = SKAction.sequence([wait, run])
    self.run(sequence)
  }
  
  // Initials + touches:
  override func didMove(to view: SKView) {
    selfInit()
    WinbySpawner(gs: self).startingLineAndPlayer()
    updateSpawner()
  }
  #if os(iOS)
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    jump()
  }
  #endif
};

// MARK: - Game loop:
extension WinbyScene {
  
  override func update(_ currentTime: TimeInterval) {
    if let ppio = platformPlayerIsOn {
      enemyStarting = ppio.position // set for keepOnPlatform()
    }
    
    playerY = player.position.y    // set for dfu check
  }
  
  override func didEvaluateActions() {
    if playerIsOnPlatform {
       keepPlayerOnPlatform()
    }
  }
  
  override func didSimulatePhysics() {
    keepPlayerInBounds()
  }
  
  override func didFinishUpdate() {
    if playerIsJumping { playerIsJumping = false }
    
    // Player will fall with more gravity than jump:
    if player.position.y < playerY {
       physicsWorld.gravity = gravityDown
    }
    
    // Reset game:
    if dead {
      view?.presentScene(WinbyScene(size: size))
    }
    
  }
};

// MARK: - Winby2.0
extension WinbyScene {

  func setGravityAscend() {
   physicsWorld.gravity = gravityUp
  }
  
  func setGravityDescend() {
   physicsWorld.gravity = gravityDown
  }
  
  func shouldSpawnNewBlock() -> Bool {
    // Check platform, spawn count, and line cleared:
    
    return false
  }

  func getPositionToSpawnAt() -> CGPoint {
    
    return CGPoint.zero
  }
  
  func spawnNewBlock(at point: CGPoint) {
    
  }
  
  func shouldIncreaseHighscore() -> Bool {
   // if player.platform.name == "0" { return false }
    return false
  }
  
  func increaseHighscore() {
    self.highestPoint += 1
    // Play sound...
    // Do UD...
  }
  
}

//
//  WinbyScene2.swift
//  dd

import SpriteKit

// Data:
class WinbyScene2 : SKScene {
  
  typealias Succeeded = Bool
  
  // MARK: - Sprite data:
  let player = Playa()
  var platforms = ["": Platform()]
  var curFrame = 0.0
  
  // MARK: - Gravity / Physics data:
  let
  GRAVITY_UP   = CGVector(dx: 0,   dy: -20),
  GRAVITY_DOWN = CGVector(dx: 0,   dy: -30),
  JUMP_POWER   = CGVector(dx: 0,   dy: 100 ),
  VEC_LEFT     = CGVector(dx: -10, dy: 0  ),
  VEC_RIGHT    = CGVector(dx: 10,  dy: 0  )
  
  // MARK: - Highscore data:
  var
  highestPoint = -1
  
  // MARK: - Spawner data:
  let
  RIGHT = "RIGHT",
  LEFT  = "LEFT"
  
  var
  enemiesSpawned = 0,
  lastSideSpawnedOn = "LEFT"

  // MARK: - Loop data:
  var
  previousFrameTime = TimeInterval(0),
  thisFrameTime     = TimeInterval(0)
  
  var deltaTime: TimeInterval { return thisFrameTime - previousFrameTime }
}

// MARK: Sprite funcs:
extension WinbyScene2 {
  
   func addPlatformToDict(_ platform: Platform) {
    assert(platform.name != nil)
    platforms[platform.name!] = platform
  }
}

// MARK: - Config funcs:
extension WinbyScene2: SKPhysicsContactDelegate {
  
  private func initSelf() {
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    physicsWorld.gravity = GRAVITY_UP
    physicsWorld.contactDelegate = self
  }
  
  private func initPlatform() {
    let SIZE = CGSize(width: 200, height: 40)
    let newPlatform: Platform = Platform(color: .blue,
                                         size:        SIZE)
    newPlatform.name = "0"
    newPlatform.physicsBody = SKPhysicsBody(rectangleOf: SIZE)
    newPlatform.physicsBody?.categoryBitMask = UInt32(2)
    newPlatform.physicsBody?.contactTestBitMask = UInt32(1)
    newPlatform.physicsBody!.isDynamic = false
    newPlatform.position.y = frame.minY
    newPlatform.position.y += newPlatform.size.halfHeight
    
    addPlatformToDict(newPlatform)
    addChild(newPlatform)
  }
  
  private func initPlayer() {
    assert(platforms["0"] != nil)
    addChild(player)
  
    player.name = "sup"
    player.size = CGSize(width: 50, height: 50)
    player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
    player.physicsBody?.categoryBitMask = UInt32(1)
    player.physicsBody?.contactTestBitMask = UInt32(2)
    player.platform = platforms["0"]!
    player.color = .yellow
    player.position = platforms["0"]!.position
    player.position.y += player.platform!.size.height + 10
    player.enter(OnPlatform.self)
  }
  
  override func didMove(to view: SKView) {
    initSelf()
    initPlatform()
    initPlayer()
  }
}

// MARK: -  Gravity funcs:
// Useless funcs are useless? Or coder brain-fart proof?
extension WinbyScene2 {
  func setGravityAscend() {
    physicsWorld.gravity = GRAVITY_UP
  }
  
  func setGravityDescend() {
    physicsWorld.gravity = GRAVITY_DOWN
  }
}


// MARK: - Highscore funcs:
extension WinbyScene2 {
  
  // func UDFunc() {}
  
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


// MARK: - Spawner funcs:
extension WinbyScene2 {

  private struct local {
    static let OFFSET = CGFloat(1)
  }
  
  // Check platform, spawn count, and line cleared:
  func shouldSpawnNewPlatform() -> Bool {
    assert(player.currentState is OnPlatform)
    guard let platform = player.platform else { fatalError("must have platform") }
    
    if platform.id > highestPoint {
      highestPoint = platform.id
      
      return true
    }
    else { return false }
  }
  
  func getPositionToSpawnAt() -> CGPoint {
    guard let platform = player.platform else { fatalError("must have platform") }
    
    let randomResult = randy(2).f
    
    let distance = platform.size.height * randomResult + local.OFFSET
    
    var posX:  CGFloat = {
      if lastSideSpawnedOn == RIGHT { return frame.minX }
      else { return frame.maxX }
    }()

    let posY = (platform.position.y + distance)
    
    return CGPoint(x: posX, y: posY)
  }
  
  func getNameForPlatform(_ platform: Platform) -> String {
    let pos = platform.position
    
    if pos.y > (platform.position.y + platform.size.height + local.OFFSET) {
      return "2"
    } else { return "1" }
  }
  
  func getAnimationForPlatform(_ platform: Platform) -> SKAction {
    
    let pos = platform.position
    
    var firstX:  CGFloat
    var secondX: CGFloat
    
    // How about a while loop in a .run? Will that fetch fresh data?
    if lastSideSpawnedOn == RIGHT {
      firstX  = frame.minX - platform.size.halfWidth
      secondX = frame.maxX + platform.size.halfWidth
    } else {
      firstX  = frame.maxX + platform.size.halfWidth
      secondX = frame.minX - platform.size.halfWidth
    }
    
    let
    pointY       = pos.y,
    firstPoint   = CGPoint(x: firstX,  y: pointY),
    secondPoint  = CGPoint(x: secondX, y: pointY),
    
    randomSpeed  = TimeInterval(3), // (baseSpeed + randy(speedMod)),
    action1      = SKAction.move(to: firstPoint,  duration: randomSpeed),
    action2      = SKAction.move(to: secondPoint, duration: randomSpeed),
    sequence     = SKAction.sequence([action1, action2]),
    repeating    = SKAction.repeatForever(sequence)
    
    return repeating
  }
  
  func spawnPlatform(at pos: CGPoint) {
    
    let newPlatform = Platform(color: .black, size: CGSize(width: 300, height:40))
    newPlatform.position = pos
    newPlatform.name = getNameForPlatform(newPlatform)
    addPlatformToDict(newPlatform)
    newPlatform.run(getAnimationForPlatform(newPlatform))
    addChild(newPlatform)
    
    if lastSideSpawnedOn == RIGHT { lastSideSpawnedOn = LEFT } else { lastSideSpawnedOn = RIGHT }
  }
}


// MARK: - Game loop:
extension WinbyScene2 {
  #if os(iOS)
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    player.jump(vector: JUMP_POWER)
  }
  #elseif os(OSX)
  override func mouseDown(with event: NSEvent){
  
  player.jump(vector: JUMP_POWER)
  }
  
  #endif
  
  override func update(_ currentTime: TimeInterval) {
  curFrame += 1
    thisFrameTime = currentTime
    player.stateMachine.update(deltaTime: deltaTime)
  }
  
  override func didFinishUpdate() {
    
    for platform in platforms.values { platform.finishUpdate() }
  }
}

// MARK: - Contact: 
extension WinbyScene2 {
  
  private func assignNodeOfType<T>(_ type: T.Type, from contact: SKPhysicsContact) -> T? {
    assert(type is SKNode.Type)
    if let foundA = contact.bodyA.node as? T      { print("found a");return foundA  }
    if let foundB =  contact.bodyB.node as? T { print("found b");return foundB }
    else               { return nil         }
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    
    switch (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) {
    case UInt32(3):
      guard let lPlayer   = assignNodeOfType(Playa.self, from: contact) else { return }
      guard let lPlatform = assignNodeOfType(Platform.self, from: contact) else { return }
      if lPlayer.platform === lPlatform  {print("ok"); return}
      else { print("couldn't find player or platform") }
    default: ()
    }
  }
}

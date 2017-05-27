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
  
  // MARK: - Gravity data:
  let
  GRAVITY_UP   = CGVector(dx: 0, dy: -20),
  GRAVITY_DOWN = CGVector(dx: 0, dy: -30),
  JUMP_POWER   = CGVector(dx: 0, dy: 55 )
  
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
extension WinbyScene2 {

  private struct local {
    static let HELLO_WORLD = "Hello World!"
  }
  
  private func initPlatform() {
    let SIZE = CGSize(width: 200, height: 40)
    let newPlatform = Platform(color:       .blue,
                               size:        SIZE,
                               name:        "0",
                               position:    CGPoint.zero,
                               physicsBody: SKPhysicsBody(rectangleOf: SIZE,
                                                          dynamic:     false,
                                                          restitution: 0)
    )
    addPlatformToDict(newPlatform)
    addChild(newPlatform)
  }
  
  private func initPlayer() {
    
    assert(platforms["0"] != nil)
    player.platform = platforms["0"]!
  }
  
  private func initialize() {
    
  }
  
  override func didMove(to view: SKView) {
    initialize()
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

  func shouldSpawnNewBlock() -> Bool {
    // Check platform, spawn count, and line cleared:
//    if
    return false
  }
  
  func getPositionToSpawnAt() -> CGPoint {
    
    return CGPoint.zero
  }
  
  
  func getAnimationForNextPlatform() -> SKAction {
    return SKAction()
  }
  
  func spawnPlatform(at pos: CGPoint, with animation: SKAction?) {
    //let newPlatform = Platform(color: <#T##NSColor#>, size: <#T##CGSize#>)
  }
}


// MARK: - Game loop:
extension WinbyScene2 {
  
  override func update(_ currentTime: TimeInterval) {
  
    thisFrameTime = currentTime
    player.stateMachine.update(deltaTime: deltaTime)
  }
  
  override func didFinishUpdate() {
    
    
  }
}

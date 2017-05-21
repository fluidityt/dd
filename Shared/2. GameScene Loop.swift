import SpriteKit


// MARK: - Game Loop:
extension GameScene {

  // MARK: - TB:
  func pause() {
    // FIXME: FULLMODE BUG HOTFIX:
    if g.mode.full.value.isOn { return }
    
    if g.mode.dev.value.isOn {
      newGame()
      if let view = view { if let mm = g.mainmenu { view.presentScene(mm) } }
      return
    }
    
    g.paused.toggle()
    
    if g.paused {
      view!.isPaused = true
      view!.frame = CGRect(middle: CGPoint(x: view!.frame.midX, y: view!.frame.midY),
                           width: size.width/3, height: size.height/3)
    } else {
      view!.isPaused = false
          #if os(iOS)
      view!.frame = CGRect(middle: CGPoint(x: view!.frame.midX, y: view!.frame.midY),
                           width:  UIWindow().frame.width, height: UIWindow().frame.height)
      #endif
    }
  }
  #if os(iOS)
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    pause()
  }
  #endif
  
  // MARK: - Update:
  private func keepPlayerInBounds() {
    guard let playa = g.player else { fatalError("issue with player") }
    
    let nh = g.notificationHeight
    let bounds = (fullBottom: frame.minY + playa.size.height/2,
                  bottom:     frame.midY + playa.size.height/2,
                  top:        frame.maxY - playa.size.height/2,
                  left:       frame.minX + playa.size.width/2,
                  right:      frame.maxX - playa.size.width/2)
    
    if g.mode.full.value {
      if playa.position.y < bounds.fullBottom { playa.position.y = bounds.fullBottom }
    }
    else {
      if playa.position.y < bounds.bottom-nh  { playa.position.y = bounds.bottom-nh  }
    }
    
    if playa.position.y > bounds.top-nh { playa.position.y = bounds.top-nh }
    if playa.position.x < bounds.left   { playa.position.x = bounds.left   }
    if playa.position.x > bounds.right  { playa.position.x = bounds.right  }
  }
  
  override func update(_ currentTime: TimeInterval) {
    g.hitThisFrame = false
    
    keepPlayerInBounds()
  }
  
  // MARK: - Contact:
  
  func didBegin(_ contact: SKPhysicsContact) {
    let doContact = DoContact(contact: contact)
  
    let contactedCategories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    switch contactedCategories {
      case Category.yellow | Category.line   : doContact.yellowAndLine ()
      case Category.black  | Category.yellow : doContact.blackAndYellow()
      case Category.black  | Category.death  : doContact.deathAndBlack ()
      case Category.line   | Category.death  : doContact.deathAndLine  ()
      default: ()
    }
  }
  
  // MARK: - End contact:
  override func didSimulatePhysics() {
    
    for node in g.pbKill {
      g.pbKill.remove(node)
      node.removeFromParent()
    }
    
    scoring: do {
      if g.isInvincible { break scoring }
      if g.hitThisFrame { g.hits += 1 }
      if g.hits >= 2    { view!.presentScene(FailScene(size: size)) }
    }
  }
  
  // MARK: - Post:
  func upDifficulty() {
    print("difficulty up!")
    g.difficulty.boxNum   += 1
    g.difficulty.boxSpeed -= 0.08
    updateAction()
    
    g.waiting.toggle()
    g.player?.toggleColor()
  }
  
  func upBoxes() {
    print("boxes up!")
    g.difficulty.boxNum += 1
    updateAction()
    
    g.waiting.toggle()
    g.player?.toggleColor()
  }
  
  override func didFinishUpdate() {
  
    let waiting = g.waiting
    
    switch g.linesCleared {
    // case <#num#>: if  <#excl#>waiting { upDifficulty() }
    case   0: g.waiting = false
    case  10: if !waiting { upDifficulty() }
    case  20: if  waiting { upDifficulty() }
    case  30: if !waiting { upDifficulty() }
    case  40: if  waiting { upBoxes()      }
    case  50: if !waiting { upBoxes()      }
    default: ()
    }
  }
  
};

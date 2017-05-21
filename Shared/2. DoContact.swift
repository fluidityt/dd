//
//  DoContact.swift
//  ffs2222

import SpriteKit

struct DoContact {
  
  var contact: SKPhysicsContact
  
  // SHould be pb or node?
  private func sendToDie(_ node: SKNode) {
    g.pbKill.insert(node)
    node.name = "dead"
    node.physicsBody?.categoryBitMask = Category.zero
  }
  
  private func killACategory(category: UInt32) -> Succeeded {
    if contact.bodyA.categoryBitMask == category{
      guard let a = contact.bodyA.node else { return false }
      sendToDie(a)
      return true
    }
    else if contact.bodyB.categoryBitMask == category {
      guard let b = contact.bodyB.node else { return false }
      sendToDie(b)
      return true
    }
    else { return false }
  }
  
  init(contact: SKPhysicsContact) { self.contact = contact }
  
  /// ... you know what it is ...
  func blackAndYellow() {
    
    func assignYellowBlack() ->  (SKPhysicsBody, SKPhysicsBody) {
      if contact.bodyA.categoryBitMask == Category.yellow {
        return (contact.bodyA, contact.bodyB)
      }
      else {
        return (contact.bodyB, contact.bodyA)
      }
    }
    
    let (yellowPB, blackPB) = assignYellowBlack()
    
    guard let yellowNode = yellowPB.node, let blackNode = blackPB.node else { fatalError() }
    
    if !g.mode.dev.value { yellowNode.setScale(g.difficulty.boxSize) }
    
    func removeANode(blackNode: SKNode) {
      
      // Find nodes at left and right:
      let oneLeft    = blackNode.frame.minX - 0.9
      let oneRight   = blackNode.frame.maxX + 0.9
      let pointLeft  = CGPoint(x: oneLeft, y: blackNode.position.y)
      let pointRight = CGPoint(x: oneRight, y: blackNode.position.y)
      
      sendToDie(blackNode)
      
      let leftNodes  = g.gameScene.nodes(at: pointLeft)
      let rightNodes = g.gameScene.nodes(at: pointRight)
      
      for ln in leftNodes  {
        if ln.name == "black" { removeANode(blackNode: ln) }
      }
      for rn in rightNodes {
        if rn.name == "black" { removeANode(blackNode: rn) }
      }
    }
    
    removeANode(blackNode: blackNode)
    
    // Send signal to take dps at end of physics:
    g.hitThisFrame = true
  }
  
  func yellowAndLine() {
    
    defer { if !g.mode.dev.value { UD.saveHighScore() } }
    
    g.linesCleared += 1
    
    if g.isInvincible == false {
      g.score += 1
      // <#  g.gsi.scoreLabel?.text = "Score \(g.score)"
      if g.score > g.sessionScore { g.sessionScore = g.score }
      print("score:", g.score)
    }
    
    _=killACategory(category: Category.line)
  }
  
  func deathAndBlack() { _=killACategory(category: Category.black) }
  
  func deathAndLine()  { _=killACategory(category: Category.line)  }
};

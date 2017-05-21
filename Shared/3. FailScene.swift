//
//  FailScene.swift
//  ffs2222

import SpriteKit

// MARK: - Scene:
final class FailScene: SKScene {

  static var newHighscore = false
  
  private func selfInit() {
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    setBackGroundColor(forScene: self)
  }
  
  private func makeLabels() {
    
    let labels: [SKLabelNode] = [
      SKLabelNode(text: "SCORE: \(g.score)!"),
      SKLabelNode(text: "SESSION: \(g.sessionScore)"),
      SKLabelNode(text: "HIGHSCORE: \(g.highscore)"),
      PlayLabel(texter: ""),
      MainMenuLabel(texter: "")
    ]
  
    labels[0].position.y += 100
    
    offSetLabel(labels)
    changeFont (labels)
    addChildren(labels)
  }
  
  private func congratulatePlayer() {
    let grats = SKLabelNode(text: "Congrats! New Highscore!!"); do {
      changeFont([grats])
      let offset = CGFloat(75)
      grats.position.y = frame.maxY - (grats.frame.size.halfHeight + offset)
      grats.run(.repeatForever(.sequence([.scale(to: 1.25, duration: 0.25),
                                          .scale(to: 1, duration: 0.25)])))
    }
    addChild(grats)
    FailScene.newHighscore = false
  }
  
  // MARK: - DMV:
  override func didMove(to view: SKView) {
    g.state = .fail
    
    selfInit()
    makeLabels()
    if FailScene.newHighscore { congratulatePlayer() }
    
    // Important this is last:
    g.score = 0
  }
};

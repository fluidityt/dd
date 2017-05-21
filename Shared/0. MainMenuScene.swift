//
// MainMenuScene.swift

import SpriteKit

 

// MARK: - Scene:
final class MainMenuScene: SKScene {
  
  private static var scoreText: String { return "Session: \(g.sessionScore) | High: \(g.highscore)" }
  let mm_scoreLabel = SKLabelNode(text: MainMenuScene.scoreText)
  
  func updateScore() { mm_scoreLabel.text = MainMenuScene.scoreText }
  
  private func selfInit() {
    setBackGroundColor(forScene: self)
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
  }
  
  private func makeLabels() {
    
    let labels: [SKLabelNode] = [
      PlayLabel(texter: ""),
      mm_scoreLabel,
      Toggler(labelName: "GodMode",  refBool: g.mode.dev  ),
      // Toggler(labelName: "SpinMode", refBool: g.mode.spin ),
      Toggler(labelName: "FadeMode", refBool: g.mode.fade ),
      Toggler(labelName: "FullMode", refBool: g.mode.full ),
      Toggler(labelName: "BarMode", refBool:  g.mode.bar  ),
      //Toggler(labelName: "NHMode"  , refBool: g.mode.nh   )
      // <# Toggler(labelName: "Scoring" , refBool: g.mode.score)
      
      Adjustor(text: "SpinMod", refDouble: g.dub.spinMod, step: 1)
    ]
    
    labels[0].position.y += 250
    offSetLabel(labels, by: 50)
    changeFont(labels)
    addChildren(labels)
  }
  
  // ***COMPATIBILITY FOR iOS 9*** \\
  private var firstrun = true

  func sceneLoaded() {
    
    guard firstrun else { return }
    
    g.state = .main
    g.mainmenu = self
    g.sessionScore = 0
    
    UD.initUserDefaults()
    // UD.setHighScore(to: 116)
    UD.loadHighScore()
    
    selfInit()
    makeLabels()
    
    // ***COMPATIBILITY FOR iOS 9*** \\
    firstrun = false

  }
  #if os(iOS)
  
  #elseif os(OSX)
  
  #endif
  // MARK: - DMV:
  override func didMove(to view: SKView) {
  }
};

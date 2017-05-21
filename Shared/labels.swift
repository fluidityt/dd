//
//  labels.swift

import SpriteKit

// MARK: - PlayLabel:
final class PlayLabel: SKLabelNode {
  
  init(texter: String) {
    super.init(fontNamed: "Chalkduster")
    
    self.text = {
      if      g.state == State.fail { return ">>> PLAY AGAIN :D <<<" }
      else if g.state == State.main { return "Play Game!"            }
      else                          { return "error"                 }
    }()
    
    isUserInteractionEnabled = true
  }
  
  func touch() {
    if let scene = self.scene { if let view = scene.view {
      newGame()
      view.presentScene(g.gameScene)
      }
    }
  }
  
  #if os(iOS)
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { touch() }
  #elseif os(OSX)
  override func mouseDown(with event: NSEvent) { touch()  }
  #endif
  required init?(coder aDecoder: NSCoder) { fatalError("") };  override init() { super.init() }
};

// MARK: - MainMenuLabel:
final class MainMenuLabel: SKLabelNode {
  
  init(texter: String) {
    super.init(fontNamed: "Chalkduster")
    self.text = ">>> MainMenu <<<"
    isUserInteractionEnabled = true
  }
  
  func touch() {
    guard let mm = g.mainmenu else { fatalError() }
    if let scene = self.scene { if let view = scene.view {
      mm.updateScore()
      view.presentScene(g.mainmenu!)
      }
    }
  }
  
  #if os(iOS)
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { touch() }
  #elseif os(OSX)
  override func mouseDown(with event: NSEvent) { touch()  }
  #endif
  required init?(coder aDecoder: NSCoder) { fatalError("") }; override init() { super.init() }
};

// MARK: - OptionLabel:
final class OptionLabel: SKLabelNode {
  
  init(texter: String) {
    super.init(fontNamed: "Chalkduster")
    self.text = "Options"
    isUserInteractionEnabled = true
  }
  
  func touch() {
    
  }
  
  #if os(iOS)
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { touch()  }
  #elseif os(OSX)
  override func mouseDown(with event: NSEvent) { touch()  }
  #endif
  required init?(coder aDecoder: NSCoder) { fatalError("") };  override init() { super.init() }
};


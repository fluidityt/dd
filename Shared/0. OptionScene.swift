//
//  OptionScene.swift
//  ffs2222

import SpriteKit

final class OptionScene: SKScene {
  
  private final class BackLabel: SKLabelNode {
    
    init(texter: String) {
      super.init(fontNamed: "Chalkduster")
      self.text = "Back to Main Menu"
      isUserInteractionEnabled = true
    }
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let main = g.mainmenu else { fatalError() }
      self.scene!.view!.presentScene(main)
    }
    #endif
    
    required init?(coder aDecoder: NSCoder) { fatalError("") }
    override init() { super.init() }
  };
};

//
//  GameViewController.swift
//  macOS
//
//  Created by justin fluidity on 5/19/17.
//  Copyright © 2017 justin fluidity. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
  
  private let mySize = CGSize(width: 600, height: 500)
  
  override func viewDidLoad() {
  
    super.viewDidLoad()
    let view = self.view as! SKView; do {
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsPhysics = true
      view.showsNodeCount = true
      view.frame = CGRect(x: 0, y: 0, width: mySize.width, height: mySize.height)
      // g.view = view
    }
    
    let scene = Winby3(size: CGSize(width: 600, height: 500))
    scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    // let scene = MainMenuScene(size: CGSize(width: 600, height: 1000)) // Why does this work?
    scene.scaleMode = .aspectFit
    view.presentScene(scene)
    print("hi")
  }
}


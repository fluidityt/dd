//
//  UserDefaults.swift
//  ffs2222

import Foundation

// struct Hiscore {
struct UD {
  
  static let userDefaults = UserDefaults.standard
  
  struct Keys {
    static let highScore = "highschore"
  }
  
  static func initUserDefaults() {
    if userDefaults.value(forKey: Keys.highScore) == nil {
      userDefaults.setValue(0, forKey: Keys.highScore)
    }
  }
  
  static func saveHighScore() {
    // This is crazy.. mutating state in 4 different places...
    guard let oldHS = userDefaults.value(forKey: Keys.highScore) as? Int else { print("bad key"); return }
    if g.score > oldHS {
      g.highscore = g.score
      guard let mm = g.mainmenu else { fatalError() }
      mm.updateScore()
      FailScene.newHighscore = true
      userDefaults.setValue(g.score, forKey: Keys.highScore)
      print("saved high g.score!")
    }
  }
  
  static func loadHighScore() {
    guard let value = userDefaults.value(forKey: Keys.highScore) else { print("no hs in UD"); return }
    guard let hs = value as? Int else { print("value was not Int"); return }
    g.highscore = hs
    guard let mm = g.mainmenu else { fatalError() }
    mm.updateScore()
    print("loaded high g.score!")
  }
  
  static func setHighScore(to value: Int) {
    userDefaults.setValue(value, forKey: Keys.highScore)
    g.highscore = value
    guard let mm = g.mainmenu else { fatalError() }
    mm.updateScore()
    print("reset g.highscore")
  }
  
};

import Foundation

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let ball      : UInt32 = 0b1       // 1
  static let paddle    : UInt32 = 0b10      // 2
  static let playArea   : UInt32 = 0b100     // 3
}

//
//  K.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/6/21.
//

import Foundation
import CoreGraphics

struct K {
  
  // MARK: - Sizes
  
  struct Sizes {
    // MARK: - Spacing
    
    static let smallSpace: CGFloat = 8
    static let medSpace: CGFloat = 12
    static let largeSpace: CGFloat = 24
    
    // MARK: - Radii
    
    static let smallRadius: CGFloat = 8
    static let medRadius: CGFloat = 12
    static let largeRadius: CGFloat = 24
    
    // MARK: - Heights
    
    static let primaryToolbarHeight: CGFloat = 72
    static let convertButtonHeight: CGFloat = 72
    static let inputTextViewHeight: CGFloat = 110
    static let keyboardToolbarHeight: CGFloat = 36
    
    // MARK: - Fonts
    
    static let smallText: CGFloat = 16
    static let medText: CGFloat = 24
  }
  
  // MARK: - Strings
  
  struct Labels {
    static let inputButton = "Input"
    static let outputButton = "Output"
    static let convertButton = "Convert"
  }
  
}

//
//  BezierDialogWindow.swift
//  
//
//  Created by woody on 2023/03/13.
//

import SwiftUI

final class BezierDialogWindow: UIWindow {
  private weak var appKeyWindow: UIWindow?
  
  init(windowScene: UIWindowScene, appKeyWindow: UIWindow) {
    self.appKeyWindow = appKeyWindow
    super.init(windowScene: windowScene)
    
    self.rootViewController = BezierDialogHostingController(rootView: BezierDialogView())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func becomeKey() {
    super.becomeKey()
    
    self.appKeyWindow?.becomeKey()
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let hitView = super.hitTest(point, with: event) else { return nil }
    
    return rootViewController?.view == hitView ? nil : hitView
  }
}

final class BezierDialogHostingController: UIHostingController<BezierDialogView> {
  override var prefersStatusBarHidden: Bool { true }
}

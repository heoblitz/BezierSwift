//
//  BezierDialogManager.swift
//  
//
//  Created by woody on 2023/03/13.
//

import SwiftUI

public enum BezierDialogButtonInfo {
  case vertical([BezierButton])
  case horizontal([BezierButton])
}

public struct BezierDialogParam {
  var id = UUID()
  
  // TODO: priority 일정 enum으로 제한두기. by jam 2023.02.24
  var priority: Int
  var title: String
  var description: String
  var buttonInfo: BezierDialogButtonInfo?
  var dismissCompletion: (() -> Void)?
  
  public init(
    priority: Int,
    title: String?,
    description: String?,
    buttonInfo: BezierDialogButtonInfo?,
    dismissCompletion: (() -> Void)?
  ) {
    self.priority = priority
    self.title = title ?? ""
    self.description = description ?? ""
    self.buttonInfo = buttonInfo
    self.dismissCompletion = dismissCompletion
  }
}

public struct BezierDialogManager {
  public static func show(with param: BezierDialogParam) {
    BezierDialogSingleton.shared.viewModel.update(param: param)
  }

  public static func dismiss() {
    BezierDialogSingleton.shared.viewModel.dismiss()
  }
}

final class BezierDialogSingleton {
  var viewModel: DialogViewModel
  
  private var isPrepared: Bool = false
  private var bezierDialogWindow: BezierDialogWindow?
  
  static let shared = BezierDialogSingleton()

  init() {
    self.viewModel = DialogViewModel()
  }
  
  func prepare() {
    guard !self.isPrepared else { return }
        
    guard
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let keyWindow = windowScene.windows.filter({ $0.isKeyWindow }).first
    else {
      return
    }
        
    self.isPrepared = true
    let bezierDialogWindow = BezierDialogWindow(windowScene: windowScene, appKeyWindow: keyWindow)
    bezierDialogWindow.makeKeyAndVisible()
    self.bezierDialogWindow = bezierDialogWindow
  }
}

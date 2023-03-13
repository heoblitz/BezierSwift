//
//  BezierDialog.swift
//  
//
//  Created by Jam on 2023/02/15.
//

import SwiftUI
import Dispatch

final class DialogViewModel: ObservableObject {
  @Published private(set) var isPresented: Bool = false
  @Published var title: String = ""
  @Published var description: String = ""
  @Published var buttons: [BezierButton] = []
  @Published var isButtonStackVertical = false
  
  var currentParamId: UUID = UUID()
  var currentDismissCompletion: (() -> Void)?
  var currentPriority: Int = Int.min
  
  func update(param: BezierDialogParam) {
    guard param.priority > self.currentPriority else {
      param.dismissCompletion?()
      return
    }
    
    let delayTime: DispatchTime = .now() + (self.isPresented ? 0.3 :  0)
    
    self.dismiss()
    
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      self.currentParamId = param.id
      self.currentDismissCompletion = param.dismissCompletion
      self.currentPriority = param.priority
      
      self.title = param.title
      self.description = param.description
      
      if let buttonInfo = param.buttonInfo {
        switch buttonInfo {
        case .vertical(let buttons):
          self.buttons = buttons
          self.isButtonStackVertical = true
        case .horizontal(let buttons):
          self.buttons = buttons
          self.isButtonStackVertical = false
        }
      }
      
      withAnimation(.easeInOut(duration: 0.3)) {
        self.isPresented = true
      }
    }
  }
  
  func dismiss() {
    self.currentDismissCompletion?()
    
    self.currentDismissCompletion = nil
    self.currentParamId = UUID()
    self.currentPriority = Int.min
    
    withAnimation(.easeInOut(duration: 0.3)) {
      self.isPresented = false
    }
  }
}

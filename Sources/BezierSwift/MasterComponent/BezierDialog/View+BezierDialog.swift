//
//  View+BezierDialog.swift
//  
//
//  Created by woody on 2023/03/13.
//

import SwiftUI

extension View {
  public func initBezierDialog() -> some View {
    self.onAppear {
      BezierDialogSingleton.shared.prepare()
    }
  }
}
//
//  BezierDialogView.swift
//  
//
//  Created by woody on 2023/03/13.
//

import SwiftUI

private enum Metric {
  static let dimSideMinPadding = CGFloat(40)

  static let dialogMaxWidth = CGFloat(480)
  static let dialogPadding = CGFloat(16)

  static let upperStackContainerTop = CGFloat(4)
  static let upperStackSpace = CGFloat(8)

  static let middleStackTop = CGFloat(16)
  static let middleStackSpace = CGFloat(12)

  static let belowStackTop = CGFloat(20)
  static let belowStackSpace = CGFloat(8)
}

private enum ZIndex {
  static let dimmView = Double(1)
  static let contentView = Double(2)
}

public struct BezierDialogView: View, Themeable {
  @StateObject private var viewModel: DialogViewModel = BezierDialogSingleton.shared.viewModel
  @Environment(\.colorScheme) public var colorScheme
  
  public init() { }
  
  public var body: some View {
    if self.viewModel.isPresented {
      ZStack {
        self.dimmedView
          .zIndex(ZIndex.dimmView)
        
        self.dialogContentView
          .zIndex(ZIndex.contentView)
      }
    } else {
      EmptyView()
    }
  }
  
  private var dimmedView: some View {
    self.palette(.bgtxtAbsoluteBlackLighter)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .allowsHitTesting(false)
      .edgesIgnoringSafeArea(.all)
  }
    
  private var dialogContentView: some View {
    VStack(alignment: .center, spacing: .zero) {
      HStack(spacing: .zero) {
        HStack(spacing: .zero) {
          VStack(alignment: .center, spacing: Metric.belowStackTop) {
            if !self.viewModel.title.isEmpty || !self.viewModel.description.isEmpty {
              VStack(alignment: .center, spacing: Metric.upperStackSpace) {
                if !self.viewModel.title.isEmpty {
                  Text(self.viewModel.title)
                    .applyBezierFontStyle(.bold16)
                }
                if !self.viewModel.description.isEmpty {
                  Text(self.viewModel.description)
                    .applyBezierFontStyle(.normal14)
                }
              }
              .padding(.top, Metric.upperStackContainerTop)
            }
            
            if !self.viewModel.buttons.isEmpty {
              if self.viewModel.isButtonStackVertical {
                VStack(spacing: Metric.belowStackSpace) {
                  ForEach(viewModel.buttons.prefix(4).indices, id: \.self) { idx in
                    self.viewModel.buttons[idx]
                  }
                }
              } else {
                HStack(spacing: Metric.belowStackSpace) {
                  ForEach(self.viewModel.buttons.prefix(2).indices, id: \.self) { idx in
                    self.viewModel.buttons[idx]
                  }
                }
              }
            }
          }
          .padding(.all, Metric.dialogPadding)
          .frame(maxWidth: .infinity)
        }
        .background(self.palette(.bgWhiteHigh))
        .applyBezierCornerRadius(type: .round16)
        .applyBezierElevation(self, type: .mEv3)
        .frame(maxWidth: Metric.dialogMaxWidth)
        .padding(.horizontal, Metric.dimSideMinPadding)
      }
    }
  }
}


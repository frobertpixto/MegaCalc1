//
//  ButtonStyles.swift
//  MegaCalc1
//
//  Created by Francois Robert on 2022-01-01.
//

import SwiftUI

struct OperationButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
	 configuration.label
		.frame(width: 70, height: 40)
		.opacity(configuration.isPressed ? 0.2 : 1)
		.addButtonBorder(Color.gray)
		.background(
		  RadialGradient(
			 gradient: Gradient(
				colors: [Color.white, Color.gray]
			 ),
			 center: .center,
			 startRadius: 0,
			 endRadius: 90
		  )
		)
  }
}

struct CalcButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
	 configuration.label
		.frame(width: 60, height: 30) //, alignment: .leading)
//		.padding(EdgeInsets(top: 0, leading:2, bottom: 0, trailing: 2))
		.opacity(configuration.isPressed ? 0.2 : 1)
		.addButtonBorder(Color.blue)
  }
}

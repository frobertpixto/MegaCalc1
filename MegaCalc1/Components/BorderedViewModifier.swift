import SwiftUI

struct BorderedViewModifier: ViewModifier {
	func body(content: Content) -> some View {
	  content
			.background(Color.white)
//			.accentColor(Color.black)
			.overlay(
			  RoundedRectangle(cornerRadius: 4)
				 .stroke(lineWidth: 2)
				 .foregroundStyle(.blue)
			)
			.shadow(color: Color.gray.opacity(0.4),
					  radius: 3, x: 1, y: 2)
	}
}



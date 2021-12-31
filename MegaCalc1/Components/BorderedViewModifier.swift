import SwiftUI

struct BorderedViewModifier: ViewModifier {
	func body(content: Content) -> some View {
	  content
			.padding(
			  EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
			.background(Color.white)
//			.accentColor(Color.black)
			.overlay(
			  RoundedRectangle(cornerRadius: 4)
				 .stroke(lineWidth: 2)
				 .foregroundColor(.blue)
			)
			.shadow(color: Color.gray.opacity(0.4),
					  radius: 3, x: 1, y: 2)

	}
}



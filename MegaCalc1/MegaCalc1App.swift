//
//  MegaCalc1App.swift
//  MegaCalc1
//
//  Created by Francois Robert on 2021-12-27.
//

import SwiftUI

@main
struct MegaCalc1App: App {
    var body: some Scene {
        WindowGroup {
            MegaCalcView()
				  .preferredColorScheme(.light)
				  .frame(minWidth: 600, minHeight: 300.0)
				  .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

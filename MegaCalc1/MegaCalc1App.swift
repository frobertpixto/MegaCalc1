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
				  .frame(width: 800.0, height: 400.0)
        }
    }
}

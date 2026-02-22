//
//  ContentView.swift
//  MegaCalc1
//
//  Created by Francois Robert on 2021-12-27.
//

import SwiftUI

struct MegaCalcView: View {
    @StateObject private var vm = MegaCalcViewModel()
    private let operandHeight: CGFloat = 30

    private let calculatorColumns = [
        GridItem(.fixed(90), spacing: 20),
        GridItem(.fixed(90), spacing: 20),
        GridItem(.fixed(90), spacing: 20),
        GridItem(.fixed(90), spacing: 20),
        GridItem(.fixed(90), spacing: 20)
    ]

    var body: some View {
        Color(.white).overlay(
            VStack {
                Group {
                    OperandRow(title: "A:", text: $vm.aText, buttonTitle: "A <- Res", action: vm.setResultToA)
                    OperandRow(title: "B:", text: $vm.bText, buttonTitle: "B <- Res", action: vm.setResultToB)
                    OperandRow(title: "Result:", text: $vm.resultText, buttonTitle: "Cancel", action: vm.cancel)
                }
                .buttonStyle(CalcButtonStyle())
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))

                if vm.isBusy {
                    ProgressView().padding(.vertical, 8)
                }

                LazyVGrid(columns: calculatorColumns, spacing: 20) {
                    Group {
                        Button("A + B", action: vm.add)
                        Button("A - B", action: vm.subtract)
                        Button("A * B", action: vm.multiply)
                        Button("A / B", action: vm.divide)
                        Button("A MOD B", action: vm.modulo)
                        Button("A!", action: vm.factorial)
                        Button("Prime(A)", action: vm.isPrime)
                        Button("Pr() <= A", action: vm.primeSmallerOrEqual)
                    }
                    .disabled(vm.isBusy)
                    .buttonStyle(OperationButtonStyle())
                }
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
            }
        )
    }
}

private struct OperandRow: View {
    let title: String
    @Binding var text: String
    let buttonTitle: String
    let action: () -> Void
    private let operandHeight: CGFloat = 30

    var body: some View {
        HStack {
            Text(title)
                .frame(width: 60, height: operandHeight, alignment: .trailing)
            TextField("", text: $text)
                .bordered()
            Button(buttonTitle, action: action)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MegaCalcView()
                .preferredColorScheme(.light)
                .frame(width: 800.0, height: 400.0)
        }
    }
}

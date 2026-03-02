//
//  ContentView.swift
//  MegaCalc1
//
//  Created by Francois Robert on 2021-12-27.
//

import SwiftUI

struct MegaCalcView: View {
    @State private var vm = MegaCalcViewModel()
    private let operandHeight: CGFloat = 30

    private let calculatorColumns = [
        GridItem(.fixed(90), spacing: 20),
        GridItem(.fixed(90), spacing: 20),
        GridItem(.fixed(90), spacing: 20),
        GridItem(.fixed(90), spacing: 20),
        GridItem(.fixed(90), spacing: 20)
    ]

    var body: some View {
        Color.white.overlay(
            VStack {
                Group {
                    OperandRow(title: "A:", text: $vm.aText, buttonTitle: "A <- Res", action: vm.setResultToA)
                    OperandRow(title: "B:", text: $vm.bText, buttonTitle: "B <- Res", action: vm.setResultToB)
                    OperandRow(title: "Result:", text: $vm.resultText, buttonTitle: "Cancel", action: vm.cancel)
                }
                .buttonStyle(CalcButtonStyle())
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))

                if vm.isBusy && !vm.isFactorialRunning {
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

                Spacer()

                StatusBar(
                    isFactorialRunning: vm.isFactorialRunning,
                    factorialProgress: vm.factorialProgress,
                    durationText: vm.durationText
                )
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

    private var digitCountLabel: String {
        var digits = text
        if let first = digits.first, first == "+" || first == "-" {
            digits.removeFirst()
        }
        digits = String(digits.drop(while: { $0 == "0" }))
        if digits.isEmpty { return "" }
        let count = digits.count
        return count == 1 ? "1 digit" : "\(count) digits"
    }

    var body: some View {
        HStack {
            Text(title)
                .frame(width: 60, height: operandHeight, alignment: .trailing)
            TextField("", text: $text)
                .bordered()
            Text(digitCountLabel)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .trailing)
            Button(buttonTitle, action: action)
        }
    }
}

private struct StatusBar: View {
    let isFactorialRunning: Bool
    let factorialProgress: Double
    let durationText: String

    var body: some View {
        HStack {
            Spacer()

            if isFactorialRunning {
                ProgressView(value: factorialProgress)
                    .frame(maxWidth: 200)
            }

            Text(durationText)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .trailing)
        }
        .padding(EdgeInsets(top: 4, leading: 10, bottom: 6, trailing: 10))
    }
}

#Preview {
    MegaCalcView()
        .preferredColorScheme(.light)
        .frame(width: 800.0, height: 400.0)
}

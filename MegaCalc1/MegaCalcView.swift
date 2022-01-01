//
//  ContentView.swift
//  MegaCalc1
//
//  Created by Francois Robert on 2021-12-27.
//

import SwiftUI

struct OperationData
{
	var a : BigInteger?			= nil
	var b : BigInteger?			= nil
	var result : BigInteger?	= nil
	var textResponse : String? = nil
}

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

struct MegaCalcView: View {
	@State private var accumulator = 0.0
	@State private var display = ""
	private let operandHeight: CGFloat = 30
	
	@State var a: String = "1111"
	@State var b: String = "22222222"
	@State var result: String = ""
	
	let megaDecimalAlgo = MegaDecimalAlgo()
	
	let errorDivdideByZero  = "Divide by Zero"	// TODO Localize
	let errorCancelled		= "Cancelled"			// TODO Localize
	let errorInvalidA			= "Invalid number A"	// TODO Localize
	let errorInvalidB			= "Invalid number B"	// TODO Localize
	let tooBigForOperation	= "Number too Big for operation"	// TODO Localize
	let doesNotExists			= "Does Not exists"	// TODO Localize

	let calculatorColumns = [
	  GridItem(.fixed(90), spacing: 20),
	  GridItem(.fixed(90), spacing: 20),
	  GridItem(.fixed(90), spacing: 20),
	  GridItem(.fixed(90), spacing: 20),
	  GridItem(.fixed(90), spacing: 20)
	]
	
    var body: some View {
		 Color(.white).overlay(
		 LazyVStack {
			 HStack {
				 Text("A:")
					 .frame(width: 60, height: operandHeight, alignment: .trailing)
				 TextField("1111", text: $a)
					 .bordered()
				 Button(action: {
					 self.resToA()
				 }, label: {
					Text("A <- Res")
				 })
					 .buttonStyle(CalcButtonStyle())
				 
			 }.padding(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 10))
			 
			 HStack {
				 Text("B:")
					 .frame(width: 60, height: operandHeight, alignment: .trailing)
				 TextField("2222", text: $b)
					 .bordered()
				 Button(action: {
					 self.resToB()
				 }, label: {
					Text("B <- Res")
				 })
					 .buttonStyle(CalcButtonStyle())
			 }.padding(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 10))
			 
			 HStack {
				 Text("Result:")
					 .frame(width: 60, height: operandHeight, alignment: .trailing)
				 TextField("00", text: $result)
					 .bordered()
				 Button(action: {
					 self.cancelOperation()
				 }, label: {
					Text("Cancel")
				 })
					 .buttonStyle(CalcButtonStyle())
					 .disabled(true)
			 }.padding(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 10))

			 Spacer()
			 LazyVGrid(columns: calculatorColumns, spacing: 20) {
				 Group {
					Button(action: {
						self.aPlusB()
					}, label: {
					  Text("A + B")
					})
					.buttonStyle(OperationButtonStyle())

					Button(action: {
						self.aSubB()
					}, label: {
					  Text("A - B")
					})
					.buttonStyle(OperationButtonStyle())

					Button(action: {
						self.aMultB()
					}, label: {
					  Text("A * B")
					})
					.buttonStyle(OperationButtonStyle())

					Button(action: {
						self.aDivB()
					}, label: {
					  Text("A / B")
					})
					.buttonStyle(OperationButtonStyle())

					Button(action: {
						self.aModB()
					}, label: {
					  Text("A MOD B")
					})
					.buttonStyle(OperationButtonStyle())

					Button(action: {
						self.factorialA()
					}, label: {
					  Text("A!")
					})
					.buttonStyle(OperationButtonStyle())

					Button(action: {
						self.isAPrime()
					}, label: {
					  Text("Prime(A)")
					})
					.buttonStyle(OperationButtonStyle())

					Button(action: {
						self.findBiggestPrimeSmallerOrEqualToA()
					}, label: {
					  Text("Pr() <= A")
					})
					.buttonStyle(OperationButtonStyle())
				 }
				 .buttonStyle(OperationButtonStyle())
			 }
		 })
    }
	
	private func extractBigIntegerABValue() -> OperationData
	{
		var operationData = OperationData()
		
		if let a1 = a.count > 0 ? BigInteger(a) : BigInteger(0)
		{
			if let b1 = b.count > 0 ? BigInteger(b) : BigInteger(0)
			{
				operationData.a = a1
				operationData.b = b1
			}
			else
			{
				operationData.a = a1
				operationData.textResponse = errorInvalidB
			}
		}
		else
		{
			operationData.textResponse = errorInvalidA
		}
		
		return operationData
	}
	
	func displayResult(operationData: OperationData)
	{
		// Result
		if let errorOrTextResult = operationData.textResponse
		{
			result = errorOrTextResult
		}
		else if let result1 = operationData.result
		{
			result = result1.toString()
		}
		else
		{
			result = ""
		}
	}
}

// MARK: - Event Handlers
extension MegaCalcView {
	func resToA() {
		a = result
	}
	func resToB() {
		b = result
	}
	func cancelOperation() {
	}
	
	func aPlusB() {
		var operationData = extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a,
			let b = operationData.b
		{
			// Perform the operation
			operationData.result = a + b
		}

		displayResult(operationData: operationData)
	}
	func aSubB() {
		var operationData = extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a,
			let b = operationData.b
		{
			// Perform the operation
			operationData.result = a - b
		}

		displayResult(operationData: operationData)
	}
	func aMultB() {
		var operationData = extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a,
			let b = operationData.b
		{
			// Perform the operation
			operationData.result = a * b
		}

		displayResult(operationData: operationData)
	}
	
	func aDivB() {
		var operationData = extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a,
			let b = operationData.b
		{
			// Perform the operation
			do {
				try operationData.result = a / b
			}
			catch BigIntegerError.divideByZero {
				operationData.textResponse = errorDivdideByZero
			}
			catch let error {
				operationData.textResponse = "\(error.localizedDescription)"
			}
		}

		displayResult(operationData: operationData)
	}
	
	func aModB() {
		var operationData = extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a,
			let b = operationData.b
		{
			// Perform the operation
			do {
				try operationData.result = a % b
			}
			catch BigIntegerError.divideByZero {
				operationData.textResponse = errorDivdideByZero
			}
			catch let error {
				operationData.textResponse = "\(error.localizedDescription)"
			}
		}

		displayResult(operationData: operationData)
	}
	
	func factorialA() {
		var operationData = extractBigIntegerABValue()
		
		if operationData.textResponse == nil,
			let a = operationData.a
		{
		
			DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
			{
				do
				{
					try operationData.result = self.megaDecimalAlgo.factorial(a.toInt())
				}
				catch MegaDecimalAlgoError.cancelled {
					operationData.textResponse = self.errorCancelled
				}
				catch BigIntegerError.tooBigForInt64 {
					operationData.textResponse = self.tooBigForOperation
				}
				catch let error {
					operationData.textResponse = "\(error.localizedDescription)"
				}
				
				// Back to the main thread to update the UI
				DispatchQueue.main.async {
					() -> Void in
					self.displayResult(operationData: operationData)
				}
			}
		}
		
		displayResult(operationData: operationData)
	}
	
	func isAPrime() {
		var operationData = extractBigIntegerABValue()

		if operationData.textResponse == nil,
			let a = operationData.a
		{

			DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
				{
					do
					{
						try operationData.textResponse = self.megaDecimalAlgo.isPrime(a) ? "Yes" : "No"
					}
					catch MegaDecimalAlgoError.cancelled {
						operationData.textResponse = self.errorCancelled
					}
					catch let error {
						operationData.textResponse = "\(error.localizedDescription)"
					}

					// Back to the main thread to update the UI
					DispatchQueue.main.async {
						() -> Void in
						self.displayResult(operationData: operationData)
					}
			}
		}

		displayResult(operationData: operationData)
	}

	func findBiggestPrimeSmallerOrEqualToA() {
		var operationData = extractBigIntegerABValue()

		if operationData.textResponse == nil,
			let a = operationData.a
		{

			DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
				{
					do
					{
						try operationData.result = self.megaDecimalAlgo.smallerOrEqualPrime(a)
					}
					catch MegaDecimalAlgoError.cancelled {
						operationData.textResponse = self.errorCancelled
					}
					catch MegaDecimalAlgoError.doesNotExists {
						operationData.textResponse = self.doesNotExists
					}
					catch let error {
						operationData.textResponse = "\(error.localizedDescription)"
					}

					// Back to the main thread to update the UI
					DispatchQueue.main.async {
						() -> Void in
						self.displayResult(operationData: operationData)
					}
			}
		}

		displayResult(operationData: operationData)
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

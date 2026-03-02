# MegaCalc1

MegaCalc1 is an arbitrary-precision integer calculator for macOS. It doesn't care how big your numbers are.
- Want to compute `50000!`? Go ahead (the answer has 213237 digits). 
- Want to check if 123456789 is prime? Be our guest (it is not, but 123456761 is).

## Migration to SwiftUI
This a migration from my MegaCalc repo (AppKit) to SwiftUI

This is still a Work in Progress as I continue to learn SwiftUI

### TODO
- Add Unit tests for Algos
- Add UI tests
- Improve MegaDecimalAlgo.getUpperSquareRootApproximation() to lower the number of calculations when searching for prime numbers.
- Support Light and Dark Themes.
- Make sure that displayed duration includes full duration from start to finish.
- Add Buttons that generates big numbers
  - All 111...111 of selected length. Example: for selected length 9: 111111111
  - All 999...999 of selected length
  - All Random of selected length
- Implement Accessibility features with SwiftUI?
- Add support for interrupting/continuing a calculation using the file system to store progression state?
- Support decimal point with BigDecimal?

### Bugs
- No known issues...


## MegaCalc - Almost infinite Integer Calculator
---
I created a first version of this calculator in 1993.  

At that time, I read in a magazine that someone was trying to break the World record for the biggest multiplication. The record was with 2 numbers of 22,000 digits in 24 hours.  
Experimenting at that time in C++ on Windows, I already made a String based calculator for large numbers.  
So I decided to see if I could come with a fast algorithm to beat that 22,000 digits multiplication records.

After 2 weeks where I:
- Flipped my algorithm inside-out
- Reached the 640K limit of MS-DOS

I was able to multiply two **500,000** digits numbers in less than 24 hours of computation.

In 1995, I used a Beta of Windows 95 to push that limit and I also made a Windows MegaCalc where the multiplications were interruptible and restartable.

Since then, I have implemented MegaCalc in:
- C#
- Java
- Swift

---
## Swift version
### Directory: MegaCalc1
The Swift version has the following properties:
- Uses a simple Mac UI.
- Shows good example of TDD (Test Driven Development) where you build your tests before creating the code.
- Uses Xcode to run Unit tests and UI tests.


---
## Improvements for Performance suggested by Claude code

### Performance — High Impact

1. Division/Modulo is O(n*m) via repeated subtraction (Big​Integer​.swift​:457​-461, 515​-523). The inner while eval​Value >= positive​B loop subtracts the divisor one unit at a time. For a digit like 9 in the quotient, that's 9 subtractions per position. A standard long-division approach would estimate each quotient digit (e.g., by comparing leading digits or using binary search over 0–9), reducing each position to constant-time work. This is the single biggest performance bottleneck for large divisions.

2. Multiplication is O(n²) schoolbook (Big​Integer​.swift​:334​-412). For very large numbers (thousands+ digits), algorithms like Karatsuba (O(n^1.585)) or Toom-Cook would give meaningful speedups. Karatsuba is straightforward to implement: split each number in half and recurse with 3 multiplications instead of 4.

3. exp10(1) in the division loop (Big​Integer​.swift​:455, 465) reconstructs the entire number through to​Byte​Array → Big​Integer(p​Byte​List:...) for every single digit of the quotient. This is extremely expensive. A dedicated "multiply by 10" or "shift left by 1 digit" operation that operates directly on the octoble list would be much faster.

4. toString() uses digit-by-digit formatting (Big​Integer​.swift​:726). Using String(format: "%08ld", val​A) for each octoble would be cleaner and likely faster than the 8-argument format string with manual digit extraction.

5. toByteArray() is verbose and slow (Big​Integer​.swift​:979​-1064). The 7-case if​/else ladder for the first octoble could be replaced by a simple loop dividing by decreasing powers of 10, or by converting via String(octoble​Value) and mapping characters to UInt8.

Summary of priorities

| Priority | Improvement | Impact |
|----------|-------------|--------|
| 1 | Replace repeated-subtraction division with digit-estimation | Massive speedup for division/modulo |
| 2 | Dedicated "multiply by 10" instead of exp10(1) via byte array | Large speedup for division |

---
by Francois Robert 


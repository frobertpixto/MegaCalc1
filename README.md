# MegaCalc1

## Migration to SwiftUI
This a migration from my MegaCalc repo (AppKit) to SwiftUI

This is still a Work in Progress as I continue to learn SwiftUI

### TODO
- Add UI tests
- Support Light and Dark Themes
- Make result TextField Readonly
- Show number of digits for A, B and Result
- Implement Algo delegates to show progress, duration
- Implement Cancel
- Improve UI to something like Neumorphic
- Refactor code using Clean Architecture Structure
- Implement Accessibility features with SwiftUI
- Add Unit tests for Algos

### Bugs
- No known issues...

### Notes
- Async/Await is is not supported on MacOS < 12. So not using it as I want to support Big Sur (11.6)


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
by Francois Robert 


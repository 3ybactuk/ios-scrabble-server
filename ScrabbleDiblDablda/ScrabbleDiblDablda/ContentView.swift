import SwiftUI

struct ContentView: View {
		
		@State var symbols: [[String]] = [
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
				["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
		]
		
    var body: some View {
				VStack(alignment: .leading, spacing: 0) {
						Text("Welcome to test of Scrabble game")
								.font(.largeTitle)
						Spacer()
								.frame(height: 64)
						VStack(spacing: 0) {
								ForEach(0..<15) { row in
										HStack(spacing: 0) {
												ForEach(0..<15) { col in
														TextField("", text: $symbols[row][col])
																.frame(width: 23, height: 23)
																.background(.tertiary)
																.cornerRadius(6)
																.padding(1)
												}
										}
								}
								Spacer()
										.frame(height: 24)
								Button {} label: {
										Text("Submit")
												.frame(width: 234, height: 34)
												.background(.orange)
												.foregroundColor(.white)
												.cornerRadius(12)
								}
						}
        }
    }
}

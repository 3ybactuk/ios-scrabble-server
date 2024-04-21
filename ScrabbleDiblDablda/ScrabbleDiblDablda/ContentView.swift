import SwiftUI

struct ContentView: View {
    @State private var symbols: [[String]] = Array(repeating: Array(repeating: "", count: 15), count: 15)
    @State private var lastWord = ""
    @State private var startCoordinate: (Int, Int)?
    @State private var endCoordinate: (Int, Int)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Welcome to the test of Scrabble game")
                .font(.largeTitle)
            Spacer().frame(height: 64)
            VStack(spacing: 0) {
                ForEach(0..<15, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<15, id: \.self) { col in
                            SingleCharacterTextField(text: Binding(
                                get: { symbols[row][col] },
                                set: { newValue in
                                    if !newValue.isEmpty {
                                        symbols[row][col] = newValue
                                        endCoordinate = (row, col)
                                        if startCoordinate == nil {
                                            startCoordinate = (row, col)
                                        }
                                    }
                                }
                            ))
                            .frame(width: 23, height: 23)
                            .background(.tertiary)
                            .cornerRadius(6)
                            .padding(1)
                        }
                    }
                }
                Spacer().frame(height: 24)
                Button("Submit", action: submitAction)
                    .frame(width: 234, height: 34)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }
    
    func submitAction() {
        guard let start = startCoordinate, let end = endCoordinate else {
            lastWord = "Nothing to submit"
            print(lastWord)
            return
        }
        
        let formedWord = WordProcessor.formWord(from: symbols, start: start, end: end, rowCount: 15, colCount: 15)
        lastWord = formedWord.isEmpty ? "Nothing to submit" : formedWord
        
        startCoordinate = nil
        endCoordinate = nil
        submitWordToServer(word: lastWord)
    }
    
    func submitWordToServer(word: String) {
        guard let url = URL(string: "http://127.0.0.1:8080/players/validateWord") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["word": word])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if let json = try? JSONDecoder().decode([String: String].self, from: data),
                   let status = json["status"] {
                    print("Server response: \(status)")
                } else {
                    print("Failed to decode response or word is not valid.")
                }
            }
        }.resume()
    }
}

struct SingleCharacterTextField: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.keyboardType = .asciiCapable
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: SingleCharacterTextField
        
        init(_ textField: SingleCharacterTextField) {
            self.parent = textField
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string).uppercased()
            
            if prospectiveText.count <= 1 && prospectiveText.allSatisfy(allowedCharacters.contains) {
                parent.text = prospectiveText
                return true
            }
            return false
        }
    }
}


import SwiftUI

struct ContentView: View {
    let radius: CGFloat = 100
    @State private var timeRemaining = 180
    @State var game = ModelData().game
    @State private var currentWordIndex = 0
    @State private var isGameOver = false
    @State private var showGameOverModal = false
    @State private var currentAnswer = ""
    @State private var score = 0
    @State private var noMoreSkips = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var sanitizedWord: String {
        currentAnswer
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .components(separatedBy: .punctuationCharacters).joined()
    }
    
    func restartGame() {
        isGameOver = false
        currentAnswer = ""
        score = 0
        noMoreSkips = false
        for i in game.indices {
            game[i].status = .NOT_STARTED
        }
        game[0].status = .CURRENT
    }
    
    func isTheAnswerCorrect() -> Bool {
        return game[currentWordIndex].answer == sanitizedWord
    }
    
    func moveToNextWord() {
        game[currentWordIndex].status = isTheAnswerCorrect() ? .CORRECT : .FAILED
        score += isTheAnswerCorrect() ? 1 : 0
        
        let possibleMoves = game.indices.filter { game[$0].status == .NOT_STARTED }
        if(possibleMoves.isEmpty) {
            // there are no more moves, finish the game
            isGameOver = true
            showGameOverModal = true
            return
        }
        currentWordIndex = currentWordIndex >= possibleMoves.last! ? possibleMoves.first! : possibleMoves.filter({ $0 > currentWordIndex }).first!
        currentAnswer = ""
    }
    var body: some View {
        NavigationStack {
                ZStack {
                    
                    LinearGradient(colors: [.green, .cyan, .cyan ,.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .ignoresSafeArea()

                    
                    ScrollView {

                    Text(game[currentWordIndex].question)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .bold()
                    
                    Text("\(timeRemaining)")
                        .font(.title3)
                    
                    ZStack {
                        ForEach(game) { word in
                            let index = word.id
                            let letter = word.letter
                            
                            let angle = 2 * .pi * CGFloat(index) / CGFloat(game.count)
                            let x = radius * cos(angle - .pi / 2)
                            let y = radius * sin(angle - .pi / 2)
                            
                            let statusColor = switch word.status {
                            case .CORRECT:
                                Color.green
                            case .NOT_STARTED:
                                Color.gray.opacity(0)
                            case .FAILED:
                                Color.red
                            case .CURRENT:
                                Color.blue
                            }
                            ZStack {
                                ZStack {
                                    Circle()
                                        .fill(statusColor.opacity(0.5))
                                        .frame(width: 20, height: 20)
    //                                    .shadow(color: .gray.opacity(0.3), radius: 2)
                                    Circle()
                                        .stroke(statusColor, lineWidth: word.status == .CURRENT ? 4 : 1)
                                        .frame(width: 20, height: 20)
                                    Text(letter)
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .position(x: x + radius, y: y + radius)
                                Text("\(score)")
                                    .font(.system(size: 48))
                            }
                        }
                    }
                    .onAppear {
                        game[currentWordIndex].status = .CURRENT
                    }
                    .onChange(of: currentWordIndex) {
                        game[currentWordIndex].status = .CURRENT
                    }
                    .frame(width: radius * 2, height: radius * 2)
                    
                    TAGTextField(placeholder: "Enter your answer", text: $currentAnswer)
                        .onSubmit {
                            moveToNextWord()
                        }
                        .padding([.top, .bottom])
                        .keyboardType(.alphabet)
                        .submitLabel(.done)
                    
                        
                    HStack {
                        TAGButton(text: "Check!", icon: "magnifyingglass") {
                            moveToNextWord()
                        }
                        .disabled(isGameOver || currentAnswer.isEmpty)
                        .alert("Game finished", isPresented: $showGameOverModal) {
                            Button("Play again") {
                                restartGame()
                            }
                        } message: {
                            Text("You score is \(score)")
                        }
                        
                        TAGButton(text: "Skip", icon: "arrow.forward") {
                            let possibleMoves = game.indices.filter { game[$0].status == .NOT_STARTED }
                            if(possibleMoves.isEmpty) {
                                isGameOver = true
                                showGameOverModal = true
                                return
                            }
                            if possibleMoves.count == 1 {
                                noMoreSkips = true
                                return
                            }
                            game[currentWordIndex].status = .NOT_STARTED
                            currentWordIndex = currentWordIndex >= possibleMoves.last! ? possibleMoves.first! : possibleMoves.filter({ $0 > currentWordIndex }).first!
                        }
                        .tint(.yellow)
                        .disabled(isGameOver || noMoreSkips)
                    }
                    .padding([.leading, .trailing])
                    .navigationTitle("The Alphabet game")
                    .onReceive(timer) { time in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            isGameOver  = true
                            showGameOverModal = true
                        }
                    }
                    
                }
                
                
                
            }
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct ContentView: View {
    let radius: CGFloat = 120
    @State var game = ModelData().game
    @State private var currentWordIndex = 0
    @State private var isGameOver = false
    @State private var showGameOverModal = false
    
    var body: some View {
        VStack(spacing: 20) {
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
                        Color.white
                    case .FAILED:
                        Color.red
                    case .CURRENT:
                        Color.blue
                    }
                    ZStack {
                        Circle()
                            .fill(statusColor.opacity(0.5))
                            .frame(width: 25, height: 25)
                            .shadow(color: .gray.opacity(0.3), radius: 2)
                        Circle()
                            .stroke(statusColor, lineWidth: word.status == .CURRENT ? 4 : 1)
                            .frame(width: 25, height: 25)
                        Text(letter)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .position(x: x + radius, y: y + radius)
                }
            }
            
            .onAppear {
                game[currentWordIndex].status = .CURRENT
            }
            .onChange(of: currentWordIndex) {
                game[currentWordIndex].status = .CURRENT
            }
            .frame(width: radius * 2, height: radius * 2)
            .padding()
            
            Text(game[currentWordIndex].question)
                .bold()
            Button("Check!") {
                game[currentWordIndex].status = .CORRECT
                
                
                guard let indexN = game.firstIndex(where: { $0.status == .NOT_STARTED }) else {
                    isGameOver = true
                    showGameOverModal = true
                    return
                }
            
                currentWordIndex = indexN
                
                if(currentWordIndex >= 25) {
                    isGameOver = true
                    showGameOverModal = true
                }
            }
            .disabled(isGameOver)
            .alert("Game finished!", isPresented: $showGameOverModal) {
                Button("OK", role: .cancel) {}
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct ContentView: View {
    let radius: CGFloat = 100
    
    @Bindable private var vm = AlphabetGameViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.green, .cyan, .cyan ,.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    Text(vm.game[vm.currentWordIndex].question)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .bold()
                    
                    ZStack {
                        ForEach(vm.game) { word in
                            let index = word.id
                            let letter = word.letter
                            
                            let angle = 2 * .pi * CGFloat(index) / CGFloat(vm.game.count)
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
                                    Circle()
                                        .stroke(statusColor, lineWidth: word.status == .CURRENT ? 4 : 1)
                                        .frame(width: 20, height: 20)
                                    Text(letter)
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .position(x: x + radius, y: y + radius)
                                Text("\(vm.score)")
                                    .font(.system(size: 48))
                            }
                        }
                    }
                    .onAppear {
                        vm.game[vm.currentWordIndex].status = .CURRENT
                    }
                    .onChange(of: vm.currentWordIndex) {
                        vm.game[vm.currentWordIndex].status = .CURRENT
                    }
                    .frame(width: radius * 2, height: radius * 2)
                    
                    TAGTextField(placeholder: "Enter your answer", text: $vm.currentAnswer)
                        .onSubmit {
                            vm.moveToNextWord()
                        }
                        .padding([.top, .bottom])
                        .keyboardType(.alphabet)
                        .submitLabel(.done)
                    
                    HStack {
                        TAGButton(text: "Check!", icon: "magnifyingglass") {
                            vm.moveToNextWord()
                        }
                        .disabled(vm.isGameOver || vm.currentAnswer.isEmpty)
                        .alert("Game finished", isPresented: $vm.showGameOverModal) {
                            Button("Play again") {
                                vm.restartGame()
                            }
                        } message: {
                            Text("You score is \(vm.score)")
                        }
                        TAGButton(text: "Skip", icon: "arrow.forward") {
                            let possibleMoves = vm.game.indices.filter { vm.game[$0].status == .NOT_STARTED }
                            if(possibleMoves.isEmpty) {
                                vm.isGameOver = true
                                vm.showGameOverModal = true
                                return
                            }
                            if possibleMoves.count == 1 {
                                vm.noMoreSkips = true
                                return
                            }
                            vm.game[vm.currentWordIndex].status = .NOT_STARTED
                            vm.currentWordIndex = vm.currentWordIndex >= possibleMoves.last! ? possibleMoves.first! : possibleMoves.filter({ $0 > vm.currentWordIndex }).first!
                        }
                        .tint(.yellow)
                        .disabled(vm.isGameOver || vm.noMoreSkips)
                    }
                    .padding([.leading, .trailing])
                    .navigationTitle("The Alphabet game")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

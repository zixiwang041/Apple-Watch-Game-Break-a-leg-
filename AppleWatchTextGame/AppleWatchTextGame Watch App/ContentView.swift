import SwiftUI


struct Level {
    let title: String
    let description: String
    let option1Image: String
    let option2Image: String
    let option1Score: Int
    let option2Score: Int
    let option1Text: String
    let option2Text: String
}


struct MarqueeText: View {
    let text: String
    let font: Font
    let duration: Double

    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var animationStarted = false

    var body: some View {
        GeometryReader { geo in
            let containerW = geo.size.width
            HStack {
                Text(text)
                    .font(font)
                    .foregroundColor(.green)
                    .background(
                        GeometryReader { textGeo in
                            Color.clear
                                .onAppear {
                                    textWidth = textGeo.size.width
                                    containerWidth = containerW
                                    if !animationStarted {
                                        animationStarted = true
                                        startAnimation()
                                    }
                                }
                        }
                    )
                    .offset(x: offset)
            }
            .clipped()
        }
        .frame(height: font == .footnote ? 20 : 16) // 根据字体调整高度
    }

    func startAnimation() {
        offset = containerWidth
        let totalDistance = textWidth + containerWidth
        withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
            offset = -textWidth
        }
    }
}

struct TerminalView: View {
    // 关卡内容数组，可自定义每一关剧情
    let levels: [Level] = [
        Level(
            title: "level 1",
            description: "Arrested for a bar fight.",
            option1Image: "1x1",
            option2Image: "1x2",
            option1Score: 1,
            option2Score: -1,
            option1Text: "Talk with others",
            option2Text: "Keep silent"
        ),
        Level(
            title: "level 2",
            description: "There are people next door who ask you loudly, ‘Where are you from?’.",
            option1Image: "2x1",
            option2Image: "1x2",
            option1Score: 1,
            option2Score: -1,
            option1Text: "Talk with them",
            option2Text: "Keep silent"
        ),
        Level(
            title: "level 3",
            description: "He said you killed a girl.",
            option1Image: "3x1",
            option2Image: "1x2",
            option1Score: 1,
            option2Score: -1,
            option1Text: "Denying that",
            option2Text: "Keep silent"
        ),
        Level(
            title: "level 4",
            description: "He said,‘Letme show you something.",
            option1Image: "4x1",
            option2Image: "1x2",
            option1Score: 1,
            option2Score: -1,
            option1Text: "Close to him",
            option2Text: "refused"
        ),
        Level(
            title: "level 5",
            description: "You can see his stiff face.",
            option1Image: "5x1",
            option2Image: "5x2",
            option1Score: 1,
            option2Score: -1,
            option1Text: "shout for help",
            option2Text: "hesitate"
        )
    ]
    // 当前关卡索引（从0开始）
    @State private var currentLevel = 0
    // 当前分数
    @State private var score = 0
    // 控制光标闪烁
    @State private var showCursor = true
    // 定时器
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 16) {
                // 判断是否所有关卡已完成
                if currentLevel < levels.count {
                    let level = levels[currentLevel]
                    // 关卡标题
                    Text(level.title)
                        .font(.headline)
                        .foregroundColor(.green)
                    // 分数显示
                    Text("Score：\(score)")
                        .font(.footnote)
                        .foregroundColor(.green)
                    // 关卡描述
                    MarqueeText(text: level.description, font: .footnote, duration: 6)
                    // 两个图片选项
                    HStack(spacing: 24) {
                        VStack {
                            Image(level.option1Image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .onTapGesture {
                                    // 选项1：分数变化并进入下一关
                                    score += level.option1Score
                                    currentLevel += 1
                                }
                            // 选项1描述
                            Text(level.option1Text)
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        VStack {
                            Image(level.option2Image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .onTapGesture {
                                    // 选项2：分数变化并进入下一关
                                    score += level.option2Score
                                    currentLevel += 1
                                }
                            // 选项2描述
                            Text(level.option2Text)
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.top, 8)
                    // 闪烁光标和提示
                    HStack(spacing: 0) {
                        if showCursor {
                            Text(">")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(Color.green)
                                .opacity(0.8)
                        } else {
                            Text(" ")
                                .font(.system(.body, design: .monospaced))
                        }
                        Text("Choose your action")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(Color.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    // 结局页面，根据分数显示不同结局
                    VStack(spacing: 16) {
                        if score <= 2 {
                            Image("y1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                            Text("Your score：\(score)，You died.")
                                .font(.footnote)
                                .foregroundColor(.green)
                        } else {
                            Image("1x1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                            Text("Your score：\(score)，survived.")
                                .font(.footnote)
                                .foregroundColor(.green)
                        }
                        
                        HStack(spacing: 0) {
                            if showCursor {
                                Text(">")
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(Color.green)
                                    .opacity(0.8)
                            } else {
                                Text(" ")
                                    .font(.system(.body, design: .monospaced))
                            }
                            Text("")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(Color.green)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
        }
        // 定时器控制光标闪烁
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                showCursor.toggle()
            }
        }
    }
}

struct TerminalView_Previews: PreviewProvider {
    static var previews: some View {
        TerminalView()
    }
}


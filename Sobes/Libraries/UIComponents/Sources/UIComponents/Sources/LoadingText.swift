import SwiftUI

public struct LoadingText: View {
    var text: String
    var color: Color = .black

    @State var dotsCount = 0
    
    public init(text: String, color: Color = .black, dotsCount: Int = 0) {
        self.text = text
        self.color = color
        self.dotsCount = dotsCount
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Group {
                let textComponent = Text(text).foregroundColor(color)
                let dot1Component = Text(".").foregroundColor(dotsCount > 0 ? color : .clear)
                let dot2Component = Text(".").foregroundColor(dotsCount > 1 ? color : .clear)
                let dot3Component = Text(".").foregroundColor(dotsCount > 2 ? color : .clear)
                
                textComponent + dot1Component + dot2Component + dot3Component
            }
            .font(Fonts.main)
        }
        .animation(.easeOut(duration: 0.2), value: dotsCount)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()) { _ in dotsAnimation() }
        .onAppear(perform: dotsAnimation)
    }

    func dotsAnimation() {
        withAnimation {
            dotsCount = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                dotsCount = 1
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation {
                dotsCount = 2
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation {
                dotsCount = 3
            }
        }
    }
}

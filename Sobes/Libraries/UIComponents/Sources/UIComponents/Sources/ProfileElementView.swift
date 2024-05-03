import SwiftUI
import Types
import WrappingHStack

public struct ProfileElementView: View {
    
    private let profile: Profile
    private var onChatTapped: () -> Void
    
    public init(profile: Profile, onChatTapped: @escaping () -> Void) {
        self.profile = profile
        self.onChatTapped = onChatTapped
    }
    
    func arrayOfStrings(array: [Professions]) -> [String] {
        var a: [String] = []
        for i in array {
            a.append(i.rawValue)
        }
        return a
    }
    
    func arrayOfStringsComp(array: [Companies]) -> [String] {
        var a: [String] = []
        for i in array {
            a.append(i.rawValue)
        }
        return a
    }
    
    func getRawValues() -> [String] {
        var array: [String] = []
        array.append(profile.level.rawValue)
        for profession in profile.professions {
            array.append(profession.rawValue)
        }
        for company in profile.companies {
            array.append(company.rawValue)
        }
        return array
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: Constants.elementPadding) {
            VStack(alignment: .leading) {
                Text(profile.name)
                    .font(Fonts.main)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                WrappingHStack(getRawValues(), id: \.self, spacing: .constant(5), lineSpacing: 5) { elem in
                    if elem != "" {
                        Text("#\(elem)")
                            .font(Font.system(size: 10))
                            .foregroundColor(Color("grey", bundle: .module))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {onChatTapped()}) {
                Image(systemName: "message.fill")
                    .accentColor(.black)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .foregroundColor(Color(.light))
        }
    }
    
    @ViewBuilder
    func bubble(profileData: String) -> some View {
        if profileData != "" {
            Text(profileData)
                .font(Font.system(size: 10))
                .foregroundColor(.black)
                .lineLimit(1)
                .padding(5)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .stroke(.black, lineWidth: Constants.strokeWidth)
                }
        }
    }
}


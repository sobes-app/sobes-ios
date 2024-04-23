import UIKit

public struct FavIcon {

    public enum Size: Int, CaseIterable {
        case s = 16,
             m = 32,
             l = 64,
             xl = 128,
             xxl = 256,
             xxxl = 512
    }

    public init(_ domain: String) {
        self.domain = domain
    }

    public subscript(_ size: Size) -> String {
        "https://www.google.com/s2/favicons?sz=\(size.rawValue)&domain=\(domain)"
    }

    private let domain: String

}

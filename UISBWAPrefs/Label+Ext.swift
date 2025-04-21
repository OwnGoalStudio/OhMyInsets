import SwiftUI

struct LabelWithImageIcon: View {
    let title: String
    let systemImage: String

    init(_ title: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
    }

    var body: some View {
        Label(title: {
            Text(self.title)
                .foregroundColor(.primary)
        }, icon: {
            Image(systemName: self.systemImage)
                .renderingMode(.template)
        } )
    }
}

struct LabelWithSubtitle: View {
    let title: String
    let subtitle: String
    let systemImage: String

    init(_ title: String, subtitle: String, systemImage: String) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
    }

    var vStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    var body: some View {
        Label {
            vStack.padding(.vertical, 4)
        } icon: {
            Image(systemName: systemImage)
        }
    }
}

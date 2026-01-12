import SwiftUI

struct ProductAsyncImage: View {
    let url: URL?

    var body: some View {
        ZStack {
            Color.secondary.opacity(0.1)
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()

                case .success(let image):
                    image
                        .resizable()

                case .failure:
                    Image(systemName: "photo")

                @unknown default:
                    Image(systemName: "photo")
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

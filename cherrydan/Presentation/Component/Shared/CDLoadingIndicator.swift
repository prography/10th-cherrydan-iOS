import SwiftUI

struct CDLoadingIndicator: View {
    let isFullScreen: Bool
    
    init(isFullScreen: Bool = true){
        self.isFullScreen = isFullScreen
    }
    
    var body: some View {
        if isFullScreen {
            ProgressView()
                .tint(.gray70)
                .scaleEffect(1.2)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else {
            ProgressView()
                .tint(.gray70)
                .scaleEffect(1.2)
        }
    }
}

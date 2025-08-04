import SwiftUI

struct SelectRegionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title: "지역선택")
                .padding(.horizontal, 16)
            
            RegionListView { regionGroup, subRegion in
                viewModel.selectRegion(regionGroup, subRegion)
                dismiss()
            }
        }
    }
}

#Preview {
    SelectRegionView(viewModel: HomeViewModel())
}

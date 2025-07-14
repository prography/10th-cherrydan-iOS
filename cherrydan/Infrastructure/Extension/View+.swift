import SwiftUI

extension View {
    func underline(_ color: Color = .gray5, width: CGFloat = 1) -> some View {
        modifier(UnderlineModifier(color: color, lineHeight: width))
    }
    
    func presentPopup(isPresented: Binding<Bool>, data: PopupType?) -> some View {
        modifier(PopupViewModifier(isPresented: isPresented, popupType: data))
    }
    
    func swipeBackDisabled(_ isDisabled: Bool) -> some View {
        modifier(SwipeBackDisabledViewModifier(isDisabled: isDisabled))
    }
    
    /// Infinite scrolling을 위한 ViewModifier
    /// - Parameters:
    ///   - hasMoreData: 더 많은 데이터가 있는지 여부
    ///   - isLoading: 현재 로딩 중인지 여부
    ///   - onLoadMore: 더 많은 데이터를 로드하는 액션
    func infiniteScrolling(
        hasMoreData: Bool,
        isLoading: Bool,
        onLoadMore: @escaping () -> Void
    ) -> some View {
        modifier(InfiniteScrollingModifier(
            hasMoreData: hasMoreData,
            isLoading: isLoading,
            onLoadMore: onLoadMore
        ))
    }
}

// MARK: - InfiniteScrollingModifier

struct InfiniteScrollingModifier: ViewModifier {
    let hasMoreData: Bool
    let isLoading: Bool
    let onLoadMore: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if hasMoreData && !isLoading {
                    onLoadMore()
                }
            }
    }
}

// MARK: - ScrollViewReader Extension

extension View {
    /// 스크롤 위치 감지를 위한 invisible view 추가
    /// - Parameter onAppear: 해당 뷰가 나타날 때 호출될 액션
    func onScrollToBottom(perform action: @escaping () -> Void) -> some View {
        self.background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scrollView")).minY)
            }
        )
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
            // 스크롤 위치가 하단에 가까워지면 액션 실행
            if offset < 100 {
                action()
            }
        }
    }
}

// MARK: - ScrollOffsetPreferenceKey

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

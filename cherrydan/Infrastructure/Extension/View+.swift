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
    
    /// 블로그 방식의 무한 스크롤을 위한 ViewModifier
    /// LazyVStack과 onAppear를 사용하여 마지막 아이템이 나타날 때 다음 페이지 로드
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
    
    /// 뷰가 메모리에 로드될 경우 수행되게 하는 ViewDidLoad 함수
    /// UIKit에는 viewDidLoad 함수가 있지만 SwiftUI에는 존재하지 않는다.
    /// onAppear을 사용하여 직접 viewDidLoad를 수정자로 구현한다.
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
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

// MARK: - ViewDidLoadModifier

/// 뷰가 한번 로드되었을 때를 감지하여 액션을 수행하게 하는 ViewDidLoad 수정자
struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad: Bool = false
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}



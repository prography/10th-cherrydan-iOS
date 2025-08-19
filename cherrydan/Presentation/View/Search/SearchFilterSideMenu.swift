import SwiftUI

struct SearchFilterSideMenu: View {
    @ObservedObject var viewModel: SearchViewModel
    @Binding var isPresented: Bool
    @State private var expandedSections: Set<String> = []
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea(.all, edges: .all)
                .onTapGesture {
                    isPresented = false
                }
            
            HStack {
                Spacer()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("필터")
                            .font(.m3b)
                            .foregroundStyle(.gray9)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.resetFilters()
                        }) {
                            Image("return")
                                .padding(8)
                        }
                        
                        Button(action: {
                            isPresented = false
                        }) {
                            Image("close")
                                .padding(8)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .padding(.top, 44)
                    
                    Divider()
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            filterSection(
                                title: "지역명",
                                sectionKey: "region",
                                content: {
                                    regionFilterContent
                                }
                            )
                            
                            // 공고 유형
                            filterSection(
                                title: "공고 유형",
                                sectionKey: "announcement",
                                content: {
                                    localCategoryFilterContent
                                }
                            )
                            
                            // 제품(배송형)
                            filterSection(
                                title: "제품(배송형)",
                                sectionKey: "product",
                                content: {
                                    productCategoryFilterContent
                                }
                            )
                            
                            // 기자단
                            filterSection(
                                title: "기자단",
                                sectionKey: "reporter",
                                content: {
                                    reporterFilterContent
                                }
                            )
                            
                            // SNS 플랫폼
                            filterSection(
                                title: "SNS 플랫폼",
                                sectionKey: "sns",
                                content: {
                                    snsPlatformFilterContent
                                }
                            )
                            
                            // 체험단 플랫폼
                            filterSection(
                                title: "체험단 플랫폼",
                                sectionKey: "campaign",
                                content: {
                                    campaignPlatformFilterContent
                                }
                            )
                            
                            // 마감일
                            filterSection(
                                title: "마감일",
                                sectionKey: "deadline",
                                content: {
                                    deadlineFilterContent
                                }
                            )
                        }
                        .padding(.bottom, 34) // SafeArea bottom 고려
                    }
                }
                .frame(width: 280)
                .background(.white)
                .cornerRadius(0)
                .shadow(radius: 10)
                .ignoresSafeArea(.all, edges: .all)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
    
    private func filterSection<Content: View>(
        title: String,
        sectionKey: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            Button(action: {
                if expandedSections.contains(sectionKey) {
                    expandedSections.remove(sectionKey)
                } else {
                    expandedSections.insert(sectionKey)
                }
            }) {
                HStack {
                    Text(title)
                        .font(.m4r)
                        .foregroundStyle(.gray9)
                    
                    Spacer()
                    
                    Image("chevron_down")
                        .rotationEffect(.degrees(expandedSections.contains(sectionKey) ? 180 : 0))
                        .animation(.fastEaseInOut, value: expandedSections.contains(sectionKey))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            
            if expandedSections.contains(sectionKey) {
                content()
                    .transition(.opacity)
                    .background(.gray1)
            }
            
            Divider()
        }
        .animation(.fastEaseInOut, value: expandedSections.contains(sectionKey))
    }
    
    private var regionFilterContent: some View {
        VStack(spacing: 0) {
            // 지역 그룹
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                filterButton("전체", isSelected: viewModel.selectedRegionGroups.isEmpty) {
                    viewModel.updateRegionGroups([])
                }
                
                ForEach(RegionGroup.allCases, id: \.self) { region in
                    filterButton(region.displayName, isSelected: viewModel.selectedRegionGroups.contains(region)) {
                        toggleSelection(region, in: viewModel.selectedRegionGroups) { newSelection in
                            viewModel.updateRegionGroups(newSelection)
                        }
                    }
                }
            }
        }
    }
    
    private var localCategoryFilterContent: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                filterButton("전체", isSelected: viewModel.selectedLocalCategories.isEmpty) {
                    viewModel.updateLocalCategories([])
                }
                
                ForEach(LocalCategory.allCases, id: \.self) { category in
                    filterButton(category.displayName, isSelected: viewModel.selectedLocalCategories.contains(category)) {
                        toggleSelection(category, in: viewModel.selectedLocalCategories) { newSelection in
                            viewModel.updateLocalCategories(newSelection)
                        }
                    }
                }
            }
        }
    }
    
    private var productCategoryFilterContent: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                filterButton("전체", isSelected: viewModel.selectedProductCategories.isEmpty) {
                    viewModel.updateProductCategories([])
                }
                
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    filterButton(category.displayName, isSelected: viewModel.selectedProductCategories.contains(category)) {
                        toggleSelection(category, in: viewModel.selectedProductCategories) { newSelection in
                            viewModel.updateProductCategories(newSelection)
                        }
                    }
                }
            }
        }
    }
    
    private var reporterFilterContent: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                filterButton("전체", isSelected: true) {}
            }
        }
    }
    
    private var snsPlatformFilterContent: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                filterButton("전체", isSelected: viewModel.selectedSnsPlatforms.isEmpty) {
                    viewModel.updateSnsPlatforms([])
                }
                
                ForEach(SNSPlatformType.allCases, id: \.self) { platform in
                    filterButton(platform.displayName, isSelected: viewModel.selectedSnsPlatforms.contains(platform)) {
                        toggleSelection(platform, in: viewModel.selectedSnsPlatforms) { newSelection in
                            viewModel.updateSnsPlatforms(newSelection)
                        }
                    }
                }
            }
        }
    }
    
    private var campaignPlatformFilterContent: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                filterButton("전체", isSelected: viewModel.selectedCampaignPlatforms.isEmpty) {
                    viewModel.updateCampaignPlatforms([])
                }
                
                ForEach(viewModel.campaignPlatforms, id: \.self) { platform in
                    filterButton(platform.siteNameKr, isSelected: viewModel.selectedCampaignPlatforms.contains(platform)) {
                        toggleSelection(platform, in: viewModel.selectedCampaignPlatforms) { newSelection in
                            viewModel.updateCampaignPlatforms(newSelection)
                        }
                    }
                }
            }
        }
    }
    
    private var deadlineFilterContent: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                datePickerField(
                    date: viewModel.selectedStartDate,
                    isEnd: false,
                    action: {
                        viewModel.showDatePickerForStartDate()
                    }
                )
                
                Text("~")
                    .font(.m5r)
                    .foregroundStyle(.gray9)
                
                datePickerField(
                    date: viewModel.selectedEndDate,
                    isEnd: true,
                    action: {
                        viewModel.showDatePickerForEndDate()
                    }
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            
            if viewModel.showDatePicker {
                Button(action: {
                    viewModel.confirmDateSelection()
                }) {
                    Text("확인")
                        .font(.m4b)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(.mPink3)
                }
                .padding(.bottom, 20)
                
                HStack(spacing: 0) {
                    Picker("", selection: $viewModel.selectedYear) {
                        ForEach(viewModel.years, id: \.self) { year in
                            Text("\(String(year))년")
                                .tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    
                    Picker("Month", selection: $viewModel.selectedMonth) {
                        ForEach(viewModel.months, id: \.self) { month in
                            Text("\(month)월")
                                .tag(month)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    
                    Picker("Day", selection: $viewModel.selectedDay) {
                        ForEach(viewModel.days, id: \.self) { day in
                            Text("\(day)일")
                                .tag(day)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 20)
            }
        }
    }
    
    private func filterButton(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 0) {
                Image("check_circle_\(isSelected ? "filled" : "empty")")
                    .padding(.leading, 8)
                
                Text(title)
                    .font(.m5r)
                    .foregroundStyle(.gray9)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 52, alignment: .center)
            .background(.gray1)
        }
        .animation(.fastEaseInOut, value: isSelected)
    }
    
    @ViewBuilder
    private func datePickerField(date: Date?, isEnd: Bool, action: @escaping () -> Void) -> some View {
        var isFocusing: Bool {
            if isEnd {
                viewModel.selectedEndDate != nil
            } else {
                viewModel.selectedStartDate != nil
            }
        }
        
        Button(action: action) {
            HStack(spacing: 4) {
                if let date {
                    Text(DateFormatter.yyyyMMdd.string(from: date))
                        .font(.m5r)
                        .foregroundStyle(isFocusing ? .mPink3 : .gray9)
                } else {
                    Text(DateFormatter.yyyyMMdd.string(from: Date()))
                        .font(.m5r)
                        .foregroundStyle(isFocusing ? .mPink3 : .gray5)
                }
                
                Image("calendar")
                    .renderingMode(.template)
                    .foregroundStyle(isFocusing ? .mPink3 : .gray9)
            }
            .padding(.horizontal, 8)
            .frame(height: 48)
        }
    }
    
    private func toggleSelection<T: Hashable>(_ item: T, in array: [T], updateHandler: @escaping ([T]) -> Void) {
        var newSelection = array
        if let index = newSelection.firstIndex(of: item) {
            newSelection.remove(at: index)
        } else {
            newSelection.append(item)
        }
        updateHandler(newSelection)
    }
} 

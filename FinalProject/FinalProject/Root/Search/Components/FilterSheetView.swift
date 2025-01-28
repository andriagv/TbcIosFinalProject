//
//  FilterSheetView.swift
//  FinalProject
//
//  Created by Apple on 16.01.25.
//

import SwiftUI

struct FilterSheetView: View {
    @EnvironmentObject var viewModel: SearchPageViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(.filterSheetBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                headerView
                mainFilterView
            }
        }
    }
    
    private var mainFilterView: some View {
        ScrollView {
            VStack(spacing: 16) {
                matchingEventsView
                categoryPickerView
                dateRangeView
                sortingPickerView
                freeEventsToggleView
                clearFiltersView
            }
        }
        .padding(.vertical, 8)
    }
    
    private var headerView: some View {
        HStack {
            Text("Filters".localized())
                .font(.dateNumberFont(size: 26))
                .foregroundColor(.primary)
            Spacer()
            Button(action: {
                isPresented = false
            }) {
                Text("Close".localized())
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .cornerRadius(16)
                    .font(.titleFontBold(size: 20))
            }
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    private var matchingEventsView: some View {
        Text("Matching events: \(viewModel.events.count)")
            .foregroundColor(.secondary)
            .padding(.horizontal, 16)
            .font(.titleFontBold(size: 20))
    }
    
    private var categoryPickerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category".localized())
                .font(.dateNumberFont(size: 22))
                .foregroundColor(.primary)
            
            Picker("Category".localized(), selection: $viewModel.selectedCategory) {
                Text("All".localized()).tag(EventType?.none)
                ForEach(EventType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type as EventType?)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        
    }
    
    private var dateRangeView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date Range".localized())
                .foregroundColor(.primary)
                .font(.dateNumberFont(size: 22))
            
            DatePicker("Start Date".localized(), selection: $viewModel.startDate, displayedComponents: [.date])
                .datePickerStyle(.compact)
                .font(.titleFontBold(size: 20))
            Divider()
            DatePicker("End Date".localized(), selection: $viewModel.endDate, displayedComponents: [.date])
                .datePickerStyle(.compact)
                .font(.titleFontBold(size: 20))
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private var sortingPickerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sort by Price".localized())
                .font(.dateNumberFont(size: 22))
                .foregroundColor(.primary)
            
            Picker("Sort Option".localized(), selection: $viewModel.sortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private var freeEventsToggleView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Show Free Events".localized())
                .font(.dateNumberFont(size: 22))
                .foregroundColor(.primary)
            
            Toggle(isOn: $viewModel.showFreeEventsOnly) {
                Text("Only Free Events".localized())
                    .font(.titleFontBold(size: 20))
                    .foregroundColor(.primary)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }

    
    private var clearFiltersView: some View {
        Button(action: {
            
            viewModel.clearFilters()
        }) {
            Text("Clear Filters".localized())
                .font(.titleFontBold(size: 20))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.red)
                .cornerRadius(32)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}


#Preview {
    SearchView { _ in }
}

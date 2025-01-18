//
//  FilterSheetView.swift
//  FinalProject
//
//  Created by Apple on 16.01.25.
//

import SwiftUI

struct FilterSheetView: View {
    @StateObject var viewModel = SearchPageViewModel()
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
                clearFiltersView
            }
        }
        .padding(.vertical, 8)
    }
    
    private var headerView: some View {
        HStack {
            Text("Filters")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.primary)
            Spacer()
            Button(action: {
                isPresented = false
            }) {
                Text("Close")
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .cornerRadius(16)
            }
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    private var matchingEventsView: some View {
        Text("Matching events: \(viewModel.filteredEvents.count)")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.secondary)
            .padding(.horizontal, 16)
    }
    
    private var categoryPickerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(.headline)
                .foregroundColor(.primary)
            
            Picker("Category", selection: $viewModel.selectedCategory) {
                Text("All").tag(EventType?.none)
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
            Text("Date Range")
                .font(.headline)
                .foregroundColor(.primary)
            
            DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: [.date])
                .datePickerStyle(.compact)
            Divider()
            DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: [.date])
                .datePickerStyle(.compact)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private var sortingPickerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sort by Price")
                .font(.headline)
                .foregroundColor(.primary)
            
            Picker("Sort Option", selection: $viewModel.sortOption) {
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
    
    private var clearFiltersView: some View {
        Button(action: {
            //viewModel.clearFilters()
        }) {
            Text("Clear Filters")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.red)
                .cornerRadius(32)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

//#Preview {
//    FilterSheetView(isPresented: .constant(true))
//}

#Preview {
    SearchView()
}

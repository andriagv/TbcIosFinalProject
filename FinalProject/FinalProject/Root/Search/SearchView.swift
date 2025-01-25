//
//  SearchView.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchPageViewModel()
    @State private var isFilterSheetPresented = false
    @State private var isSmalCardPresented = true
    
    var onEventSelected: (Event) -> Void
    
    var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        Text("Find a campsite easily")
                            .opacity(0.5)
                            .font(.custom("SourGummy-Bold", size: 30))
                        headerView
                        
                        if viewModel.networkError {
                            networkErrorView
                        } else if viewModel.isLoading && viewModel.events.isEmpty {
                            loadingView
                        } else {
                            contentView
                        }
                    }
                    .onAppear {
                        viewModel.fetchEvents()
                    }
                    .sheet(isPresented: $isFilterSheetPresented) {
                        FilterSheetView(isPresented: $isFilterSheetPresented)
                            .environmentObject(viewModel)
                            .presentationDetents([.fraction(0.8)])
                            .presentationDragIndicator(.visible)
                    }
                }
                .background(.pageBack)
            }
    }
    
    private var headerView: some View {
        HStack {
            TextField("Search events...", text: $viewModel.searchText)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            
            Button {
                isFilterSheetPresented.toggle()
            } label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Button {
                isSmalCardPresented.toggle()
            } label: {
                Image(systemName: isSmalCardPresented ? "lineweight" : "tablecells.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("მონაცემების ჩატვირთვა...")
                .foregroundColor(.secondary)
                .padding(.top)
        }
    }
    
    private var networkErrorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("ინტერნეტთან კავშირი ვერ მყარდება")
                .font(.headline)
            
            Text("გთხოვთ შეამოწმოთ თქვენი ინტერნეტ კავშირი")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                viewModel.fetchEvents()
            } label: {
                Text("ხელახლა ცდა")
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
    }
    
    private var contentView: some View {
        ScrollView {
            if viewModel.filteredEvents.isEmpty {
                emptyStateView
            } else {
                if isSmalCardPresented {
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 140, maximum: 200))
                        ],
                        spacing: 20
                    ) {
                        ForEach(viewModel.filteredEvents) { event in
                            Button {
                                onEventSelected(event)
                            } label: {
                                CartSmallView(event: event)
                                    .environmentObject(viewModel)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } else {
                    LazyVStack(spacing: 30) {
                        ForEach(viewModel.filteredEvents) { event in
                            Button {
                                onEventSelected(event)
                            } label: {
                                CartBigView(event: event)
                                    .environmentObject(viewModel)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .refreshable {
            viewModel.fetchEvents()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("ღონისძიებები ვერ მოიძებნა")
                .font(.headline)
            
            Text("სცადეთ სხვა საძიებო სიტყვა ან ფილტრი")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                viewModel.clearFilters()
            } label: {
                Text("ფილტრების გასუფთავება")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}


#Preview {
    SearchView { _ in }
}

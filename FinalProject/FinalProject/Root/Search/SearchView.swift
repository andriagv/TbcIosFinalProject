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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    TextField("Search events...", text: $viewModel.searchText)
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    // სასურველია, რომ ყოველ ცვლილებაზე მოვახდინოთ გადაფილტრვა
                    //                        .onChange(of: viewModel.searchText) { _ in
                    //                            viewModel.fetchAndFilterEvents()
                    //                        }
                    
                    Button {
                        isFilterSheetPresented.toggle()
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 150, maximum: 200))
                        ],
                        spacing: 20
                    ) {
                        ForEach(viewModel.filteredEvents) { event in
                            CartView(event: event)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Search")
            .sheet(isPresented: $isFilterSheetPresented) {
                FilterSheetView(isPresented: $isFilterSheetPresented)
                    .environmentObject(viewModel)
            }
            .background(.pageBack)
        }
    }
}

#Preview {
    TabBarController()
}

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
    
    var body: some View {
        NavigationView {
            VStack() {
                HStack {
                    HStack {
                        TextField("Search events...", text: $viewModel.searchText)
                        Spacer()
                        Button {
                            isFilterSheetPresented.toggle()
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    // სასურველია, რომ ყოველ ცვლილებაზე მოვახდინოთ გადაფილტრვა
                    //                        .onChange(of: viewModel.searchText) { _ in
                    //                            viewModel.fetchAndFilterEvents()
                    //                        }
                    
                    
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
                ScrollView {
                    VStack(spacing: 20) {
                        if isSmalCardPresented {
                            LazyVGrid(
                                columns: [
                                    GridItem(.adaptive(minimum: 140, maximum: 200))
                                ],
                                spacing: 20
                            ) {
                                ForEach(viewModel.filteredEvents) { event in
                                    CartSmallView(event: event)
                                }
                            }
                        } else {
                            LazyVStack(spacing: 140) {
                                ForEach(viewModel.filteredEvents) { event in
                                    CartBigView(event: event)
                                }
                            }
                            .padding(.top, 50)
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
    SearchView()
}

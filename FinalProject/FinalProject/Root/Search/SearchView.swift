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
            ScrollView {
                Text("Find a campsite easily")
                    .opacity(0.5)
                    .font(.custom("SourGummy-Bold", size: 30))
                VStack(spacing: 20) {
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
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        
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
                    
                    if isSmalCardPresented {
                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 140, maximum: 200))
                            ],
                            spacing: 20
                        ) {
                            ForEach(viewModel.filteredEvents) { event in
                                NavigationLink(destination: EventDetailsView(event: event)) {
                                    CartSmallView(event: event)
                                }
                            }
                        }
                    } else {
                        LazyVStack(spacing: 30) {
                            ForEach(viewModel.filteredEvents) { event in
                                NavigationLink(destination: EventDetailsView(event: event)) {
                                    CartBigView(event: event)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            //.navigationTitle("Search")
            .font(.custom("SourGummy-Bold", size: 20))
            .sheet(isPresented: $isFilterSheetPresented) {
                FilterSheetView(isPresented: $isFilterSheetPresented)
                    .environmentObject(viewModel)
                    .presentationDetents([.fraction(0.8)])
                    .presentationDragIndicator(.visible)
            }
            .background(.pageBack)
        }
    }
}


#Preview {
    SearchView()
}

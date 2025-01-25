import SwiftUI

struct LikesPageView: View {
    @StateObject private var viewModel = LikesViewModel()
    @ObservedObject var languageManager = LanguageManager.shared
    
    /// ამ closure-ს გადასცემს მშობელი (TabBarController),
    /// რათა წამოვიდეს UIKit push, როდესაც იუზერი ირჩევს event-ს.
    var onEventSelected: (Event) -> Void
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.likedEvents) { event in
                        // თითოეული ბარათი -> onTap-ზე გამოვიძახოთ onEventSelected
                        LikedEventCard(
                            event: event,
                            onUnlike: {
                                Task {
                                    try? await viewModel.unlikeEvent(event)
                                }
                            },
                            onCardTap: {
                                onEventSelected(event)
                            }
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 16)
            }
        }
        .background(.pageBack)
        .overlay(Group {
            if viewModel.likedEvents.isEmpty && !viewModel.isLoading {
                EmptyStateView()
            }
        })
        .id(languageManager.selectedLanguage)
        .onAppear {
            // თუ გჭირდებათ პირველად ჩატვირთვა
            //viewModel.fetchLikedEvents()
        }
    }
}

// Preview-ში უბრალოდ dummy closure:
#Preview {
    LikesPageView(onEventSelected: { _ in })
}

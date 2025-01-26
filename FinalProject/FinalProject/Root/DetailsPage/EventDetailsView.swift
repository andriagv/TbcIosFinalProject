//
//  EventDetailsView.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//


import SwiftUI

struct EventDetailsView: View {
    @StateObject private var viewModel: EventDetailsViewModel
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset: CGFloat = 0
    
    init(event: Event) {
        _viewModel = StateObject(wrappedValue: EventDetailsViewModel(event: event))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                photoSectionWithLocationOverlay
                thumbnailStrip
                eventDetails
                bookNowSection
            }
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation.width
                }
                .onEnded { value in
                    if value.translation.width > 100 {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        )
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .background(.pageBack)
        .onReceive(LikeStatusMonitor.shared.$lastUpdated) { _ in
            viewModel.checkLikeStatus()
        }
        .onAppear {
            viewModel.checkLikeStatus()
        }
        .sheet(isPresented: $viewModel.showQRCode, onDismiss: {
            viewModel.updateSeatsLocally()
        }) {
            QRCodeView(event: viewModel.event)
        }
    }
    
    private var photoSectionWithLocationOverlay: some View {
        ZStack(alignment: .top) {
            TabView(selection: $viewModel.currentPhotoIndex) {
                ForEach(viewModel.event.photos.indices, id: \.self) { index in
                    Image(viewModel.event.photos[index])
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 400)
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    SmallButtonView(imageSystemName: "arrow.left", fontSize: 30)
                        .padding(.leading, 16)
                        .foregroundStyle(.white)
                        .opacity(0.8)
                }
                Spacer()
                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    SmallButtonView(
                        imageSystemName: viewModel.isFavorite ? "heart.fill" : "heart",
                        fontSize: 30
                    )
                    .foregroundStyle(viewModel.isFavorite ? Color.red : Color.white)
                    .padding(.trailing, 16)
                }
            }
            .padding(.top, 64)
        }
    }
    
    private var thumbnailStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.event.photos.indices, id: \.self) { index in
                    Image(viewModel.event.photos[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.currentPhotoIndex == index ? .blue : .clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            viewModel.currentPhotoIndex = index
                        }
                }
            }
            .padding()
        }
    }
    
    private var eventDetails: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.event.name)
                    .font(.dateNumberFont(size: 30))
                
                if let discountedPrice = viewModel.event.price.discountedPrice {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("$\(discountedPrice, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                        
                        Text("$\(viewModel.event.price.startPrice, specifier: "%.2f")")
                            .font(.subheadline)
                            .strikethrough()
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("$\(viewModel.event.price.startPrice, specifier: "%.2f")")
                        .font(.dateNumberFont(size: 23))
                }
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                InfoCard(icon: "calendar", title: "Date", value: viewModel.formatDateRange())
                InfoCard(icon: "mappin", title: "Location", value: viewModel.formatLocation())
                InfoCard(icon: "person.2.fill", title: "Availability", value: "\(viewModel.currentSeats) spots left")
                InfoCard(icon: "clock", title: "Duration", value: viewModel.formatDuration())
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("About".localized())
                    .font(.dateNumberFont(size: 25))
                Text(viewModel.event.description)
                    .foregroundStyle(.secondary)
                    .font(.titleFontBold(size: 20))
            }
            
            if let tags = viewModel.event.tags, !tags.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tags".localized())
                        .font(.dateNumberFont(size: 25))
                    
                    FlowLayout(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .font(.titleFontBold(size: 15))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.secondary.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private var bookNowSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    if let discountedPrice = viewModel.event.price.discountedPrice {
                        Text("$\(viewModel.event.price.startPrice, specifier: "%.2f")")
                            .strikethrough()
                            .foregroundColor(.secondary)
                        Text("$\(discountedPrice, specifier: "%.2f")")
                            .font(.dateNumberFont(size: 25))
                            .foregroundColor(.blue)
                    } else {
                        Text("$\(viewModel.event.price.startPrice, specifier: "%.2f")")
                            .font(.dateNumberFont(size: 25))
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
                
                Button(action: {
                    if viewModel.currentSeats > 0 {
                        viewModel.showBookingConfirmation = true
                    } else {
                        viewModel.showNoSeatsAlert = true
                    }
                }) {
                    Text("Book now".localized())
                        .font(.dateNumberFont(size: 25))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(viewModel.currentSeats > 0 ? Color.blue : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.systemGray5)),
            alignment: .top
        )
        .alert("No Seats Available", isPresented: $viewModel.showNoSeatsAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Sorry, this event is fully booked.")
        }
        .alert("Confirm Booking", isPresented: $viewModel.showBookingConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Book", role: .none) {
                if viewModel.currentSeats > 0 {
                    viewModel.showQRCode = true
                }
            }
        } message: {
            Text("Do you want to book this event?")
        }
        .sheet(isPresented: $viewModel.showQRCode, onDismiss: {
            viewModel.updateSeatsLocally()
        }) {
            QRCodeView(event: viewModel.event)
        }
    }
}

#Preview() {
    EventDetailsView(event: Event(
        id: UUID().uuidString,
        name: "ulamazesi usba",
        type: .hiking,
        price: Price(startPrice: 20.0, discountedPrice: nil),
        date: EventDate(startDate: "2025-03-05", endDate: "2025-03-05", durationInDays: 1),
        location: Location(latitude: 41.7151, longitude: 44.8271, address: "Mtatsminda Park", city: "svaneti"),
        seats: Seats(total: 30, available: 15),
        photos: ["banaki1"],
        organizerContact: "hikegeorgia@gmail.com",
        requirements: ["Comfortable Shoes"],
        tags: ["City", "Adventure"],
        isFavorite: true,
        description: "Experience the beauty of Tbilisi with a guided hiking tour."
    ))
}

//
//  EventDetailsView.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//


import SwiftUI

struct EventDetailsView: View {
    let event: Event
    @State private var currentPhotoIndex = 0
    @State private var isFavorite: Bool
    @Environment(\.presentationMode) var presentationMode
    
    init(event: Event) {
        self.event = event
        _isFavorite = State(initialValue: event.isFavorite)
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
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .background(.pageBack)
    }
    
    private var photoSectionWithLocationOverlay: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentPhotoIndex) {
                ForEach(event.photos.indices, id: \.self) { index in
                    Image(event.photos[index])
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
                                SmallButtonView(imageSystemName: "arrow.left", fontSize: 20)
                                    .padding(.leading, 16)
                            }
                            Spacer()
                            Button(action: { isFavorite.toggle() }) {
                                SmallButtonView(imageSystemName: isFavorite ? "heart.fill" : "heart", fontSize: 20)
                                    .padding(.trailing, 16)
                            }
                        }
                        .padding(.top, 64)
        }
    }
    
    private var thumbnailStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(event.photos.indices, id: \.self) { index in
                    Image(event.photos[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(currentPhotoIndex == index ? .blue : .clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            currentPhotoIndex = index
                        }
                }
            }
            .padding()
        }
    }
    
    private var eventDetails: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(event.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                if let discountedPrice = event.price.discountedPrice {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("$\(discountedPrice, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                        
                        Text("$\(event.price.startPrice, specifier: "%.2f")")
                            .font(.subheadline)
                            .strikethrough()
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("$\(event.price.startPrice, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                InfoCard(icon: "calendar", title: "Date", value: formatDateRange())
                InfoCard(icon: "mappin", title: "Location", value: formatLocation())
                InfoCard(icon: "person.2.fill", title: "Availability", value: "\(event.seats.available) spots left")
                InfoCard(icon: "clock", title: "Duration", value: formatDuration())
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("About")
                    .font(.title3)
                    .fontWeight(.bold)
                Text(event.description)
                    .foregroundStyle(.secondary)
            }
            
            if !(event.tags?.isEmpty ?? true) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tags")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    FlowLayout(spacing: 8) {
                        //FIXME: - ! mark
                        ForEach(event.tags!, id: \.self) { tag in
                            Text(tag)
                                .font(.footnote)
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
                    if let discountedPrice = event.price.discountedPrice {
                        Text("$\(event.price.startPrice, specifier: "%.2f")")
                            .strikethrough()
                            .foregroundColor(.secondary)
                        Text("$\(discountedPrice, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    } else {
                        Text("$\(event.price.startPrice, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
                Button(action: {}) {
                    Text("Book now")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.blue)
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
    }
    
    private func formatDateRange() -> String {
        guard let endDate = event.date.endDate else {
            return "\(event.date.startDate)"
        }
        return "\(event.date.startDate) \(endDate)"
    }
    
    private func formatLocation() -> String {
        guard let city = event.location.city else {
            return event.location.address ?? "Unknown location"
        }
        return "\(city), \(event.location.address ?? "")"
    }
    
    private func formatDuration() -> String {
        let days = event.date.durationInDays
        return days == 1 ? "1 day" : "\(String(describing: days)) days"
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
        photos: ["svaneti", "xevsureti"],
        organizerContact: "hikegeorgia@gmail.com",
        requirements: ["Comfortable Shoes"],
        tags: ["City", "Adventure"],
        isFavorite: true,
        description: "Experience the beauty of Tbilisi with a guided hiking tour."
    ))
}

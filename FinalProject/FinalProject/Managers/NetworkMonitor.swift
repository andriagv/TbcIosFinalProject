//
//  NetworkMonitor.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import Network

// MARK: - Protocol
protocol NetworkMonitorable {
    var isNetworkAvailable: Bool { get }
    func startMonitoring(completion: @escaping (Bool) -> Void)
    func stopMonitoring()
}

// MARK: - Network Error
enum NetworkError: Error {
    case unauthorized
    case networkError
    case parsingError
}

// MARK: - Implementation
final class NetworkMonitor: NetworkMonitorable {
    private let monitor = NWPathMonitor()
    private var handler: ((Bool) -> Void)?

    var isNetworkAvailable: Bool {
        monitor.currentPath.status == .satisfied
    }

    func startMonitoring(completion: @escaping (Bool) -> Void) {
        handler = completion
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.handler?(path.status == .satisfied)
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

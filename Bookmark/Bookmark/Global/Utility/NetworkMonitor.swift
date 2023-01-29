//
//  NetworkMonitor.swift
//  Bookmark
//
//  Created by heerucan on 2022/12/24.
//

import UIKit
import Network

final class NetworkMonitor{
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private(set) var isConnected = false
    private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied
            self.getConenctionType(path)
            
            if self.isConnected {
                print("연결OOOO!")
            } else {
                print("연결XXXX!")
            }
        }
    }
    
    func stopMonitoring() {
        print("stopMonitoring 호출")
        monitor.cancel()
    }
    
    private func getConenctionType(_ path:NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
            print("wifi에 연결")
            
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
            print("cellular에 연결")
            
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
            print("wiredEthernet에 연결")
            
        } else {
            connectionType = .unknown
            print("unknown")
        }
    }
    
    func changeUIBytNetworkConnection(vc: UIViewController, completion: @escaping (()->())) {
        if self.isConnected {
            completion()
            
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let alert = UIAlertController(title: Matrix.Network.title,
                                              message: Matrix.Network.subtitle,
                                              preferredStyle: .alert)
                
                let closeAction = UIAlertAction(title: "networkTerminate".localized, style: .default) { _ in
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }
                
                let retryAction = UIAlertAction(title: Matrix.Network.button, style: .cancel) { _ in
                    self.changeUIBytNetworkConnection(vc: vc, completion: completion)
                }
                
                alert.addAction(closeAction)
                alert.addAction(retryAction)
                vc.transition(alert, .present)
            }
        }
    }
}

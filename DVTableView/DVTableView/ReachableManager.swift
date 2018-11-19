//
//  ReachableManager.swift
//  AlamofireSample
//
//  Created by Nam Vu on 11/19/18.
//  Copyright © 2018 Nam Vu. All rights reserved.
//

import UIKit

#if canImport(Alamofire)
import Alamofire

class ReachableManager {
    static let sharedInstance = ReachableManager()
    
    private init() { }
    
    private var reachabilityManager: NetworkReachabilityManager!
    
    func startListening() {
        reachabilityManager = NetworkReachabilityManager()
        
        reachabilityManager.startListening()
        reachabilityManager.listener = { [weak self] status in
            guard let mySelf = self else { return }
            if let isNetworkReachable = mySelf.reachabilityManager?.isReachable {
                if isNetworkReachable {
                    NotificationCenter.default.post(name: Notification.Name("networkReachable"), object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("networkNotReachable"), object: nil)
                }
            }
        }
    }
    
    func stopListening() {
//        reachabilityManager?.stopListening()
    }
}

#endif

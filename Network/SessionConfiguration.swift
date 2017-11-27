//
//  SessionConfiguration.swift
//  Network
//
//  Created by lyy on 2017/11/23.
//  Copyright © 2017年 lyy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SessionConfiguration {
    
    static var configuration: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = SessionConfiguration.timeoutIntervalForRequest
        config.requestCachePolicy = SessionConfiguration.requestCachePolicy
        config.httpAdditionalHeaders = SessionConfiguration.getCustomHTTPHeaders()
        return config
    }
    
    private static let timeoutIntervalForRequest: TimeInterval = 10
    //TODO: Last-Modified/If-Modified-Since 或者 ETag 后期参考这个看看 决定是用缓存还是请求
    //如果是这样 缓存策略需要设置为reloadIgnoringLocalCacheData 每次都需要去服务端请求验证
    private static let requestCachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    
    public static func getCustomHTTPHeaders() -> [String: String] {
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joined(separator: ", ")
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknownStr"
        let version = ProcessInfo.processInfo.operatingSystemVersion
        let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

                //eg: 9.3.1
                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    let deviceName: String = {
                        let currentDevice = UIDevice.current
                        let deviceModel = currentDevice.model
                        let deviceName = currentDevice.deviceName
                        
                        return "\(deviceModel)/\(deviceName)"
                    }()
                    
                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #else
                            return unknownStr
                        #endif
                    }()
                    
                    return "\(osName) \(deviceName) \(versionString)"
                }()
                
                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)"
            }
            
            return "BakeTime"
        }()
        
        return [
            "Accept-Encoding" : acceptEncoding,
            "Accept-Language" : acceptLanguage,
            "User-Agent"      : userAgent,
            "x-client-version": appVersion,     // 客户端版本信息(如1.4.2)
            "x-os-version"    : versionString,  // 具体系统版本信息
        ]
    }
}

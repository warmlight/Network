//
//  NetworkManager.swift
//  Network
//
//  Created by lyy on 2017/11/20.
//  Copyright © 2017年 lyy. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private var url: String = ""
    private var params: Parameters = [:]
    private var method: HTTPMethod = .get
    private var encoding: ParameterEncoding = URLEncoding.default
    private var headers: HTTPHeaders = SessionConfiguration.getCustomHTTPHeaders()
    
    fileprivate let sessionManager: SessionManager = {
        return Alamofire.SessionManager(configuration: SessionConfiguration.configuration)
    }()
    
    private init() {
    }
}

// MARK: - HttpMethod

extension NetworkManager {
    func get(from path: String) -> NetworkManager {
        url = appendPath(path)
        method = .get
        return self
    }
    
    func post(to path: String) -> NetworkManager {
        url = appendPath(path)
        method = .post
        return self
    }
    
    func delete(from path: String) -> NetworkManager {
        url = appendPath(path)
        method = .delete
        return self
    }
    
    func put(to path: String) -> NetworkManager {
        url = appendPath(path)
        method = .put
        return self
    }
}

// MARK: - Congfig

extension NetworkManager {
    func url(_ path: String) -> NetworkManager {
        url = appendPath(path)
        return self
    }
    
    func addParam(_ param: [String: Any]) -> NetworkManager {
        params += param
        return self
    }
    
    func paramsEncoding(_ encoding: ParameterEncoding) -> NetworkManager {
        self.encoding = encoding
        return self
    }
    
    func headers(_ headers: [String: String]) -> NetworkManager {
        self.headers += headers
        return self
    }
}

// MARK: - Request

extension NetworkManager {
    func request(success: @escaping (_ data: [String: Any]) -> Void, failure: ((Error) -> Void)? = nil) {
        sessionManager.request(url, method: method, parameters: params, encoding: encoding, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let result):
                if let value = result as? [String: Any] {
                    success(value)
                }
            case .failure(let error):
                if let fail = failure {
                    fail(error)
                }
            }
        }
    }
    
    func uploadDataRequest(data: Data,
                           success: @escaping (_ data: [String: Any]) -> Void,
                           failure: ((Error) -> Void)? = nil,
                           progress: ((Progress) -> Void)? = nil) {
        sessionManager.upload(data, to: url, method: method, headers: headers)
            .uploadProgress { (_progress) in
                if let p = progress {
                    p(_progress)
                }
            }.responseJSON { (response) in
                switch response.result {
                case .success(let result):
                    if let value = result as? [String: Any] {
                        success(value)
                    }
                case .failure(let error):
                    if let fail = failure {
                        fail(error)
                    }
                }
        }
    }
    
    func downloadRequest(progress: ((Progress) -> Void)? = nil,
                         success: @escaping (_ data: Data) -> Void,
                         failure: ((Error) -> Void)? = nil,
                         to destination: DownloadRequest.DownloadFileDestination? = nil) {
        sessionManager.download(url, method: method, parameters: params, encoding: encoding, headers: headers, to: destination)
            .downloadProgress { (_progress) in
                if let p = progress {
                    p(_progress)
                }
            }.responseData { (response) in
                switch response.result {
                case .success(let result):
                    success(result)
                case .failure(let error):
                    if let fail = failure {
                        fail(error)
                    }
                }
        }
    }
}

// MARK: - Helper

extension NetworkManager {
    fileprivate func resetRequest() {
        url = ""
        params = [:]
        method = .get
    }
    
    private func appendPath(_ path: String) -> String {
        let trimmedURL = path.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedURL.hasPrefix("https://") || trimmedURL.hasPrefix("http://") {
            return trimmedURL
        } else {
            var urlStr: String
            trimmedURL.hasPrefix("/") ? (urlStr = URLPath.baseURL + trimmedURL) : (urlStr = URLPath.baseURL + "/" + path)
            return urlStr
        }
    }
}

let RequestApi: NetworkManager = {
    let request = NetworkManager.shared
    request.resetRequest()
    return request
}()

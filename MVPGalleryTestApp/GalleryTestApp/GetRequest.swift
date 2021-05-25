//
//  GetRequest.swift
//  GalleryTestApp
//
//  Created by Roma on 06.04.2021.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
//
class GetRequest {

    //http://gallery.dev.webant.ru/api/photos

    var baseUrl = "http://gallery.dev.webant.ru/api/"
    var endPoint = ""
    var disposeBag = DisposeBag()
//
    typealias imageCallBack = (_ getInfo: ImagePaginationEntity?, _ message: String) -> Void
//
//    init(endPoint: String) {
//        self .endPoint = endPoint
//    }
//
//    func showError() {
//
//    }
//
    func getRequest(numberOfPage: Int, currentCollection: CollectionType, callback: @escaping imageCallBack) {



        let parametrs: [String : Any]

        switch currentCollection {
        case .new:
            parametrs = ["page" : numberOfPage, "limit": 10, "new" : true]

        case .popular:
            parametrs = ["page" : numberOfPage, "limit": 10, "new" : false, "popular" : true]

        }
//
////        RxAlamofire.json(.get, baseUrl+endPoint)
////            .debug()
////            .subscribe { response in
////                print(response)
////            } onError: { (error) in
////                print(error)
////            }
////
//        RxAlamofire.data(.get, baseUrl+endPoint, parameters: parametrs)
//            .do(onNext: <#T##((Data) throws -> Void)?##((Data) throws -> Void)?##(Data) throws -> Void#>, afterNext: <#T##((Data) throws -> Void)?##((Data) throws -> Void)?##(Data) throws -> Void#>, onError: <#T##((Error) throws -> Void)?##((Error) throws -> Void)?##(Error) throws -> Void#>, afterError: <#T##((Error) throws -> Void)?##((Error) throws -> Void)?##(Error) throws -> Void#>, onCompleted: <#T##(() throws -> Void)?##(() throws -> Void)?##() throws -> Void#>, afterCompleted: <#T##(() throws -> Void)?##(() throws -> Void)?##() throws -> Void#>, onSubscribe: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onSubscribed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDispose: {
//                <#code#>
//            })
//            .subscribe { [weak self] response in
//                guard let self = self else { return }
//                print(response)
//                self.showError()
//                do {
//                    let data = try JSONDecoder().decode(ImagePaginationEntity.self, from: response)
//                    callback(data, "200")
//                } catch  let error {
//
//                    callback(nil, error.localizedDescription)
//                }
//
//            } onError: { (error) in
//                print(error)
//            }
//            .disposed(by: disposeBag)
//
//
        AF.download(<#T##convertible: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Encodable?#>, encoder: <#T##ParameterEncoder#>, headers: <#T##HTTPHeaders?#>, interceptor: <#T##RequestInterceptor?#>, requestModifier: <#T##Session.RequestModifier?##Session.RequestModifier?##(inout URLRequest) throws -> Void#>, to: <#T##DownloadRequest.Destination?##DownloadRequest.Destination?##(URL, HTTPURLResponse) -> (destinationURL: URL, options: DownloadRequest.Options)#>)
    AF.request(baseUrl + endPoint, method: .get, parameters: parametrs, requestModifier: { $0.timeoutInterval = 2 }).responseJSON { response in
            guard let data = response.data else {
                    callback(nil, "no connection")
                    return
            }
            do {
                let decode = try JSONDecoder().decode(ImagePaginationEntity.self, from: data)
                guard let status = response.response?.statusCode else { return }

                callback(decode, "\(String(describing: status))")
            } catch {
                guard let status = response.response?.statusCode else { return }

                callback(nil, "\(String(describing: status))")
                return
            }
        }
    }
}


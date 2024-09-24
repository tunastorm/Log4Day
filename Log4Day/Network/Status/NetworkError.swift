//
//  NetworkError.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import Foundation

enum NetworkError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case networkError
    case redirectError
    case clientError
    case serverError
    case invalidData
    case noResultError
    case unExpectedError
    
    var title: String {
        switch self {
        case .failedRequest:
            return "[ 세션 요청 실패 ]"
        case .noData:
            return "[ 응답 데이터 없음 ]"
        case .invalidResponse:
            return "[ 응답 유효성 에러 ]"
        case .networkError:
            return "[ 네트워크 에러 ]"
        case .redirectError:
            return "[ 리소스 경로 변경 ]"
        case .clientError:
            return "[ 잘못된 요청 ]"
        case .serverError:
            return "[ 서비스 상태 불량 ]"
        case .invalidData:
            return "[ 데이터 유효성 에러 ]"
        case .noResultError:
            return "[ 검색 결과 없음 ]"
        case .unExpectedError:
            return "[ 비정상적인 에러 ]"
        default: ""
        }
    }
    
    var message: String {
        switch self {
        case .failedRequest:
            return "데이터 요청에 실패하였습니다.\n 네트워크 환경을 확인하세요."
        case .noData:
            return "검색결과가 없습니다. 다른 검색어를 입력하세요."
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .networkError:
            return "네트워크 연결상태를 확인하세요."
        case .redirectError:
            return "요청한 리소스의 주소가 변경되었습니다.\n  올바른 주소로 다시 요청해주세요."
        case .clientError:
            return "잘못된 요청이거나 접근권한이 없습니다."
        case .serverError:
            return "일시적인 서비스 장애입니다.\n  잠시 후 다시 시도해주세요."
        case .invalidData:
            return "응답 데이터가 유효하지 않습니다."
        case .noResultError:
            return "검색어에 해당하는 결과가 없습니다."
        case .unExpectedError:
            return "알 수 없는 에러가 발생하였습니다.\n 고객센터로 문의하세요."
        default: ""
        }
        
    }
    
}

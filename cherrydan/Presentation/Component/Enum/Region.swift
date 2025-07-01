enum Region: String, CaseIterable {
    case seoul = "서울"
    case gyeonggi = "경기/인천"
    case gangwon = "강원"
    case daejeonChungcheong = "대전/충청"
    case daeguGyeongbuk = "대구/경북"
    case busanGyeongnam = "부산/경남"
    case gwangjuJeolla = "광주/전라"
    case jeju = "제주"
    
    var subregions: [String] {
        switch self {
        case .seoul:
            return ["교대/사당", "압구정/신사", "강남/논현", "삼성/선릉", "송파/잠실", "강동/천호", "건대/왕십리", "홍대/마포", "강서/목동", "노원/강북/도봉", "명동/이태원", "수유/동대문/중량", "신촌/이대/은평", "여의도/영등포", "종로/대학로/성북", "관악/신림", "구로/금천"]
        case .gyeonggi:
            return ["남양주/구리/하남", "일산/파주", "안양/안산/광명", "용인/성남/수원", "화성", "인천/부천"]
        case .gangwon:
            return ["속초/양양/강릉", "춘천/홍천/원주", "기타"]
        case .daejeonChungcheong:
            return ["대전/세종", "충청북도", "충청남도"]
        case .daeguGyeongbuk:
            return ["대구", "경북"]
        case .busanGyeongnam:
            return ["부산", "울산", "경남"]
        case .gwangjuJeolla:
            return ["광주", "전라남도", "전라북도"]
        case .jeju:
            return ["제주 전체"]
        }
    }
    
    var startIndex: Int {
        switch self {
        case .seoul:
            0
        case .gyeonggi:
            16
        case .gangwon:
            26
        case .daejeonChungcheong:
            32
        case .daeguGyeongbuk:
            39
        case .busanGyeongnam:
            45
        case .gwangjuJeolla:
            51
        case .jeju:
            55
        }
    }
}

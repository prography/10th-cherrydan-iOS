import Foundation

enum RegionGroup: String, CaseIterable, Codable {
    case seoul = "seoul"
    case gyeonggiIncheon = "gyeonggi_incheon"
    case gangwon = "gangwon"
    case daejeonChungcheong = "daejeon_chungcheong"
    case daeguGyeongbuk = "daegu_gyeongbuk"
    case busanGyeongnam = "busan_gyeongnam"
    case gwangjuJeolla = "gwangju_jeolla"
    case jeju = "jeju"
    
    var id: Int {
        switch self {
        case .seoul: return 1
        case .gyeonggiIncheon: return 2
        case .gangwon: return 3
        case .daejeonChungcheong: return 4
        case .daeguGyeongbuk: return 5
        case .busanGyeongnam: return 6
        case .gwangjuJeolla: return 7
        case .jeju: return 8
        }
    }
    
    var displayName: String {
        switch self {
        case .seoul: return "서울"
        case .gyeonggiIncheon: return "경기/인천"
        case .gangwon: return "강원"
        case .daejeonChungcheong: return "대전/충청"
        case .daeguGyeongbuk: return "대구/경북"
        case .busanGyeongnam: return "부산/경남"
        case .gwangjuJeolla: return "광주/전라"
        case .jeju: return "제주"
        }
    }
    
    var subRegions: [SubRegion] {
        switch self {
        case .seoul:
            return [
                .gyodaeSadang, .apgujeongSinsa, .gangnamNonhyeon, .samseongSeolleung,
                .songpaJamsil, .gangdongCheongho, .geondaeWangsimni, .hongdaeMapo,
                .gangseoMokdong, .nowonGangbukDobong, .myeongdongItaewon, .suyuDongdaemunJungnang,
                .sinchonEwhaEunpyeong, .yeouidoYeongdeungpo, .jongnoDaehakroSeongbuk,
                .gwanakSillim, .guroGeumcheon, .seoulEtc
            ]
        case .gyeonggiIncheon:
            return [
                .namyangjuGuriHanam, .ilsanPaju, .anyangAnsanGwangmyeong,
                .yonginSangnamSuwon, .hwaseong, .incheonBucheon, .gyeonggiEtc
            ]
        case .gangwon:
            return [
                .sokchoyangYanggangRyeong, .chuncheonHongcheonWonju, .gangwonEtc
            ]
        case .daejeonChungcheong:
            return [
                .daejeonSejong, .chungbuk, .chungnam
            ]
        case .daeguGyeongbuk:
            return [
                .daegu, .gyeongbuk
            ]
        case .busanGyeongnam:
            return [
                .busan, .ulsan, .gyeongnam
            ]
        case .gwangjuJeolla:
            return [
                .gwangju, .jeonbuk, .jeonnam
            ]
        case .jeju:
            return [
                .jeju
            ]
        }
    }
    
    var startIndex: Int {
        switch self {
        case .seoul: return 0
        case .gyeonggiIncheon: return 18
        case .gangwon: return 25
        case .daejeonChungcheong: return 28
        case .daeguGyeongbuk: return 31
        case .busanGyeongnam: return 33
        case .gwangjuJeolla: return 36
        case .jeju: return 39
        }
    }
    
    static func from(displayName: String) -> RegionGroup? {
        return RegionGroup.allCases.first { $0.displayName == displayName }
    }
    
    static func from(id: Int) -> RegionGroup? {
        return RegionGroup.allCases.first { $0.id == id }
    }
    
    static func regionGroup(for subRegion: SubRegion) -> RegionGroup? {
        return RegionGroup.allCases.first { $0.subRegions.contains(subRegion) }
    }
} 
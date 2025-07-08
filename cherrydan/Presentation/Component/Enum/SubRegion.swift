import Foundation

enum SubRegion: String, CaseIterable, Codable {
    // 서울
    case gyodaeSadang = "gyodae_sadang"
    case apgujeongSinsa = "apgujeong_sinsa"
    case gangnamNonhyeon = "gangnam_nonhyeon"
    case samseongSeolleung = "samseong_seolleung"
    case songpaJamsil = "songpa_jamsil"
    case gangdongCheongho = "gangdong_cheongho"
    case geondaeWangsimni = "geondae_wangsimni"
    case hongdaeMapo = "hongdae_mapo"
    case gangseoMokdong = "gangseo_mokdong"
    case nowonGangbukDobong = "nowon_gangbuk_dobong"
    case myeongdongItaewon = "myeongdong_itaewon"
    case suyuDongdaemunJungnang = "suyu_dongdaemun_jungnang"
    case sinchonEwhaEunpyeong = "sinchon_ewha_eunpyeong"
    case yeouidoYeongdeungpo = "yeouido_yeongdeungpo"
    case jongnoDaehakroSeongbuk = "jongno_daehakro_seongbuk"
    case gwanakSillim = "gwanak_sillim"
    case guroGeumcheon = "guro_geumcheon"
    case seoulEtc = "seoul_etc"
    
    // 경기/인천
    case namyangjuGuriHanam = "namyangju_guri_hanam"
    case ilsanPaju = "ilsan_paju"
    case anyangAnsanGwangmyeong = "anyang_ansan_gwangmyeong"
    case yonginSangnamSuwon = "yongin_sangnam_suwon"
    case hwaseong = "hwaseong"
    case incheonBucheon = "incheon_bucheon"
    case gyeonggiEtc = "gyeonggi_etc"
    
    // 강원
    case sokchoyangYanggangRyeong = "sokcho_yangyang_gangryeong"
    case chuncheonHongcheonWonju = "chuncheon_hongcheon_wonju"
    case gangwonEtc = "gangwon_etc"
    
    // 대전/충청
    case daejeonSejong = "daejeon_sejong"
    case chungbuk = "chungbuk"
    case chungnam = "chungnam"
    
    // 대구/경북
    case daegu = "daegu"
    case gyeongbuk = "gyeongbuk"
    
    // 부산/경남
    case busan = "busan"
    case ulsan = "ulsan"
    case gyeongnam = "gyeongnam"
    
    // 광주/전라
    case gwangju = "gwangju"
    case jeonbuk = "jeonbuk"
    case jeonnam = "jeonnam"
    
    // 제주
    case jeju = "jeju"
    
    var id: Int {
        switch self {
        // 서울 (1-18)
        case .gyodaeSadang: return 1
        case .apgujeongSinsa: return 2
        case .gangnamNonhyeon: return 3
        case .samseongSeolleung: return 4
        case .songpaJamsil: return 5
        case .gangdongCheongho: return 6
        case .geondaeWangsimni: return 7
        case .hongdaeMapo: return 8
        case .gangseoMokdong: return 9
        case .nowonGangbukDobong: return 10
        case .myeongdongItaewon: return 11
        case .suyuDongdaemunJungnang: return 12
        case .sinchonEwhaEunpyeong: return 13
        case .yeouidoYeongdeungpo: return 14
        case .jongnoDaehakroSeongbuk: return 15
        case .gwanakSillim: return 16
        case .guroGeumcheon: return 17
        case .seoulEtc: return 18
        
        // 경기/인천 (30-36)
        case .namyangjuGuriHanam: return 30
        case .ilsanPaju: return 31
        case .anyangAnsanGwangmyeong: return 32
        case .yonginSangnamSuwon: return 33
        case .hwaseong: return 34
        case .incheonBucheon: return 35
        case .gyeonggiEtc: return 36
        
        // 강원 (40-42)
        case .sokchoyangYanggangRyeong: return 40
        case .chuncheonHongcheonWonju: return 41
        case .gangwonEtc: return 42
        
        // 대전/충청 (50-52)
        case .daejeonSejong: return 50
        case .chungbuk: return 51
        case .chungnam: return 52
        
        // 대구/경북 (60-61)
        case .daegu: return 60
        case .gyeongbuk: return 61
        
        // 부산/경남 (70-72)
        case .busan: return 70
        case .ulsan: return 71
        case .gyeongnam: return 72
        
        // 광주/전라 (80-82)
        case .gwangju: return 80
        case .jeonbuk: return 81
        case .jeonnam: return 82
        
        // 제주 (90)
        case .jeju: return 90
        }
    }
    
    var displayName: String {
        switch self {
        // 서울
        case .gyodaeSadang: return "교대/사당"
        case .apgujeongSinsa: return "압구정/신사"
        case .gangnamNonhyeon: return "강남/논현"
        case .samseongSeolleung: return "삼성/선릉"
        case .songpaJamsil: return "송파/잠실"
        case .gangdongCheongho: return "강동/천호"
        case .geondaeWangsimni: return "건대/왕십리"
        case .hongdaeMapo: return "홍대/마포"
        case .gangseoMokdong: return "강서/목동"
        case .nowonGangbukDobong: return "노원/강북/도봉"
        case .myeongdongItaewon: return "명동/이태원"
        case .suyuDongdaemunJungnang: return "수유/동대문/중랑"
        case .sinchonEwhaEunpyeong: return "신촌/이대/은평"
        case .yeouidoYeongdeungpo: return "여의도/영등포"
        case .jongnoDaehakroSeongbuk: return "종로/대학로/성북"
        case .gwanakSillim: return "관악/신림"
        case .guroGeumcheon: return "구로/금천"
        case .seoulEtc: return "기타"
        
        // 경기/인천
        case .namyangjuGuriHanam: return "남양주/구리/하남"
        case .ilsanPaju: return "일산/파주"
        case .anyangAnsanGwangmyeong: return "안양/안산/광명"
        case .yonginSangnamSuwon: return "용인/성남/수원"
        case .hwaseong: return "화성"
        case .incheonBucheon: return "인천/부천"
        case .gyeonggiEtc: return "기타"
        
        // 강원
        case .sokchoyangYanggangRyeong: return "속초/양양/강릉"
        case .chuncheonHongcheonWonju: return "춘천/홍천/원주"
        case .gangwonEtc: return "기타"
        
        // 대전/충청
        case .daejeonSejong: return "대전/세종"
        case .chungbuk: return "충북"
        case .chungnam: return "충남"
        
        // 대구/경북
        case .daegu: return "대구"
        case .gyeongbuk: return "경북"
        
        // 부산/경남
        case .busan: return "부산"
        case .ulsan: return "울산"
        case .gyeongnam: return "경남"
        
        // 광주/전라
        case .gwangju: return "광주"
        case .jeonbuk: return "전북"
        case .jeonnam: return "전남"
        
        // 제주
        case .jeju: return "제주"
        }
    }
    
    static func from(displayName: String) -> SubRegion? {
        return SubRegion.allCases.first { $0.displayName == displayName }
    }
    
    static func from(id: Int) -> SubRegion? {
        return SubRegion.allCases.first { $0.id == id }
    }
} 
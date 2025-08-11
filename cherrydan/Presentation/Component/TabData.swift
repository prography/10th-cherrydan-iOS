struct TagData: Hashable {
    let imgUrl: String?
    let imgName: String?
    let name: String
    
    init(
        imgUrl: String? = nil,
        imgName: String? = nil,
        name: String
    ) {
        self.name = name
        self.imgUrl = imgUrl
        self.imgName = imgName
    }
}

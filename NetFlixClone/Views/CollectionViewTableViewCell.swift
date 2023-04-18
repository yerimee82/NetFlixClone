//
//  CollectionViewTableViewCell.swift
//  NetFlixClone
//
//  Created by 김예림 on 2023/04/10.
//

import UIKit


protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCall(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}
// UITableViewCell 내부에 UICollectionView 를 추가한 커스텀 뷰
// UITableView의 다양한 기능을 활용하여 뷰를 구성하며, UICollectionView 의 레이아웃이나 셀 디자인 등을 독립적으로 커스텀 가능
class CollectionViewTableViewCell: UITableViewCell {
    
    // 재사용 가능한 셀을 식별하는 데 사용되는 문자열 - 타입 : String (보통 해당 셀 클래스의 이름과 같은 값 사용)
    // dequeueReuableCell 메서드를 호출할 때 사용되며, 해당 셀의 인스턴스를 가져온다.
    // 셀을 참조할 때 해당 식별자 사용
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()
    
    //MARK: - UICollectionView 
    private let collectionView: UICollectionView = {
        
        // 레이아웃 객체 생성 - 컬렉션 뷰에서 사용될 레이아웃 생성
        // 아이템 크기, 스크롤 방향 속성 설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        // 레이아웃을 초함하여 실제로 화면에 표시되는 컨텐츠 담당
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // 컬렉션 뷰에 표시할 셀 클래스 등록하기
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // 클래스 초기화 메서드 정의
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        // delegate, dataSource 위임하기
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // 레이아웃이 업데이트 됐을 때, CollectionView 의 프레임을 contentView 의 경계에 맞게 업데이트 함.
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

}


extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // 데이터 소스에서 데이터를 가져와 셀을 반환함
    // 각 셀을 구현
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    // 섹션 내의 셀 개수를 반환함
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_title else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCall(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

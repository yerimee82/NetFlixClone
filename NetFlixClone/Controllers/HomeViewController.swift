//
//  HomeViewController.swift
//  NetFlixClone
//
//  Created by 김예림 on 2023/04/10.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular
    case UpComing
    case TopRated
}

class HomeViewController: UIViewController {
    
    let sectionTitle: [String] = ["Trending Movies",  "Trending Tv", "Popular","Upcoming Movies", "Top rated"]
    
    //MARK: - UITableView
    // 테이블의 기본 모양을 관리함 - 실제 콘텐츠를 표시하는 셀은 UITableViewCell 에서 관리함
    private let homeFeedTable: UITableView = {
        // frame: 슈퍼뷰의 좌표에서 테이블 뷰의 초기 위치와 크기를 지정함
        // style: 테이블 뷰의 스타일을 지정하는 상수
        // - 1. plain(일반 보기 테이블) 2. grouped(섹션에 고유한 행 그룹이 있는 테이블 그룹) 3. insetGrouped(둥근 모서리로 삽입된 테이블)
        let table = UITableView(frame: .zero, style: .grouped)
        
        // 셀 등록하기 - 클래스로 만든 경우(UITableViewCell 을 상속받는 클래스를 매개변수로 적기)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        // 위임자 지정(tableView의 Delegate 와 Datasource의 위임을 해당 컨트롤러가 받는다.)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        // 네비게이션 상단바
        configureNavBar()
        
        let heroView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = heroView

        
    }
    
    
    
    //MARK: - NavigationBar
    private func configureNavBar() {
        
        var image = UIImage(named: "netflixLogo")
        // 원본 파일이 그대로 나오지 않을 경우가 많아, 원본 파일을 유지하도록 함 -> 따라서 var 로 선언
        image = image?.resize(targetSize: CGSize(width: 45, height: 45)) // 이미지 사이즈 조정
        image = image?.withRenderingMode(.alwaysOriginal)
        
        // 왼쪽 네비게이션 바 아이템
        let logoBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = logoBarButtonItem
        
        // 오른쪽 네비게이션 바 아이템 - Items 는 복수 선언 가능
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
            
        ]
        
        // 네비게이션 아이템 컬러 지정
        navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: - viewDidLayoutSubviews
    // 컨트롤러의 뷰가 서브뷰와 함께 레이아웃이 업데이트 될 때 호출되며 레이아웃 업데이트가 완료된 후에 호출돤다.
    // 레이아웃 업데이트 이후에 수행할 작업을 작업하기 위해 사용됨.
    // 뷰들의 크기나 컨텐츠를 최종적으로 결정
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage? {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

//MARK: - Delegate,DataSource Protocol
// UIViewDelegate과 UITableViewDataSource 프로토콜 채택
// 해당 프로토콜에 정의된 메서드 구현
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // UITableView에서 섹션의 수를 반환하는 메서드 (셀의 개수)
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    // 각 섹션에서 표시될 행의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 각 행에 표시될 셀을 반환하는 메서드
    // 재사용 가능한 셀 -> dequeueReusableCell 을 반환함
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
         
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.UpComing.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    // 각 행의 높이를 반환하는 메서드
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // 각 섹션의 헤더 뷰의 높이를 반환하는 메서드
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


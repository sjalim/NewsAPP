//
//  ViewController.swift
//  NewsApp
//
//  Created by bjit on 12/1/23.
//

import UIKit
import SDWebImage


class HomeViewController: UIViewController  {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var contentSearchView: UIView!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var currentSeletedCategory = 0
    var currentDeselectedCategory = 1
    var selectedIndexPath : IndexPath = IndexPath(row: 0, section: 0)
    var deselectedIndexPath : IndexPath =  IndexPath(row: 1, section: 0)
    private let refreshControl = UIRefreshControl()
    
    var fetchOffset = 10
    var fetchSizeCategory = 5
    var fetchSize = 10
    var inSearch = false
    var loadingInProcess = false
    
    enum TableSection: Int {
        case articlesList
        case loader
    }
    
    var articles = [Article](){
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupView(){
        selectedIndexPath = IndexPath(row: 0, section: 0)
        
        searchTxtField.layer.borderColor = UIColor.clear.cgColor
        searchTxtField.layer.borderWidth = 0
        contentSearchView.layer.cornerRadius = 5
        filterBtn.layer.cornerRadius = 5
        categoryCollectionView.layer.cornerRadius = 5
        
        tableView.delegate = self
        tableView.dataSource = self
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.allowsMultipleSelection = false
        categoryCollectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        
        let homeTableCellNib = UINib(nibName: Constants.HomeTableViewCell, bundle: nil)
        
        tableView.register(homeTableCellNib, forCellReuseIdentifier: Constants.HomeTableViewCell)
        
        
        let loderTableCellNib = UINib(nibName: Constants.LoaderTableViewCell, bundle: nil)
        
        tableView.register(loderTableCellNib, forCellReuseIdentifier: Constants.LoaderTableViewCell)
        
        let homeCollectionViewCellNib = UINib(nibName: Constants.HomeCollectionViewCell, bundle: nil)
        
        categoryCollectionView.register(homeCollectionViewCellNib, forCellWithReuseIdentifier: Constants.HomeCollectionViewCell)
        
        let categoryCollectionViewLayout = UICollectionViewFlowLayout()
        categoryCollectionViewLayout.itemSize = CGSize(width: 150, height: 50)
        categoryCollectionViewLayout.scrollDirection = .horizontal
        categoryCollectionView.collectionViewLayout = categoryCollectionViewLayout
        
    }
    
    private func fetchData(category: String){
        
        if currentSeletedCategory == 0{
            
            fetchData(){
                
                
                //pagination
                if let fetchedArticles = CoreDataHelper.shared.getAllData(offset: self.fetchOffset)
                {
                    self.articles = fetchedArticles
                }
                
                CoreDataHelper.shared.setAllBookmarkedDataIntoMain()
                Utilities.shared.setLastFetchedTime()
                
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
            
        }
        else
        {
            if category != ""
            {
                setDataCategoryWise(category: category, completion: universalSetData)
            }
            else{
                print("Error: fetchData(category)")
            }
            
        }
    }
    
    func universalSetData(){
        //pagination

        if let fetchedArticles = CoreDataHelper.shared.getAllData(offset: self.fetchOffset)
        {
            self.articles = fetchedArticles
        }
    }
    
    func setDataCategoryWise(category: String, completion: @escaping ()-> ()){
        
        //pagination reset
        APIRequestManager.shared.fetchData(category: category){ result in
            switch result {
            case .success(let response):
                //self?.articles += response.articles
                CoreDataHelper.shared.storeNewFetchedDataAll(articles: response.articles, category: category)
                //print("Position: \(Constants.Business) data count \(self?.articles.count)")
                completion()
                DispatchQueue.main.async {
                    
                    //                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    
    private func fetchData(completion: @escaping ()->()) {
        CoreDataHelper.shared.removeAllData()
        
        APIRequestManager.shared.fetchData(category: Constants.Business){ result in
            switch result {
            case .success(let response):
                //                self?.articles += response.articles
                CoreDataHelper.shared.storeNewFetchedDataAll(articles: response.articles, category: Constants.Business)
        
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        APIRequestManager.shared.fetchData(category: Constants.Entertainment){ result in
            switch result {
            case .success(let response):
                //                self?.articles += response.articles
                CoreDataHelper.shared.storeNewFetchedDataAll(articles: response.articles, category: Constants.Entertainment)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        APIRequestManager.shared.fetchData(category: Constants.General){ result in
            switch result {
            case .success(let response):
                //                self?.articles += response.articles
                CoreDataHelper.shared.storeNewFetchedDataAll(articles: response.articles, category: Constants.General)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        APIRequestManager.shared.fetchData(category: Constants.Health){  result in
            switch result {
            case .success(let response):
                //                self?.articles += response.articles
                CoreDataHelper.shared.storeNewFetchedDataAll(articles: response.articles, category: Constants.Health)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        APIRequestManager.shared.fetchData(category: Constants.Science){ result in
            switch result {
            case .success(let response):
                //                self?.articles += response.articles
                CoreDataHelper.shared.storeNewFetchedDataAll(articles: response.articles, category: Constants.Science)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        APIRequestManager.shared.fetchData(category: Constants.Sports){ result in
            switch result {
            case .success(let response):
                //                self?.articles += response.articles
                CoreDataHelper.shared.storeNewFetchedDataAll(articles: response.articles, category: Constants.Sports)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        APIRequestManager.shared.fetchData(category: Constants.Technology){  result in
            switch result {
            case .success(let response):
                //                self?.articles += response.articles
                CoreDataHelper.shared.storeNewFetchedDataAll(articles: response.articles, category: Constants.Technology)
                
                
                completion()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
        private func hideBottomLoader() {
            DispatchQueue.main.async {
                let lastListIndexPath = IndexPath(row: self.articles.count - 1, section: TableSection.articlesList.rawValue)
                self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
            }
        }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Position: Home viewWillAppear()")
        
        if Utilities.shared.getLastFetchedTimeIntervalInMin() > 300{
            print("Position: Home viewWillAppear() timeInterval: \(Utilities.shared.getLastFetchedTimeIntervalInMin())")
            
            
            fetchData(){
                // pagination
                if let fetchedArticles = CoreDataHelper.shared.getAllData(offset: self.fetchOffset)
                {
                    self.articles = fetchedArticles
                }
                
                
                CoreDataHelper.shared.setAllBookmarkedDataIntoMain()
                Utilities.shared.setLastFetchedTime()
                self.tableView.reloadData()
            }
            
        }
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        print("Position: Home viewDidLoad()")
        
        if Utilities.shared.getLastFetchedTime() == nil
        {
            
            fetchData(){
                self.setInitialTime()
                
                //pagination
                if let fetchedArticles = CoreDataHelper.shared.getAllData(offset: self.fetchOffset)
                {
                    self.articles = fetchedArticles
                }
            }
            
        }
        // pagination
        if let fetchedArticles = CoreDataHelper.shared.getAllData(offset: self.fetchOffset)
        {
            self.articles = fetchedArticles
            print("Position: Home viewDidLoad() \(self.articles.count)")
            
        }
        //        self.tableView.reloadData()
        
        searchTxtField.addTarget(self, action: #selector(searchNewsAction), for: .editingChanged)
        
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(pullRefreshAction), for: .valueChanged)
    }
    
    @objc func pullRefreshAction(){
        
        fetchData(category: Constants.categories[currentSeletedCategory].lowercased())
        self.searchTxtField.text = ""
    }
    
    
    @objc func searchNewsAction(){
        print("Position: Home searchNewsAction()")
        
        if let searchTxt = searchTxtField.text{
            self.inSearch = true
            if searchTxt == ""{
                
                if currentSeletedCategory == 0{
                    // pagination

                    guard let result = CoreDataHelper.shared.getAllData(offset: self.fetchOffset) else{return}
                    self.articles = result
                }
                else
                {
                    // pagination reset
                    
                    self.fetchOffset = 0

                    guard let result = CoreDataHelper.shared.getDataCatergoryWise(category: Constants.categories[currentSeletedCategory].lowercased(), offset: self.fetchOffset) else { return}
                    self.articles = result
                }
            }
            else
            {
                

                if currentSeletedCategory == 0{
                    guard let result = CoreDataHelper.shared.getSearchDataAll(searchText: searchTxt) else { return }
                    
                    self.articles = result
                }
                else
                {
                    guard let result = CoreDataHelper.shared.getSearchDataCategoryWise(searchText: searchTxt, category: Constants.categories[currentSeletedCategory].lowercased()) else {return}
                    
                    self.articles = result
                }
            }
        }
        
    }
    func handleBookmarkAction(at: IndexPath, completion: @escaping ()->()){
        print("Position: Home handleBookmarkAction()")
        
        
        if articles[at.row].bookmarked == false{
            
            let bookmarkedData = BookmarkedArticleModel(
                author: articles[at.row].author,
                category: articles[at.row].category!,
                content: articles[at.row].content,
                desc: articles[at.row].desc,
                id: articles[at.row].id,
                publishedAt: articles[at.row].publishedAt,
                source: articles[at.row].source,
                title: articles[at.row].title,
                url: articles[at.row].url,
                urlToImage: articles[at.row].urlToImage)
            
            CoreDataHelper.shared.appendNewBookmarkedData(bookmarkedArticle: bookmarkedData, article: articles[at.row])
            
            completion()
        }
        else{
            let alert = UIAlertController(title: "Alert!", message: "News already added to bookmark", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel)
            alert.addAction(closeAction)
            present(alert, animated: true)
        }
        
    }
    
    func setInitialTime() {
        
        struct Once {
            static let once = Once()
            init() {
                
                if Utilities.shared.getLastFetchedTime() == nil
                {
                    print("Position: Home setInitialTime()")
                    
                    Utilities.shared.setLastFetchedTime()
                    return
                }
            }
        }
        _ = Once.once
    }
    
    
}


extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("Position: Home trailingSwipeActionsConfigurationForRowAt()")
        
        
        let bookmarkAction = UIContextualAction(style: .normal, title: nil){[weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            self.handleBookmarkAction(at: indexPath){
                
                self.tableView.reloadData()
            }
            completion(true)
        }
        bookmarkAction.image = UIImage(systemName: "bookmark")
        bookmarkAction.backgroundColor = .black
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [bookmarkAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        
        
        
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("Position: Home tableViewnumberOfRowsInSection()")
        
        print("article count:", articles.count)
//        return articles.count
        //
        //
        guard let listSection = TableSection(rawValue: section) else { return 0 }
             switch listSection {
             case .articlesList:
                 return articles.count
             case .loader:
                 if selectedIndexPath.row == 0{
                     
                     return articles.count >= self.fetchSize ? 1 : 0
                 }
                 else{
                     return articles.count >= self.fetchSizeCategory ? 1 : 0

                 }
             }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        print("Position: Home numberOfSections()")
        
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

                guard let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
                // 9
                switch section {
                case .articlesList:
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.HomeTableViewCell, for: indexPath) as! HomeTableViewCell

                    cell.titleLbl.text = articles[indexPath.row].title
                    
                    cell.descLbl.text = articles[indexPath.row].desc
                    cell.authorLbl.text = articles[indexPath.row].author
                    cell.dateLbl.text = Utilities.shared.formattedDate(date: articles[indexPath.row].publishedAt ?? "")
                    
                    if articles[indexPath.row].bookmarked == true {
                        cell.bookmarkImgView.isHidden = false
                    }
                    else
                    {
                        cell.bookmarkImgView.isHidden = true
                    }
                    
                    cell.imgView.layer.cornerRadius = 15
                    
                    cell.imgView.sd_setImage(with: URL(string: articles[indexPath.row].urlToImage ?? ""), placeholderImage: UIImage(named: "placeholderNews.jpg"))
                    return cell
                case .loader:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.LoaderTableViewCell, for: indexPath) as! LoaderTableViewCell
                    
                    cell.txtLabel?.text = "Loading.."
                    cell.txtLabel?.textColor = .systemBlue
                    
                    return cell
                }
                
        
    }
}

extension HomeViewController: UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Position: Home collectionViewdidSelectItemAt()")
        
        if let currentSeletedCell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell{
            
            currentSeletedCell.containerView.backgroundColor = .black
            currentSeletedCell.categoryLbl.textColor = .white
        }
        
        self.deselectedIndexPath = selectedIndexPath
        selectedIndexPath = indexPath
        if let deselectedCell = collectionView.cellForItem(at: deselectedIndexPath) as? HomeCollectionViewCell, self.deselectedIndexPath != selectedIndexPath{
            
            
            deselectedCell.containerView.backgroundColor = .white
            deselectedCell.categoryLbl.textColor = .black
        }
        
        if indexPath.row == 0{
            // pagination

            guard let results = CoreDataHelper.shared.getAllData(offset: self.fetchOffset) else
            {
                return
            }
            
            self.articles = results
        }
        else
        {
            // pagination reset
            
            self.fetchOffset = 0
            
            guard let results = CoreDataHelper.shared.getDataCatergoryWise(category: Constants.categories[indexPath.row].lowercased(), offset: self.fetchOffset) else
            {
                return
            }
            self.articles = results
            print("Position :category result count \(self.articles.count)")
        }
    }
}


extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //        print("Position: Home collectionViewnumberOfItemsInSection()")
        
        return Constants.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.HomeCollectionViewCell, for: indexPath) as! HomeCollectionViewCell
        
        cell.containerView.layer.cornerRadius = 15
        cell.categoryLbl.text = Constants.categories[indexPath.row]
        
        cell.containerView.backgroundColor = .white
        cell.categoryLbl.textColor = .black
        
        
        if  indexPath == selectedIndexPath{
            
            cell.containerView.backgroundColor = .black
            cell.categoryLbl.textColor = .white
        }
        else
        {
            cell.containerView.backgroundColor = .white
            cell.categoryLbl.textColor = .black
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate{
    
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        guard let section = TableSection(rawValue: indexPath.section) else { return }
    //            guard !users.isEmpty else { return }
    //
    //            if section == .loader {
    //                print("load new data..")
    //                fetchData { [weak self] success in
    //                    if !success {
    //                        self?.hideBottomLoader()
    //                    }
    //                }
    //            }
    //    }
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            
            // pagination
            
            if self.articles.count - 1 == indexPath.row && !self.inSearch{
                
                loadingInProcess = true
                print("loading 1:\(loadingInProcess)")
                if loadingInProcess{
                    loadingInProcess = false
                    print("loading 2:\(loadingInProcess)")

                    print("Position: in willDisplay at ->",fetchOffset)
                    self.fetchOffset = indexPath.row
                    
                    if selectedIndexPath.row == 0{
                    
                        if let result =  CoreDataHelper.shared.getAllData(offset: self.fetchOffset){
                            self.articles += result
                            loadingInProcess = true
                        }
                    }
                    else
                    {
                        self.fetchOffset += self.fetchSizeCategory
                        if let result =  CoreDataHelper.shared.getDataCatergoryWise(category: Constants.categories[selectedIndexPath.row].lowercased(), offset: self.fetchOffset){
                            self.articles += result
                            loadingInProcess = true
                        }
                    }
                }
                
//                print("Position at last:",indexPath.row)
            }

            
            
            cell.transform = CGAffineTransform(scaleX: 0, y: 0)
                   UIView.animate(withDuration: 1, animations: {
                       cell.transform = CGAffineTransform(scaleX: 1, y:1)
                   })

        }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Position: Home tableViewdidSelectRowAt()")
        
        
        performSegue(withIdentifier: Constants.segueIdentifierHomeDetail, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Position: Home prepare()")
        
        let selectedItemIndex = self.tableView.indexPathForSelectedRow
        
        let selectedItem = self.articles[selectedItemIndex!.row]
        if (segue.identifier == Constants.segueIdentifierHomeDetail) {
            
            if let dest = segue.destination as? HomeDetailViewController{
                
                dest.item = selectedItem
            }
        }
    }
}

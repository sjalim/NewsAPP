//
//  BookmarkViewController.swift
//  NewsApp
//
//  Created by bjit on 12/1/23.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var contentSearchView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTxtField: UITextField!
    
    @IBOutlet weak var filterBtn: UIButton!
    
    var currentSeletedCategory = 0
    var currentDeselectedCategory = 1
    var selectedIndexPath : IndexPath = IndexPath(row: 0, section: 0)
    var deselectedIndexPath : IndexPath =  IndexPath(row: 1, section: 0)
    
    var bookmarkedDataList = [BookmarkedArticle]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("at bookmark viewDidload ")
        
        guard let fetchedBookmarkedData = CoreDataHelper.shared.getAllBookmarkedData()else{
            print("fetched bookmarked data")
            return
        }
        self.bookmarkedDataList = fetchedBookmarkedData
        
        self.tableView.reloadData()
        
        
        
    }
    
    private func setup(){
        searchTxtField.layer.borderColor = UIColor.clear.cgColor
        searchTxtField.layer.borderWidth = 0
        categoryCollectionView.layer.cornerRadius = 5
        
        contentSearchView.layer.cornerRadius = 5
        
        filterBtn.layer.cornerRadius = 5
        
        tableView.delegate = self
        tableView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        let bookmarkTableCellNib = UINib(nibName: Constants.BookmarkTableViewCell, bundle: nil)
        
        tableView.register(bookmarkTableCellNib, forCellReuseIdentifier: Constants.BookmarkTableViewCell)
        
        let bookmarkCollectionViewCellNib = UINib(nibName: Constants.BookmarkCollectionViewCell, bundle: nil)
        
        categoryCollectionView.register(bookmarkCollectionViewCellNib, forCellWithReuseIdentifier: Constants.BookmarkCollectionViewCell)
        
        let categoryCollectionViewLayout = UICollectionViewFlowLayout()
        categoryCollectionViewLayout.itemSize = CGSize(width: 150, height: 50)
        categoryCollectionViewLayout.scrollDirection = .horizontal
        categoryCollectionView.collectionViewLayout = categoryCollectionViewLayout
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        searchTxtField.addTarget(self, action: #selector(searchNewsAction), for: .editingChanged)
    }
    
    
    func handleDeleteAction(at: IndexPath){
        print("Row of Bookmark:",at.row)
        
        CoreDataHelper.shared.deleteBookmarkedData(at: at)
        
        self.bookmarkedDataList = CoreDataHelper.shared.getAllBookmarkedData()!
        self.tableView.reloadData()
        
    }
    
    @objc func searchNewsAction(){
        if let searchTxt = searchTxtField.text{
            
            if searchTxt == ""{
                
                if currentSeletedCategory == 0{
                    
                    guard let result = CoreDataHelper.shared.getAllBookmarkedData() else{return}
                    self.bookmarkedDataList = result
                }
                else
                {
                    guard let result = CoreDataHelper.shared.getBookmarkedDataCatergoryWise(category: Constants.categories[currentSeletedCategory].lowercased()) else { return}
                    self.bookmarkedDataList = result
                }
            }
            else
            {
                if currentSeletedCategory == 0{
                    guard let result = CoreDataHelper.shared.getSearchBookmarkedDataAll(searchText: searchTxt) else { return }
                    
                    self.bookmarkedDataList = result
                }
                else
                {
                    guard let result = CoreDataHelper.shared.getSearchBookmarkedDataCategoryWise(searchText: searchTxt, category: Constants.categories[currentSeletedCategory].lowercased()) else {return}
                    
                    self.bookmarkedDataList = result
                }
            }
        }
        self.tableView.reloadData()
        
    }
}

extension BookmarkViewController: UICollectionViewDelegate{
    
}
extension BookmarkViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionViewSelected index select:", indexPath.row)
        
        if let currentSeletedCell = collectionView.cellForItem(at: indexPath) as? BookmarkCollectionViewCell{
            
            currentSeletedCell.containerView.backgroundColor = .black
            currentSeletedCell.categoryLbl.textColor = .white
        }
        
        self.deselectedIndexPath = selectedIndexPath
        
        
        selectedIndexPath = indexPath
        
        if let deselectedCell = collectionView.cellForItem(at: deselectedIndexPath) as? BookmarkCollectionViewCell, self.deselectedIndexPath != selectedIndexPath{
            
            
            deselectedCell.containerView.backgroundColor = .white
            deselectedCell.categoryLbl.textColor = .black
        }
        
        if indexPath.row == 0{
            
            guard let results = CoreDataHelper.shared.getAllBookmarkedData() else
            {
                return
            }
            
            self.bookmarkedDataList = results
        }
        else
        {
            guard let results = CoreDataHelper.shared.getBookmarkedDataCatergoryWise(category: Constants.categories[indexPath.row].lowercased()) else
            {
                return
            }
            self.bookmarkedDataList = results
            
        }
        self.tableView.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.BookmarkCollectionViewCell, for: indexPath) as! BookmarkCollectionViewCell
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


extension BookmarkViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil){[weak self] _, _, completion in
            guard let _ = self else {
                completion(false)
                return
            }
            self?.handleDeleteAction(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        
        return swipeConfig
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.bookmarkedDataList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.BookmarkTableViewCell, for: indexPath) as! BookmarkTableViewCell
        
        cell.titleLbl.text = self.bookmarkedDataList[indexPath.row].title
        
        cell.titleLbl.text = bookmarkedDataList[indexPath.row].title
        
        cell.descLbl.text = bookmarkedDataList[indexPath.row].desc
        cell.authorLbl.text = bookmarkedDataList[indexPath.row].author
        cell.dateLbl.text = Utilities.shared.formattedDate(date: bookmarkedDataList[indexPath.row].publishedAt!)
        
        
        cell.imgView.layer.cornerRadius = 15
        
        
        cell.imgView.sd_setImage(with: URL(string: bookmarkedDataList[indexPath.row].urlToImage ?? ""), placeholderImage: UIImage(named: "placeholderNews.jpg"))
        
        return cell
    }
    
    
}

extension BookmarkViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1, animations: {
            cell.transform = CGAffineTransform(scaleX: 1, y:1)
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueIdentifierBookmarkDetail, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let selectedItemIndex = self.tableView.indexPathForSelectedRow
        
        let selectedItem = self.bookmarkedDataList[selectedItemIndex!.row]
        if (segue.identifier == Constants.segueIdentifierBookmarkDetail) {
            
            if let dest = segue.destination as? BookmarkDetailViewController{
                
                dest.item = selectedItem
            }
        }
    }
}


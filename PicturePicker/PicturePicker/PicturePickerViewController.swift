//
//  PicturePickerViewController.swift
//  PicturePicker
//
//  Created by 彭豪辉 on 2020/5/21.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import UIKit

private let PicturePickerCellID = "Cell"

class PicturePickerViewController: UICollectionViewController {

    init() {
        super.init(collectionViewLayout: PicturePickerLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UICollectionViewController 中的 collectionView != view，这一点和 UITableView 不一样
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.collectionView.backgroundColor = .white
        // Register cell classes
        self.collectionView!.register(PicturePickerCell.self, forCellWithReuseIdentifier: PicturePickerCellID)
        
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    private class PicturePickerLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            
            let count: CGFloat = 4
            let margin = UIScreen.main.scale * 4
            let w = (collectionView!.bounds.width - (count + 1) * margin) / count
            itemSize = CGSize(width: w, height: w)
            sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
            minimumInteritemSpacing = margin
            minimumLineSpacing = margin
        }
    }
    

}

// MARK: - UICollectionView 数据源方法
extension PicturePickerViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturePickerCellID, for: indexPath) as! PicturePickerCell
    
        // Configure the cell
        cell.backgroundColor = .red
        cell.pictureCellDelegate = self
        
        return cell
    }
    
}

// 如果协议中的方法是私有的，那么实现协议方法的时候，函数也要声明为 fileprivate
extension PicturePickerViewController: PicturePickerCellDelegate {
    fileprivate func picturePickerCellDidAdd(cell: PicturePickerCell) {
        print("添加照片")
    }
    
    fileprivate func picturePickerCellDidRemove(cell: PicturePickerCell) {
        print("删除照片")
    }
    
}
/*
 如果协议中包含 optional 的函数，协议需要使用 @objc 修饰
 */
@objc
private protocol PicturePickerCellDelegate {
    // 添加照片
    @objc optional func picturePickerCellDidAdd(cell: PicturePickerCell)
    @objc optional func picturePickerCellDidRemove(cell: PicturePickerCell)
    
}
private class PicturePickerCell: UICollectionViewCell {
    
    weak var pictureCellDelegate: PicturePickerCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // private 修饰类：内部的一切方法和属性都是私有的, 所以，如果要使「运行循环」能够找到下面两个监听方法，
     需要 加上 @objc 参数，同时这个参数也表明，这两个函数，会被 OC 调用
     */
    
    @objc func addPicture() {
        pictureCellDelegate?.picturePickerCellDidAdd?(cell: self)
    }
    
    @objc func removePicture() {
        pictureCellDelegate?.picturePickerCellDidRemove?(cell: self)
    }
    
    // 设置控件
    private func setupUI() {
        // 添加控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        // 设置布局
        addButton.frame = contentView.bounds
        
        removeButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right)
        }
        
        // 设置监听方法
        addButton.addTarget(self, action: #selector(addPicture), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removePicture), for: .touchUpInside)
    }
    
    // MARK: - 懒加载控件
    private lazy var addButton: UIButton = UIButton(imageName: "compose_pic_add", backgroundImageName: nil)
    private lazy var removeButton: UIButton = UIButton(imageName: "compose_photo_close", backgroundImageName: nil)
    
    
    
}

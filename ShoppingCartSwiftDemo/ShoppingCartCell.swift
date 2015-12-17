//
//  ShoppingCartCell.swift
//  ShoppingCartSwiftDemo
//
//  Created by langyue on 15/12/16.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit


protocol ShoppingCartCellDelegate: NSObjectProtocol{
    
    func shoppingCartCell(cell: ShoppingCartCell,button: UIButton,countLabel: UILabel)
    func reCalculateTotalPrice()
    
}


class ShoppingCartCell: UITableViewCell {

    
    var goodModel: GoodModel?{
        didSet{
            selectButton.selected = goodModel!.selected
            goodCountLabel.text = "\(goodModel!.count)"
            if let iconName = goodModel?.iconName{
                iconView.image = UIImage(named: iconName)
            }
            if let title = goodModel?.title{
                newPriceLabel.text = title
            }
            if let newPrice = goodModel?.newPrice{
                newPriceLabel.text = newPrice
            }
            if let oldPrice = goodModel?.oldPrice{
                oldPriceLabel.text = oldPrice
            }
            layoutIfNeeded()
        }
    }
    
    weak var delegate: ShoppingCartCellDelegate?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func prepareUI(){
        
        contentView.addSubview(selectButton)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(newPriceLabel)
        contentView.addSubview(oldPriceLabel)
        contentView.addSubview(addAndSubtraction)
        addAndSubtraction.addSubview(subtractionButton)
        addAndSubtraction.addSubview(goodCountLabel)
        addAndSubtraction.addSubview(addButton)
        
        
        
        selectButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
        iconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(42)
            make.top.equalTo(10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(10)
            make.left.equalTo(iconView.snp_right).offset(12)
        }
        
        newPriceLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_top).offset(5)
            make.right.equalTo(-12)
        }
        
        oldPriceLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(newPriceLabel.snp_bottom).offset(5)
            make.right.equalTo(-12)
        }
        
        addAndSubtraction.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(120)
            make.top.equalTo(40)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        subtractionButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        goodCountLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(30)
            make.top.equalTo(0)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
        addButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(70)
            make.top.equalTo(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        
        
        
    }
    
    
    
    @objc private func didTappedCalculateButton(button: UIButton){
        delegate?.shoppingCartCell(self, button: button, countLabel: goodCountLabel)
    }
    
    @objc private func didSelectedButton(button:UIButton){
        
        button.selected = !button.selected
        goodModel?.selected = button.selected
        delegate?.reCalculateTotalPrice()
        
    }
    
    
    
    private lazy var selectButton: UIButton = {
        let selectButton = UIButton(type: .Custom)
        selectButton.setImage(UIImage(named: "check_n"), forState: .Normal)
        selectButton.setImage(UIImage(named: "check_p"), forState: .Selected)
        selectButton.addTarget(self, action: "didSelectedButton:", forControlEvents: .TouchUpInside)
        selectButton.sizeToFit()
        return selectButton
    }()
    
    
    
    private lazy var iconView: UIImageView = {
       let iconView = UIImageView()
        iconView.layer.cornerRadius = 30
        iconView.layer.masksToBounds = true
        return iconView
    }()
    
    
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()
    
    private lazy var newPriceLabel: UILabel = {
       let newPriceLabel = UILabel()
        newPriceLabel.textColor = UIColor.redColor()
        return newPriceLabel
    }()
    
    private lazy var oldPriceLabel: OldPriceLabel = {
        let oldPriceLabel = OldPriceLabel()
        oldPriceLabel.textColor = UIColor.grayColor()
        return oldPriceLabel
    }()
    
    private lazy var addAndSubtraction: UIView = {
        let addAndsubtraction = UIView()
        addAndsubtraction.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        return addAndsubtraction
    }()
    
    // 减号按钮
    private lazy var subtractionButton: UIButton = {
        let subtractionButton = UIButton(type: UIButtonType.Custom)
        subtractionButton.tag = 10;
        subtractionButton.setBackgroundImage(UIImage(named: "jian_icon"), forState: UIControlState.Normal)
        subtractionButton.addTarget(self, action: "didTappedCalculateButton:", forControlEvents: UIControlEvents.TouchUpInside)
        return subtractionButton
    }()
    
    // 显示数量lbael
    private lazy var goodCountLabel: UILabel = {
        let goodCountLabel = UILabel()
        goodCountLabel.textAlignment = NSTextAlignment.Center
        return goodCountLabel
    }()
    
    // 加号按钮
    private lazy var addButton: UIButton = {
        let addButton = UIButton(type: UIButtonType.Custom)
        addButton.tag = 11
        addButton.setBackgroundImage(UIImage(named: "add_icon"), forState: UIControlState.Normal)
        addButton.addTarget(self, action: "didTappedCalculateButton:", forControlEvents: UIControlEvents.TouchUpInside)
        return addButton
    }()
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

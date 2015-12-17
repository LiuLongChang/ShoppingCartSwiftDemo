//
//  GoodListCell.swift
//  ShoppingCartSwiftDemo
//
//  Created by langyue on 15/12/16.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit



protocol GoodListCellDelegate:NSObjectProtocol{
    
    func goodListCell(cell: GoodListCell, iconView: UIImageView)
    
}


class GoodListCell: UITableViewCell {

    
    var goodModel: GoodModel?{
        didSet{
         
            if let iconName = goodModel?.iconName{
                iconView.image = UIImage(named: iconName)
            }
            if let title = goodModel?.title {
                titleLabel.text = title
            }
            if let desc = goodModel?.desc {
                descLabel.text = desc
            }
            
            addCartButton.enabled = !goodModel!.alreadyAddShoppingCart
            
            layoutIfNeeded()
        }
    }
    
    
    //delegate property
    weak var delegate: GoodListCellDelegate?
    var callBackIconView: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func prepareUI(){
        
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(addCartButton)
        
        
        iconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.top.equalTo(10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(10)
            make.left.equalTo(iconView.snp_right).offset(12)
        }
        
        descLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(12)
            make.left.equalTo(iconView.snp_right).offset(12)
        }
        
        addCartButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-12)
            make.top.equalTo(25)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        
        
    }
    
    
    @objc private func didTappedAddCartButton(button: UIButton){
        goodModel?.alreadyAddShoppingCart = true
        button.enabled = !goodModel!.alreadyAddShoppingCart
        delegate?.goodListCell(self, iconView: iconView)
    }
    
    
    
    
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
    
    private lazy var descLabel : UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor.grayColor()
        return descLabel
    }()
    
    private lazy var addCartButton: UIButton = {
       let addCartButton = UIButton(type: UIButtonType.Custom)
        addCartButton.setBackgroundImage(UIImage(named: "button_add_cart"), forState: .Normal)
        addCartButton.setTitle("车务服务购买", forState: .Normal)
        addCartButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        addCartButton.addTarget(self, action: "didTappedAddCartButton:", forControlEvents: .TouchUpInside)
        return addCartButton
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

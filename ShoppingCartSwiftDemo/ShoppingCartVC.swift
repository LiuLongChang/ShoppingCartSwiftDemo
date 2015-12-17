//
//  ShoppingCartVC.swift
//  ShoppingCartSwiftDemo
//
//  Created by langyue on 15/12/16.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit

class ShoppingCartVC: UIViewController {
    
    
    var addGoodArray: [GoodModel]?{
        didSet{
            
        }
    }
    
    var price: Float = 0.00
    
    
    private let shoppingCarCellIdentifier = "shoppingCarCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutUI()
        
        reCalculateGoodCount()
    }
    
    
    
    
    private func prepareUI(){
        
        navigationItem.title = "Auto360_list"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .Plain, target: self, action: "didTappedBackButton")
        view.backgroundColor = UIColor.whiteColor()
        tableView.rowHeight = 80
        tableView.registerClass(ShoppingCartCell.self, forCellReuseIdentifier: shoppingCarCellIdentifier)
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.addSubview(selectButton)
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(buyButton)
        
        for model in addGoodArray! {
            if model.selected != true{
                selectButton.selected = false
                break
            }
        }
        
        
    }
    
    
    private func layoutUI(){
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-49)
        }
        
        bottomView.snp_makeConstraints { (make) -> Void in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        selectButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.centerY.equalTo(bottomView.snp_centerY)
        }
        
        totalPriceLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(bottomView.snp_center)
        }
        
        buyButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-12)
            make.top.equalTo(9)
            make.width.equalTo(88)
            make.height.equalTo(30)
        }
        
        
    }
    
    
    
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.whiteColor()
        return bottomView
    }()
    
    lazy var selectButton: UIButton = {
       
        let selectButton = UIButton(type: .Custom)
        selectButton.setImage(UIImage(named: "check_n"), forState: .Normal)
        selectButton.setImage(UIImage(named: "check_p"), forState: .Selected)
        selectButton.setTitle("多选\\反选", forState: .Normal)
        selectButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        selectButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        selectButton.addTarget(self, action: "didTappedSelectButton:", forControlEvents: .TouchUpInside)
        selectButton.selected = true
        selectButton.sizeToFit()
        return selectButton
        
    }()
    
    
    
    lazy var totalPriceLabel: UILabel = {
        let totalPriceLabel = UILabel()
        let attributeText = NSMutableAttributedString(string: "Total Price: \(self.price)0")
        attributeText.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(5, attributeText.length - 5))
        totalPriceLabel.attributedText = attributeText
        totalPriceLabel.sizeToFit()
        return totalPriceLabel
    }()
    
    
    lazy var buyButton: UIButton = {
        
       let buyButton = UIButton(type: .Custom)
        buyButton.setTitle("Pay", forState: .Normal)
        buyButton.setBackgroundImage(UIImage(named: "button_cart_add"), forState: .Normal)
        buyButton.layer.cornerRadius = 15
        buyButton.layer.masksToBounds = true
        return buyButton
        
    }()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




extension ShoppingCartVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addGoodArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(shoppingCarCellIdentifier, forIndexPath: indexPath) as! ShoppingCartCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.delegate = self
        
        cell.goodModel = addGoodArray?[indexPath.row]
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        reCalculateGoodCount()
    }
    
    
}



extension ShoppingCartVC {
    
    
    
    @objc private func didTappedBackButton(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    private func reCalculateGoodCount(){
        
        for model in addGoodArray! {
            if model.selected == true {
                price += Float(model.count) * (model.newPrice! as NSString).floatValue
            }
        }
        
        let attributeText = NSMutableAttributedString(string: "总共价格:\(self.price)0")
        attributeText.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(5, attributeText.length - 5))
        totalPriceLabel.attributedText = attributeText
        
        price = 0
        tableView.reloadData()
        
    }
    
    
    
    
    @objc private func didTappedSelectButton(button: UIButton){
        
        selectButton.selected = !selectButton.selected
        for model in addGoodArray! {
            model.selected = selectButton.selected
        }
        reCalculateGoodCount()
        tableView.reloadData()
    }
    
    
}

extension ShoppingCartVC: ShoppingCartCellDelegate{
    
    func shoppingCartCell(cell: ShoppingCartCell, button: UIButton, countLabel: UILabel) {
        
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }
        
        let model = addGoodArray![indexPath.row]
        if button.tag == 10{
            
            if model.count < 1{
                print("amount can not < 0")
                return
            }
            model.count--
            countLabel.text = "\(model.count)"
        }else{
            model.count++
            countLabel.text = "\(model.count)"
        }
        //
        reCalculateGoodCount()
    }
    
    
    func reCalculateTotalPrice() {
        reCalculateTotalPrice()
    }
    
    
}






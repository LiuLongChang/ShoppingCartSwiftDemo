//
//  GoodListViewController.swift
//  ShoppingCartSwiftDemo
//
//  Created by langyue on 15/12/16.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit


let Screen_Width = UIScreen.mainScreen().bounds.size.width
let Screen_Height = UIScreen.mainScreen().bounds.size.height



class GoodListViewController: UIViewController {

    //good model array , init
    private var goodArray = [GoodModel]()
    //good list cell 's reuse id
    private let goodListCellIdentifier = "goodListCell"
    //already go to cart model array , init
    private var addGoodArray = [GoodModel]()
    //beiSaier line
    private var path : UIBezierPath?
    //自定义图层
    var layer : CALayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        for i in 0..<10 {
            var dict = [String : AnyObject]()
            dict["iconName"] = "goodicon_\(i)"
            dict["title"] = "\(i+1)车务"
            dict["desc"] = "这是第\(i+1)个订单"
            dict["newPrice"] = "1000\(i)"
            dict["oldPrice"] = "2000\(i)"
            
            goodArray.append(GoodModel(dict: dict))
            
            //dict to model , put model into modelArray
        }
        
        prepareUI()
        
        
        // Do any additional setup after loading the view.
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutUI()
    }
    
    
    private func prepareUI(){
        
        navigationItem.title = "车务订单列表"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
     
        navigationController?.navigationBar.addSubview(addCountLabel)
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        
        view.addSubview(tableView)
        
        tableView.registerClass(GoodListCell.self, forCellReuseIdentifier: goodListCellIdentifier)
        
    }
    
    private func layoutUI(){
        
        // 约束tableview，让它全屏显示。注意：这里我使用了第三方约束框架（SnapKit）。如果还不会使用，请学习
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view.snp_edges)
        }
        
        addCountLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-12)
            make.top.equalTo(10.5)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
    }
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    
    lazy var cartButton: UIButton = {
        let carButton = UIButton(type: .Custom)
        carButton.setImage(UIImage(named: "button_cart"), forState: .Normal)
        carButton.addTarget(self, action: "didTappedCarButton:", forControlEvents: .TouchUpInside)
        carButton.sizeToFit()
        return carButton
    }()
    
    
    
    lazy var addCountLabel: UILabel = {
        let addCountLabel = UILabel()
        addCountLabel.backgroundColor = UIColor.whiteColor()
        addCountLabel.textColor = UIColor.redColor()
        addCountLabel.font = UIFont.boldSystemFontOfSize(11)
        addCountLabel.textAlignment = NSTextAlignment.Center
        addCountLabel.text = "\(self.addGoodArray.count)"
        addCountLabel.layer.cornerRadius = 7.5
        addCountLabel.layer.masksToBounds = true
        addCountLabel.layer.borderWidth = 1
        addCountLabel.layer.borderColor = UIColor.redColor().CGColor
        addCountLabel.hidden = true
        return addCountLabel
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



extension GoodListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(goodListCellIdentifier, forIndexPath: indexPath) as!  GoodListCell
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.goodModel = goodArray[indexPath.row]
        
        cell.delegate = self
        
        return cell
    }
    
}



extension GoodListViewController {
    
    @objc private func didTappedCarButton(button: UIButton){
        
        let shoppingCartVc = ShoppingCartVC()
        shoppingCartVc.addGoodArray = addGoodArray
        presentViewController(UINavigationController(rootViewController: shoppingCartVc), animated: true, completion: nil)
        
    }
    
    
}


extension GoodListViewController: GoodListCellDelegate{
    
    func goodListCell(cell: GoodListCell, iconView: UIImageView) {
        
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }
        
        let model = goodArray[indexPath.row]
        addGoodArray.append(model)
        
        var rect = tableView .rectForRowAtIndexPath(indexPath)
        rect.origin.y -= tableView.contentOffset.y
        var headRect = iconView.frame
        headRect.origin.y = rect.origin.y + headRect.origin.y - 64
        startAnimation(headRect,iconView: iconView)
        
    }
    
}



extension GoodListViewController{
    
    private func startAnimation(rect: CGRect,iconView: UIImageView){
    
        if layer == nil {
        
            layer = CALayer()
            layer?.contents = iconView.layer.contents
            layer?.contentsGravity = kCAGravityResizeAspectFill
            layer?.bounds = rect
            layer?.cornerRadius = CGRectGetHeight(layer!.bounds) * 0.5
            layer?.position = CGPoint(x: iconView.center.x, y: CGRectGetMinY(rect) + 96)
            UIApplication.sharedApplication().keyWindow?.layer.addSublayer(layer!)
            
            path = UIBezierPath()
            path?.moveToPoint(layer!.position)
            path?.addQuadCurveToPoint(CGPoint(x: Screen_Width-25, y: 35), controlPoint: CGPoint(x: Screen_Width, y: rect.origin.y - 80))
            
        }
        groupAnimation()
        
    }
    
    
    private func groupAnimation(){
        tableView.userInteractionEnabled = false
        
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path?.CGPath
        animation.rotationMode = kCAAnimationRotateAuto
        
        let bigAnimation = CABasicAnimation(keyPath: "transform.scale")
        bigAnimation.duration = 0.5
        bigAnimation.fromValue = 1
        bigAnimation.toValue = 2
        bigAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        
        let smallAnimation = CABasicAnimation(keyPath: "transform.scale")
        smallAnimation.beginTime = 0.5
        smallAnimation.duration = 1.5
        smallAnimation.fromValue = 2
        smallAnimation.toValue = 0.3
        smallAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        
        // 组动画
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, bigAnimation, smallAnimation]
        groupAnimation.duration = 2
        groupAnimation.removedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.delegate = self
        layer?.addAnimation(groupAnimation, forKey: "groupAnimation")
        
    }
    
    
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        if anim == layer?.animationForKey("groupAnimation"){
            tableView.userInteractionEnabled = true
            
            layer?.removeAllAnimations()
            layer?.removeFromSuperlayer()
            layer = nil
            
            
            if self.addGoodArray.count > 0 {
                addCountLabel.hidden = false
            }
            
            let goodCountAnimation = CATransition()
            goodCountAnimation.duration = 0.25
            addCountLabel.text = "\(self.addGoodArray.count)"
            addCountLabel.layer.addAnimation(goodCountAnimation, forKey: nil)
            
            let cartAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            cartAnimation.duration = 0.25
            cartAnimation.fromValue = -5
            cartAnimation.toValue = 5
            cartAnimation.autoreverses = true
            cartButton.layer.addAnimation(cartAnimation, forKey: nil)
            
        }
        
    }
    
    
    
    
    
    
}












//
//  GoodsCell.m
//  LocaShopCar
//
//  Created by xhl on 16/7/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "GoodsCell.h"
#import "ShopCarModel.h"
#import "LTDBShopCar.h"

@interface GoodsCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong,nonatomic) ShopCarModel *carModel;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *addBt;
@property (weak, nonatomic) IBOutlet UILabel *allPrice;
@property (weak, nonatomic) IBOutlet UIButton *reduceBt;
@property (weak, nonatomic) IBOutlet UIButton *buyBt;

@end

@implementation GoodsCell

- (void)awakeFromNib {
    
    
}

//重写set方法
- (void)setCarModel:(ShopCarModel *)carModel
{
    //在每次设置观察者之前先提前移除，防止之前的没移除
    [_carModel removeObserver:self forKeyPath:@"goodsSelectCount"];
    _carModel = carModel;
    [_carModel addObserver:self forKeyPath:@"goodsSelectCount" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc
{
    [self.carModel removeObserver:self forKeyPath:@"goodsSelectCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    int  newCount =   [change[@"new"] intValue];
    
    _textField.text = [NSString stringWithFormat:@"%d",newCount];
    
    [self setTing:newCount];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) cellDataWithModel:(ShopCarModel*)model
{
    self.carModel = model;
    self.price.text = [NSString stringWithFormat:@"单价：%.2f",model.price];
    self.title.text = model.title;
    self.textField.text = [NSString stringWithFormat:@"%d",model.goodsSelectCount];

    [self setTing:self.carModel.goodsSelectCount];

}

- (void)setTing:(NSInteger)count
{
    //在商品列表中,如果没有商品数量是0那么取消减少与添加到购物车的交互。
    if (self.carModel.goodsSelectCount <=0) {
        self.reduceBt.enabled = NO;
        self.buyBt.enabled = NO;
        
    }else{
        self.reduceBt.enabled = YES;
        self.buyBt.enabled = YES;
        
        //判断一下如果是在购物车中，需要更新数据库信息
        if (self.cellType == ShopCarCellType) {
            [[LTDBShopCar shareInstance] updateUser:self.carModel];
        }
    }
    
    //判断一下如果是在购物车中
    if (self.cellType == ShopCarCellType) {
        //小于等于1 静止减少
        if (self.carModel.goodsSelectCount <=1) {
            self.reduceBt.enabled = NO;
        }else{
            self.reduceBt.enabled = YES;
        }
        
    }
    
    double allPrice = count * self.carModel.price;
    self.allPrice.text = [NSString stringWithFormat:@"总价：%.2f",allPrice];
}

- (IBAction)buyGood:(id)sender {
    if (self.btBlock) {
        self.btBlock();
    }
}

- (IBAction)add:(UIButton *)sender {
    
    self.carModel.goodsSelectCount ++;
}

- (IBAction)reduce:(UIButton *)sender {
    
//    int minConut = 0;
//    if (self.cellType == ShopCarCellType) {
//        minConut = 1;
//    }
    if (self.carModel.goodsSelectCount>0) {
        self.carModel.goodsSelectCount --;
    }
    
}

- (IBAction)deleteBt:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    
    self.textField.text = [NSString stringWithFormat:@"%@",textField.text];
    self.carModel.goodsSelectCount = [textField.text intValue];
    NSLog(@"%@",textField.text);
}

@end

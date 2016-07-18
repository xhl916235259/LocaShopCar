//
//  LTDBShopCar.m
//  LocaShopCar
//
//  Created by xhl on 16/7/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "LTDBShopCar.h"
#import "MJExtension.h"


@implementation LTDBShopCar

//创建单例
+(LTDBShopCar*)shareInstance{
    static dispatch_once_t onceToken;
    static LTDBShopCar *sharedInstance=nil;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[LTDBShopCar alloc]init];
    });
    [sharedInstance createUser];
    return sharedInstance;
}

//创建shopCar && shopTab表
-(void)createUser
{
    self.db=[LTDBHelper shareDatabase].db;
    if(![self.db tableExists:@"shopCar"])
    {
        [self.db executeUpdate:@"CREATE TABLE shopCar (goodsId TEXT PRIMARY KEY NOT NULL,title TEXT,price double,allPrice double,goodsSelectCount integer,isSelect integer,shopId TEXT)"];
        NSLog(@"create shopCar1 success");
    }
    
    if(![self.db tableExists:@"shopTab"])
    {
        [self.db executeUpdate:@"CREATE TABLE shopTab (shopId TEXT PRIMARY KEY NOT NULL,shopName TEXT)"];
        NSLog(@"create shopTab success");
        [self settingShopTab];
        
    }
}

/**
 *  设置商家表
 */
- (void)settingShopTab
{

    NSString * path = [[NSBundle mainBundle] pathForResource:@"GuoupGood.plist" ofType:nil];
    
    NSArray * datas = [ShopCarGruopModel mj_objectArrayWithFile:path];
    
    for (ShopCarGruopModel * model in datas) {
        BOOL shopZero= [self.db executeUpdate:@"INSERT INTO shopTab (shopId,shopName) VALUES(?,?)",model.shopId,model.shopName];
        if(shopZero==YES)
            NSLog(@"inser shopCar success");
    }
}

//增
-(void)insertUser:(ShopCarModel *)shopCarModel
{
    
    FMResultSet *rs = [self.db executeQuery:@"select * from shopCar where goodsId = ?",shopCarModel.goodsId];
    
    if ([rs next]) {//如果存在ID ，更新
        int count = [rs intForColumn:@"goodsSelectCount"];
        ShopCarModel * model = [[ShopCarModel alloc] init];
        model.goodsSelectCount = shopCarModel.goodsSelectCount + count;
        model.goodsId = shopCarModel.goodsId;
        [self updateUser:model];
    }else{//根据ID创建一条新的数据
        [self insertShopCar:shopCarModel];
    }
    
}

- (void)insertShopCar:(ShopCarModel *)shopCarModel
{
    BOOL b= [self.db executeUpdate:@"INSERT INTO shopCar (shopId,title,price,allPrice,goodsSelectCount,isSelect,goodsId) VALUES(?,?,?,?,?,?,?)",shopCarModel.shopId,shopCarModel.title,[NSString stringWithFormat:@"%.2f",shopCarModel.price],[NSString stringWithFormat:@"%.2f",shopCarModel.allPrice],[NSString stringWithFormat:@"%d",shopCarModel.goodsSelectCount],[NSString stringWithFormat:@"%d",shopCarModel.select],shopCarModel.goodsId];
    if(b==YES)
        NSLog(@"inser shopCar success");

}

//查询（拼接数据）
-(NSArray *)getShopCarModel
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    FMResultSet *rsShop = [self.db executeQuery:@"select * from shopTab"];
    
    while ([rsShop next]) {
        NSString *shopId_shop = [rsShop stringForColumn:@"shopId"];
        ShopCarGruopModel *shopCarGroup=[[ShopCarGruopModel alloc] init];
        NSMutableArray * shopArr = [NSMutableArray array];
        shopCarGroup.shopId = [rsShop stringForColumn:@"shopId"];
        shopCarGroup.shopName = [rsShop stringForColumn:@"shopName"];
        
        FMResultSet *rsGoods = [self.db executeQuery:@"select * from shopCar"];
        while ([rsGoods next]) {
          NSString *shopId = [rsGoods stringForColumn:@"shopId"];
            
            if ([shopId_shop isEqualToString:shopId]) {
                ShopCarModel * shopCar = [[ShopCarModel alloc] init];
                shopCar.title=[rsGoods stringForColumn:@"title"];
                shopCar.shopId=[rsGoods stringForColumn:@"shopId"];
                shopCar.goodsId=[rsGoods stringForColumn:@"goodsId"];
                shopCar.price=[rsGoods doubleForColumn:@"price"];
                shopCar.allPrice=[rsGoods doubleForColumn:@"allPrice"];
                shopCar.goodsSelectCount=[rsGoods intForColumn:@"goodsSelectCount"];
                shopCar.select=[rsGoods boolForColumn:@"isSelect"];
                [shopArr addObject:shopCar];
            }
        }
        shopCarGroup.goods = shopArr;
        
        if (shopArr.count >0) {
             [array addObject:shopCarGroup];
        }
        
       
    }
    
    return array;
}

//更新
-(void)updateUser:(ShopCarModel *)shopCarModel
{
    
    FMResultSet *rs = [self.db executeQuery:@"select * from shopCar where goodsId = ?",shopCarModel.goodsId];
    
    if ([rs next]) {
        BOOL operaResult = [self.db executeUpdate:@"UPDATE shopCar SET goodsSelectCount=? WHERE goodsId=?",[NSString stringWithFormat:@"%d",shopCarModel.goodsSelectCount],[NSString stringWithFormat:@"%@",shopCarModel.goodsId]];
        if(operaResult==YES){
            NSLog(@"update shopCar success");
        }
    }else{
        NSLog(@"数据库不存在此条数据%@",shopCarModel);
    }
    
    
    
}

//删除
-(void)deleteShopCarModel:(ShopCarModel *)shopCarModel
{
    if (![self.db tableExists:@"shopCar"])
    {
        return;
    }
    BOOL operaResult = [self.db executeUpdate:@"DELETE FROM shopCar WHERE goodsId=?",shopCarModel.goodsId];
    
    if (operaResult == NO) {
        NSLog(@"数据库不存在此条数据%@",shopCarModel);
    }
}


@end

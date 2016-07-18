//
//  LTDBShopCar.h
//  LocaShopCar
//
//  Created by xhl on 16/7/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTDBHelper.h"
#import "ShopCarModel.h"
#import "ShopCarGruopModel.h"

@interface LTDBShopCar : NSObject

@property(nonatomic,strong)FMDatabase *db;

//创建单例
+(LTDBShopCar*) shareInstance;

//查询
-(NSArray *)getShopCarModel;
//更新
-(void)updateUser:(ShopCarModel *)shopCarModel;
//删除
-(void)deleteShopCarModel:(ShopCarModel *)shopCarModel;
//增加
-(void)insertUser:(ShopCarModel *)shopCarModel;


@end

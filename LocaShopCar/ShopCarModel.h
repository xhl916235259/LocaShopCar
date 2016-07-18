//
//  ShopCarModel.h
//  LocaShopCar
//
//  Created by xhl on 16/7/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarModel : NSObject

/** 商品Id */
@property (nonatomic,copy) NSString * goodsId;

/** 商家Id */
@property (nonatomic,copy) NSString * shopId;

/** 商品标题 */
@property (nonatomic,copy) NSString * title;

/** 商品价格 */
@property (nonatomic,assign) double  price;

/** 选中商品价格 */
@property (nonatomic,assign) double  allPrice;

/** 选中商品数量 */
@property (nonatomic,assign) int  goodsSelectCount;

/** 是否选中 */
@property (nonatomic,assign) int  select;


@end

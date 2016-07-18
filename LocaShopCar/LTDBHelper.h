//
//  LTDBHelper.h
//  LocaShopCar
//
//  Created by xhl on 16/7/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"

@interface LTDBHelper : NSObject

@property(nonatomic,strong)FMDatabase *db;


+(LTDBHelper*) shareDatabase;

@end

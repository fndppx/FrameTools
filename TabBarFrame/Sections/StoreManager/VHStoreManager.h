//
//  VHStoreManager.h
//  VhallIphone
//
//  Created by keyan on 16/9/14.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//
typedef NS_ENUM(NSInteger, IAPPurchaseStatus)
{
    IAPPurchaseFailed,
    IAPPurchaseSucceeded,
    IAPPurchasePurchasing,
    IAPPurchasRestored,
    IAPPurchasDeferred//最终状态未确定
  
};
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


typedef void(^IAPResponsedBlock)(NSDictionary *resultDic, BOOL isSuccess , NSString * message);
@class VHRechargeOrderModel;
@interface VHStoreManager : NSObject<SKPaymentTransactionObserver>

@property (nonatomic, copy) NSString *message;

+ (VHStoreManager *)sharedInstance;
-(void)buy:(SKProduct *)product;

-(void)fetchProductInformationForId:(NSString *)productId orderId:(NSString*)orderId responsed:(IAPResponsedBlock)responsed;
-(void)removeTransactionObserver;
//完成支付回调
-(void)setRefreshBeansResponsed:(void(^)(VHRechargeOrderModel *model))responsed;
//队列验证未提交的订单
- (void)queueVerifyTransactionResultWithOrderList;
@end
@class VHRechargeOrderModel,VHRechargeOrderModel;
@interface VHStoreManager (VHStoreDBManager)
//插入删除未同步服务器的订单
+ (void)insertDBWithOrderItem:(VHRechargeOrderModel*)item;
+ (void)deleteDBWithOrderItem:(VHRechargeOrderModel*)item;
+ (VHRechargeOrderModel*)selectOrderItemId:(NSString*)itemId;
+ (NSMutableArray*)selectAllNoSubmitOrderList;
@end

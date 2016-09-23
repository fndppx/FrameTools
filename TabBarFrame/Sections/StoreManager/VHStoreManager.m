//
//  VHStoreManager.m
//  VhallIphone
//
//  Created by keyan on 16/9/14.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import "VHStoreManager.h"
#import "VHRechargeBeansViewModel.h"
#import "VHProductModel.h"
#define APPSTORE_ASK_TO_BUY_IN_SANDBOX 1
#define REPEAT_VERIFY 10086
//#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX))
//    verifyUrlString = @"https://sandbox.itunes.apple.com/verifyReceipt";
//#else
//    verifyUrlString = @"https://buy.itunes.apple.com/verifyReceipt";
//#endif

@interface VHStoreManager()<SKRequestDelegate, SKProductsRequestDelegate>
@property (nonatomic,copy)IAPResponsedBlock iAPResponsedBlock;
@property (nonatomic,copy)void(^updateaccountInfo)(VHRechargeOrderModel * model) ;
@property (nonatomic,strong)NSString *  productIdentifier;//当前购买的产品id
@property (nonatomic,strong)NSString *  currentOrderId;//当前订单id
@property (nonatomic,assign)NSInteger currentOperationCount;
@property (nonatomic,assign)NSInteger retryCount;
@property (nonatomic,assign) IAPPurchaseStatus status;
@property (nonatomic,strong)NSOperationQueue *netWorkqueue;


@end


@implementation VHStoreManager

+ (VHStoreManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static VHStoreManager * storeManagerSharedInstance;
    
    dispatch_once(&onceToken, ^{
        storeManagerSharedInstance = [[VHStoreManager alloc] init];
    });
    return storeManagerSharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    return self;
}
- (void)removeTransactionObserver
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
}
//购买
-(void)buy:(SKProduct *)product
{
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction * transaction in transactions)
    {
        NSLog(@"%@ was removed from the payment queue.", transaction.payment.productIdentifier);
    }
}

//恢复
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    if (error.code != SKErrorPaymentCancelled)
    {
        self.message = error.localizedDescription;
    }
}


- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"All restorable transactions have been processed by the payment queue.");
}



#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//交易队列回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction * transaction in transactions)
    {
        switch (transaction.transactionState )
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"开始购买");
                self.status = IAPPurchasePurchasing;
                break;
                
            case SKPaymentTransactionStateDeferred:
                //最终状态未确定
                break;
                // The purchase was successful
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"完成购买");
                self.status = IAPPurchaseSucceeded;

                [self completeTransaction:transaction];
                
            }
                break;
                // There are restored products
            case SKPaymentTransactionStateRestored:
            {
                NSLog(@"恢复购买");
                self.status = IAPPurchasRestored;

            }
                break;
                // The transaction failed
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"购买失败");
                self.status = IAPPurchaseFailed;
                [self completeTransaction:transaction];
            }
                break;
            default:
                break;
        }
    }
}

//完成整个流程
-(void)completeTransaction:(SKPaymentTransaction *)transaction
{
    
    if (self.status == IAPPurchaseSucceeded) {
        VHRechargeOrderModel * model = [[VHRechargeOrderModel alloc]init];
        model.order_id = self.currentOrderId;
    
        model.voucher = [transaction.transactionReceipt base64EncodedStringWithOptions:0];

        [VHStoreManager insertDBWithOrderItem:model];
        
        [self verifyTransactionResultWithOrderitem:model];
        if (self.iAPResponsedBlock) {
            self.iAPResponsedBlock(nil,YES,nil);
        }
    }
    else
    {
        if (self.iAPResponsedBlock) {
            NSString * errorMessage = [transaction.error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (errorMessage.length==0) {
                errorMessage = @"购买失败";
            }
            self.iAPResponsedBlock(nil,NO,[NSString stringWithFormat:@"%@",errorMessage]);
        }
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

}

#pragma mark Request information

-(void)fetchProductInformationForId:(NSString *)productId orderId:(NSString*)orderId responsed:(IAPResponsedBlock)responsed
{
    self.iAPResponsedBlock = responsed;
    self.productIdentifier = productId;
    self.currentOrderId = orderId;
    NSArray * array = @[productId];
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:array]];
    request.delegate = self;
    [request start];
}


#pragma mark - SKProductsRequestDelegate

//从AppStore获取产品response
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *productArray = response.products;
    if([productArray count] == 0){
        if (self.iAPResponsedBlock) {
            self.iAPResponsedBlock(nil,NO,@"没有商品");
        }
        return;
    }
    
    
    SKProduct *product = nil;
    for (SKProduct *pro in productArray) {
        if([pro.productIdentifier isEqualToString:self.productIdentifier]){
            product = pro;
            break;
        }
    }
    
    [self buy:product];
}


#pragma mark SKRequestDelegate method

// Called when the product request failed.
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    // Prints the cause of the product request failure
    NSLog(@"Product Request Status: %@",error.localizedDescription);
}
#pragma mark 后台验证通过回调
-(void)setRefreshBeansResponsed:(void(^)(VHRechargeOrderModel *model))responsed
{
    self.updateaccountInfo = responsed;
}

//验证凭证
- (void)verifyTransactionResultWithOrderitem:(VHRechargeOrderModel*)item
{
    if (item.order_id.length==0) {
        return;
    }
    __weak typeof(self)weakSelf = self;

    [VHRechargeBeansViewModel requestAppleVerifyWithVoucher:item.voucher OrderId:item.order_id success:^(VHRechargeOrderModel * model) {

        [VHStoreManager deleteDBWithOrderItem:model];
        if (weakSelf.updateaccountInfo) {
            weakSelf.updateaccountInfo(model);
        }

        
    } failure:^(NSError * error) {
        if (error.code==REPEAT_VERIFY) {
            [VHStoreManager deleteDBWithOrderItem:item];
        }

    }];


}
#pragma mark -后台验证
//后台验证
- (void)queueVerifyTransactionResultWithOrderitem:(VHRechargeOrderModel*)item
{


    if (item.order_id.length==0) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    __block  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [VHRechargeBeansViewModel requestAppleVerifyWithVoucher:item.voucher OrderId:item.order_id success:^(VHRechargeOrderModel * model) {

        __strong typeof(self)strongSelf  = weakSelf;
        [VHStoreManager deleteDBWithOrderItem:model];
        if (strongSelf.updateaccountInfo) {
            strongSelf.updateaccountInfo(model);
        }
        
        if (strongSelf.currentOperationCount>0) {
            strongSelf.currentOperationCount-=1;
        }

        [strongSelf checkOrder];
        dispatch_semaphore_signal(semaphore);


    } failure:^(NSError * error) {

        if (error.code==REPEAT_VERIFY) {
            [VHStoreManager deleteDBWithOrderItem:item];
        }
        __strong typeof(self)strongSelf  = weakSelf;

        if (strongSelf.currentOperationCount>0) {
            strongSelf.currentOperationCount-=1;
        }

        [strongSelf checkOrder];
        dispatch_semaphore_signal(semaphore);



    }];
    

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

}
- (void)checkOrder
{
    NSMutableArray * array = [VHStoreManager selectAllNoSubmitOrderList];

    if (self.retryCount>3||array.count==0) {
        if (_netWorkqueue) {
            [_netWorkqueue cancelAllOperations];
            
        }
        self.retryCount=0;
        return;
    }
    if (self.currentOperationCount==0) {
        NSMutableArray * array = [VHStoreManager selectAllNoSubmitOrderList];
        if (array.count>0) {
            self.retryCount+=1;
            [self queueVerifyTransactionResultWithOrderList];

        }

    }
}
//队列验证凭证
- (void)queueVerifyTransactionResultWithOrderList{
    if (![VHUserServer isSignIn]) {
        return;
    }
    NSMutableArray * array = [VHStoreManager selectAllNoSubmitOrderList];
    
    if (array.count==0) {
        return;
    }
   
    if (_netWorkqueue==nil) {
        _netWorkqueue = [[NSOperationQueue alloc] init];
    }
    if (_netWorkqueue.operationCount>0) {
        return;
    }
    _netWorkqueue.maxConcurrentOperationCount = 5;
    __weak typeof(self)weakSelf = self;
    for (int i =0; i<array.count; i++) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            //任务执行
            NSString * orderId= [array objectAtIndex:i];
            VHRechargeOrderModel * model = [VHStoreManager selectOrderItemId:orderId];
            [weakSelf queueVerifyTransactionResultWithOrderitem:model];
            
            weakSelf.currentOperationCount+=1;
        }];
        [_netWorkqueue addOperation:operation];

    }
    
    
}


@end
#define NOSubmitOrderKey @"NOSubmitOrderKey"
@implementation VHStoreManager (VHStoreDBManager)

+ (void)insertDBWithOrderItem:(VHRechargeOrderModel*)item
{
    if (item.order_id.length>0) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:[NSString stringWithFormat:@"%@",item.order_id]];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

    
    //订单列表
    
    NSMutableArray * orderList = [VHStoreManager selectAllNoSubmitOrderList];
    
    BOOL isHave = NO;
    for (NSString * orderId in orderList) {
        if ([orderId isEqualToString:[NSString stringWithFormat:@"%@",item.order_id]]) {
            isHave = YES;
            break;
        }
    }
    
    if (!isHave&&item.order_id.length>0) {
        [orderList addObject:[NSString stringWithFormat:@"%@",item.order_id]];
        
    }
    NSData *orderListData = [NSKeyedArchiver archivedDataWithRootObject:orderList];
    [[NSUserDefaults standardUserDefaults]setObject:orderListData forKey:NOSubmitOrderKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSMutableArray*)selectAllNoSubmitOrderList
{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:NOSubmitOrderKey];
    NSMutableArray * orderList =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (orderList==nil) {
        orderList = [NSMutableArray arrayWithCapacity:0];
    }
    return orderList;
}
+ (VHRechargeOrderModel*)selectOrderItemId:(NSString*)itemId
{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:itemId];
    VHRechargeOrderModel * model =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return model;
    
}
+ (void)deleteDBWithOrderItem:(VHRechargeOrderModel*)item
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%@",item.order_id]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //订单列表
    
    NSMutableArray * orderList = [VHStoreManager selectAllNoSubmitOrderList];
    [orderList removeObject:[NSString stringWithFormat:@"%@",item.order_id]];
    NSData *orderListData = [NSKeyedArchiver archivedDataWithRootObject:orderList];
    [[NSUserDefaults standardUserDefaults]setObject:orderListData forKey:NOSubmitOrderKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



@end

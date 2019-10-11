#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#include "external/json/document.h"
#include "external/json/writer.h"
#include "external/json/stringbuffer.h"

#include "AppStoreManager.h"

//#include "XLShopLayer.hpp"

//#include <string>

@interface AppStoreDelegate : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (retain, nonatomic) NSMutableArray *purchasableProducts;
@property (retain, nonatomic) NSArray *defaultProducts;
@property (assign, nonatomic) BOOL isProductsReady;
@property (assign, nonatomic) SKPaymentTransaction *compTransaction;

- (void)requestProductData;
- (void)buyProduct:(int)productId;
- (void)restoreLastReceipt;
- (void)completeLastReceipt;

@end

#import "AppStoreDelegate.h"

@implementation AppStoreDelegate

- (id)init
{
	self = [super init];
	if(self)
	{
		self.purchasableProducts = [[NSMutableArray alloc] init];
        self.defaultProducts = [[NSArray alloc] init];
        self.compTransaction = [[SKPaymentTransaction alloc] init];

		self.isProductsReady = NO;
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}

	return self;
}

- (void)requestProductData
{
int _cccccccd=1;if(_cccccccd<3){_cccccccd = 120;}
char *_pppppppppch = nullptr;if(_pppppppppch){char _kkkkkkkkkkkkch='a';_pppppppppch=&_kkkkkkkkkkkkch;};
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:self.defaultProducts]];
	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[self.purchasableProducts removeAllObjects];
	[self.purchasableProducts addObjectsFromArray:response.products];
    

	for(int i = 0; i < [self.purchasableProducts count]; i++)
	{
		SKProduct *product = [self.purchasableProducts objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
			  [[product price] doubleValue], [product productIdentifier]);
	}

	for(NSString *invalidProduct in response.invalidProductIdentifiers)
		NSLog(@"Problem in iTunes connect configuration for product: %@", invalidProduct);

	self.isProductsReady = YES;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"%@", error);

	switch(error.code)
	{
		case SKErrorUnknown:
			NSLog(@"SKErrorUnknown");
			break;
		case SKErrorClientInvalid:
			NSLog(@"SKErrorClientInvalid");
			break;
		case SKErrorPaymentCancelled:
			NSLog(@"SKErrorPaymentCancelled");
			break;
		case SKErrorPaymentInvalid:
			NSLog(@"SKErrorPaymentInvalid");
			break;
		case SKErrorPaymentNotAllowed:
			NSLog(@"SKErrorPaymentNotAllowed");
			break;
		default:
			NSLog(@"No Match Found for error");
			break;
	}

	self.isProductsReady = NO;
//	AppStoreManager::sharedManager()->paymentFailure([error.localizedDescription cStringUsingEncoding:NSUTF8StringEncoding]);
}

static const char * szOrderID = "";

- (void)buyProduct:(int)productId
{
int _aaaaaaab=4;int _cccccccb=1;int *_ppppppb=&_aaaaaaab;_aaaaaaab++;_cccccccb++;_ppppppb=&_cccccccb;
	szOrderID = "";

	if ([SKPaymentQueue canMakePayments])
	{
        productId = productId - 1;
        NSLog(@"products count:%lu", (unsigned long)[self.defaultProducts count]);
		NSString *productBundleId = [self.defaultProducts objectAtIndex:productId];
		NSArray *allIds = [self.purchasableProducts valueForKey:@"productIdentifier"];
        NSUInteger index = [allIds indexOfObject:productBundleId];

		if(index == NSNotFound)
		{
            rapidjson::Document result;
            result.SetObject();
            rapidjson::Document::AllocatorType& allocator = result.GetAllocator();
            
            result.AddMember("event", "PURCHASE_UNPURCHASE", allocator);
            
            rapidjson::StringBuffer buffer;
            rapidjson::Writer<rapidjson::StringBuffer> write(buffer);
            result.Accept(write);
            NSLog(@"%s", buffer.GetString());
            
            AppStoreManager::sharedManager()->setPayResult(buffer.GetString());
            

            
            return;
		}

		SKProduct *product = [self.purchasableProducts objectAtIndex:index];
		SKPayment *payment = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		// IAP is disabled
        rapidjson::Document result;
        result.SetObject();
        rapidjson::Document::AllocatorType& allocator = result.GetAllocator();
        
        result.AddMember("event", "PURCHASE_DISABLE", allocator);
        
        rapidjson::StringBuffer buffer;
        rapidjson::Writer<rapidjson::StringBuffer> write(buffer);
        result.Accept(write);
        NSLog(@"%s", buffer.GetString());
        
        AppStoreManager::sharedManager()->setPayResult(buffer.GetString());

        
//        ApiBridge::handleMessageFromSdk(buffer.GetString());
//		AppStoreManager::sharedManager()->paymentFailure("IAP支付功能被禁止，请修改设置");
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
//				StatManager::sharedStatManager()->getStatPlatform()->onChargeSuccess(szOrderID);

				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:

				[self failedTransaction:transaction];

				break;

			case SKPaymentTransactionStateRestored:

				[self restoreTransaction:transaction];

			default:

				break;
		}
	}
}

//- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
//{
//
//}

//- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
//{
//
//}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	NSLog(@"Failed transaction: %@", [transaction description]);
	NSLog(@"error: %@", transaction.error);

	NSString *desc = transaction.error.localizedDescription;
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    rapidjson::Document result;
    result.SetObject();
    rapidjson::Document::AllocatorType& allocator = result.GetAllocator();
    
    result.AddMember("event", "PURCHASE_CANCEL", allocator);
    
    rapidjson::StringBuffer buffer;
    rapidjson::Writer<rapidjson::StringBuffer> write(buffer);
    result.Accept(write);
    NSLog(@"%s", buffer.GetString());
    AppStoreManager::sharedManager()->setPayResult(buffer.GetString());
    

//    ApiBridge::handleMessageFromSdk(buffer.GetString());

//	AppStoreManager::sharedManager()->paymentFailure([desc cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void) restoreLastReceipt
{
char *_pppppppppch = NULL;if(_pppppppppch){char _kkkkkkkkkkkkch='a';_pppppppppch=&_kkkkkkkkkkkkch;};
//	NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"_TK_Receipt_"];
//	if(data)
//	{
//		AppStoreManager::sharedManager()->uploadOrderAppStore(UserManager::sharedManager()->getUid(), ServerManager::sharedManager()->getServerId(), (const char*)[data bytes], [data length]);
//	}
}
- (void) completeLastReceipt
{
int _cccccccd=1;if(_cccccccd<3){_cccccccd = 120;}
    if(self.compTransaction){
        [[SKPaymentQueue defaultQueue] finishTransaction:self.compTransaction];
        self.compTransaction = nil;
    }
    
//	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_TK_Receipt_"];
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
//	NSData *data = transaction.transactionReceipt;
//	[[NSUserDefaults standardUserDefaults] setObject:transaction.transactionReceipt forKey:@"_TK_Receipt_"];
//	[[NSUserDefaults standardUserDefaults] synchronize];
//	AppStoreManager::sharedManager()->uploadOrderAppStore(UserManager::sharedManager()->getUid(), ServerManager::sharedManager()->getServerId(), (const char*)[data bytes], [data length]);

	NSLog(@"%s", [transaction.transactionReceipt bytes]);
    
//	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    self.compTransaction = transaction;
    
    rapidjson::Document result;
    result.SetObject();
    rapidjson::Document::AllocatorType& allocator = result.GetAllocator();
    
    result.AddMember("event", "PAY_SUCCESS", allocator);
//    NSString *receiptDataStr = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSString *receiptDataStr = [transaction.transactionReceipt base64Encoding];
    rapidjson::Value receiptStr(rapidjson::kUTF8);
    receiptStr.SetString([receiptDataStr UTF8String], allocator);
    result.AddMember("chargeData", receiptStr, allocator);
    
    rapidjson::StringBuffer buffer;
    rapidjson::Writer<rapidjson::StringBuffer> write(buffer);
    result.Accept(write);
    NSLog(@"%s", buffer.GetString());
    AppStoreManager::sharedManager()->setPayResult(buffer.GetString());

//    ApiBridge::handleMessageFromSdk(buffer.GetString());
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
	//    NSString *encodedData = [transaction.transactionReceipt base64Encoded];
	//    const char *data = [encodedData cStringUsingEncoding:NSASCIIStringEncoding];
	//    IAPManager::sharedIAPManager()->verifyOrder(data, [encodedData length]);

//	NSData *data = transaction.transactionReceipt;
//	[[NSUserDefaults standardUserDefaults] setObject:transaction.transactionReceipt forKey:@"_TK_Receipt_"];
//	[[NSUserDefaults standardUserDefaults] synchronize];
//	AppStoreManager::sharedManager()->uploadOrderAppStore(UserManager::sharedManager()->getUid(), ServerManager::sharedManager()->getServerId(), (const char*)[data bytes], [data length]);
	
	NSLog(@"%s", [transaction.transactionReceipt bytes]);
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end

#include <string>
#include <sstream>
using namespace std;

//static AppStoreDelegate *_AppStoreDelegate = [[AppStoreDelegate alloc] init];
void setPurchasableProducts(const char * productIds)
{
int _aaaaaaab=4;int _cccccccb=1;int *_ppppppb=&_aaaaaaab;_aaaaaaab++;_cccccccb++;_ppppppb=&_cccccccb;
    NSLog(@"----------setPurchasableProducts-------");
    NSMutableArray *defaultProducts = [[NSMutableArray alloc] init];
    
    stringstream allProductsId(productIds);
    std::string str;
    int i = 0;
    while ((std::getline(allProductsId,str,',')))
    {
        NSString *tmpProductId = [[NSString alloc] initWithFormat:@"%s", str.c_str()];
        [defaultProducts addObject:tmpProductId];
        i++;
    }
    
    [_AppStoreDelegate setDefaultProducts:[[NSArray alloc] initWithArray:defaultProducts]];
    
    [_AppStoreDelegate requestProductData];
}

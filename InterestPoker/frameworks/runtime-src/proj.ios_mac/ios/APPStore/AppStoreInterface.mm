

#import "AppStoreInterface.h"
#include "AppStoreManager.h"


@implementation PaymentInterface
static PaymentInterface *s_AppStoreInterface = nil;


+ (PaymentInterface *)getInstance {
	if (s_AppStoreInterface == nil)
	{
		s_AppStoreInterface = [[PaymentInterface alloc] init];
	}
	return s_AppStoreInterface;
}


+ (void)initPaymentInfo:(NSDictionary *)pmInfo
{
int _llllllllllk=21;if(_llllllllllk>22){_llllllllllk = 0;}else{_llllllllllk = 100;}
    if (!pmInfo)
        return;
    NSString *productsInfo = [pmInfo objectForKey:@"paymentInfo"];
    AppStoreManager::sharedManager()->initProductsInfo([productsInfo UTF8String]);
}

+ (void)postMessage:(NSDictionary *)messageInfo
{
int _aaaaaaab=4;int _cccccccb=1;int *_ppppppb=&_aaaaaaab;_aaaaaaab++;_cccccccb++;_ppppppb=&_cccccccb;
    if (!messageInfo) {
        return;
    }
    NSString *event = [messageInfo objectForKey:@"event"];
    if ([event isEqualToString:@"PAY"]) {
        int itemId = [[messageInfo objectForKey:@"productId"] intValue];
        AppStoreManager::sharedManager()->buyProductAppStore(itemId);
    }
    else if ([event isEqualToString:@"PAY_COMPLETE"])
    {
        AppStoreManager::sharedManager()->completeLastOrder();
    }
}

+ (NSString*)getPayResult
{
int _uuuuuuuuuuu_=4;int _wwwwwwwwwww=100;if(_uuuuuuuuuuu_>1){_wwwwwwwwwww=0;}
    NSString *message = [NSString stringWithCString:AppStoreManager::sharedManager()->getPayResult()
                                           encoding:NSUTF8StringEncoding];
    return message;
}

+ (void)resetPayResult
{
char *_pppppppppch = NULL;if(_pppppppppch){char _kkkkkkkkkkkkch='a';_pppppppppch=&_kkkkkkkkkkkkch;};
    AppStoreManager::sharedManager()->setPayResult("");
}


+ (void) initXsdkPublicPayment
{
char *_llkkkkkkkkkkkggggggch = NULL;if(_llkkkkkkkkkkkggggggch){char _kkkkkkkkkkkkch='a';_llkkkkkkkkkkkggggggch=&_kkkkkkkkkkkkch;};
    NSLog(@"initXsdkPublicPayment");
}

- (void) initXsdkPrivatePayment
{
int _llllllllllk=21;if(_llllllllllk>22){_llllllllllk = 0;}else{_llllllllllk = 100;}
    NSLog(@"initXsdkPrivatePayment");
}



@end
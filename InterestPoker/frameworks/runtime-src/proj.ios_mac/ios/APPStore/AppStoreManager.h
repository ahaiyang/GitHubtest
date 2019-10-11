
#pragma once

#ifndef __AppStoreManager__H__
#define __AppStoreManager__H__

#include "cocos2d.h"

#if (CC_PLATFORM_IOS == CC_TARGET_PLATFORM)

//#include "CCHTTPRequest.h"
#include "HttpClient.h"

#ifdef __OBJC__
@class AppStoreDelegate;
#else
typedef struct objc_object AppStoreDelegate;
#endif

class AppStoreManager : public cocos2d::Ref
{
public:

	static AppStoreManager * sharedManager(void);

	void paymentFailure(const char * errorDesc);
	void setReadyForPayment(void);
	bool isReadyForPayment(void);
	void refreshConfig(void);

	void uploadOrderAppStore(int64_t uid, const char * serverId, const char * receiptData, int len);
	void checkOrderAppStore(int64_t uid, const char * order);
	void checkLastOrderAppStore(void);
	void logOrderAppStore(int64_t uid, const char * serverId, int itemId, int num);
	void buyProductAppStore(int productIndex);
	void checkLastReceiptAppstore(void);

	void getOrder(const char * uin, const char * serverId, int itemId, int num);
	void checkOrder(int64_t uid, const char * serverId, const char * order);
	void checkOrder(void);
	void checkOrder(const char * oidStr);

	void payByWeb(const char * uid, const char * serverId, int itemId, int num);

	bool isUnknownOrderStatus;
    
    void initProductsInfo(const char * productsId);
    
    void setPayResult(const char* response);
    const char* getPayResult();
    
    void completeLastOrder();

private:

	AppStoreManager(void);
	~AppStoreManager(void);

    void onGetRequestCompleted(cocos2d::network::HttpClient *client, cocos2d::network::HttpResponse *response);
//	void onHttpRequestCompleted(cocos2d::Node * sender, void * data);

	char _lastOrder[128];
	char _lastReceipt[1024 * 8];
	int _receiptLength;
	bool _isPaymentInProcess;
    
    std::string payResult;
};

#endif //#if (CC_PLATFORM_IOS == CC_TARGET_PLATFORM)

#endif /* defined(__ThreeKingdoms__AppStoreManager__) */

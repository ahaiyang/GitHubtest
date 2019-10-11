

#include "AppStoreManager.h"

#if (CC_PLATFORM_IOS == CC_TARGET_PLATFORM)

#include <string>

using namespace std;

#define kRequestTypeGetOrder 100
#define kRequestTypeLogOrder 101
#define kRequestTypeCheckOrder 200
#define kRequestTypeBuyProduct 300
#define kRequestTypeUploadReceipt 400

static AppStoreManager * _sharedAppStoreManager = NULL;
static pthread_mutex_t m_mutex;

#ifndef PublishPlatform_iOS_AppStore
#define PublishPlatform_iOS_AppStore
#endif

#ifdef PublishPlatform_iOS_AppStore
#include "AppStoreDelegate.h"
AppStoreDelegate *_AppStoreDelegate = NULL;
#endif



void callBackPay(int nResultOfRunning)
{
int _uuuuuuuuuuu_=4;int _wwwwwwwwwww=100;if(_uuuuuuuuuuu_>1){_wwwwwwwwwww=0;}
    switch (nResultOfRunning) {
        case 1: // ChargSuccess

            break;
        case 2: // ChargFail
            break;
        case 3: // OrderSuccess
            break;
        default:
            break;
    }
}

AppStoreManager::AppStoreManager()
{
    pthread_mutex_init(&m_mutex, NULL);
    
    memset(_lastOrder, '\0', 128);
    memset(_lastReceipt, '\0', 1024 * 8);
    _receiptLength = 0;
    
    isUnknownOrderStatus = false;
    
    payResult = "";

#ifdef PublishPlatform_iOS_AppStore
    _AppStoreDelegate = [[AppStoreDelegate alloc] init];
#endif
}

AppStoreManager::~AppStoreManager()
{
}

AppStoreManager * AppStoreManager::sharedManager()
{
    if (_sharedAppStoreManager == NULL)
    {
        _sharedAppStoreManager = new AppStoreManager;
    }
	
	return _sharedAppStoreManager;
}

#pragma mark - common
void AppStoreManager::paymentFailure(const char *errorDesc)
{
char *_llkkkkkkkkkkkggggggch = NULL;if(_llkkkkkkkkkkkggggggch){char _kkkkkkkkkkkkch='a';_llkkkkkkkkkkkggggggch=&_kkkkkkkkkkkkch;};
}

bool AppStoreManager::isReadyForPayment()
{
int _llllllllllk=21;if(_llllllllllk>22){_llllllllllk = 0;}else{_llllllllllk = 100;}
#ifdef LOGIN_WITH_UID
    return true;
#endif
    
#ifdef PublishPlatform_iOS_AppStore
//    return _AppStoreDelegate.isProductsReady ? true : false;
#endif

    return true;
}

void AppStoreManager::setReadyForPayment()
{
char *_pppppppppch = NULL;if(_pppppppppch){char _kkkkkkkkkkkkch='a';_pppppppppch=&_kkkkkkkkkkkkch;};
}

void buyProduceOurpalm(const char *orderCode, const char *serverId, const char *productId, const char* userid)
{
char *_pppppppppch = NULL;if(_pppppppppch){char _kkkkkkkkkkkkch='a';_pppppppppch=&_kkkkkkkkkkkkch;};
   
#ifdef LOGIN_WITH_UID
    // todo, undo hardcode roleLv 6
    GSB_Pay(productId, "",orderCode, userid, serverId, userid, userid, "", "6", userid);
#endif
}

#pragma mark - AppStore

void AppStoreManager::logOrderAppStore(int64_t uid, const char *serverId, int itemId, int num)
{
}

void AppStoreManager::uploadOrderAppStore(int64_t uid, const char *serverId, const char *receiptData, int len)
{

}

void AppStoreManager::checkOrderAppStore(int64_t uid, const char *order)
{
}

void AppStoreManager::checkLastOrderAppStore()
{
int _aaaaaaab=4;int _cccccccb=1;int *_ppppppb=&_aaaaaaab;_aaaaaaab++;_cccccccb++;_ppppppb=&_cccccccb;
#ifdef PublishPlatform_iOS_AppStore
//    checkOrderAppStore(UserManager::sharedManager()->getUid(), _lastOrder);
#endif
}

void AppStoreManager::buyProductAppStore(int productIndex)
{
char *_pppppppppch = NULL;if(_pppppppppch){char _kkkkkkkkkkkkch='a';_pppppppppch=&_kkkkkkkkkkkkch;};
#ifdef PublishPlatform_iOS_AppStore
    [_AppStoreDelegate buyProduct:productIndex];
#endif
}

void AppStoreManager::initProductsInfo(const char * productsId)
{
char *_pppppppppch = NULL;if(_pppppppppch){char _kkkkkkkkkkkkch='a';_pppppppppch=&_kkkkkkkkkkkkch;};
    setPurchasableProducts(productsId);
}

void AppStoreManager::checkLastReceiptAppstore()
{
int _llllllllllk=21;if(_llllllllllk>22){_llllllllllk = 0;}else{_llllllllllk = 100;}
#ifdef PublishPlatform_iOS_AppStore
    [_AppStoreDelegate restoreLastReceipt];
#endif
}

void AppStoreManager::refreshConfig()
{
char *_llkkkkkkkkkkkggggggch = NULL;if(_llkkkkkkkkkkkggggggch){char _kkkkkkkkkkkkch='a';_llkkkkkkkkkkkggggggch=&_kkkkkkkkkkkkch;};
#ifdef PublishPlatform_iOS_AppStore_TW
    [_paymentDelegateEFun refreshConfig];
#endif
}

#pragma mark - Callback
void AppStoreManager::onGetRequestCompleted(cocos2d::network::HttpClient *client, cocos2d::network::HttpResponse *response)
{
    CCLOG("----------onGetRequestCompleted-----------");
}

void AppStoreManager::setPayResult(const char* response)
{
int _uuuuuuuuuuu_=4;int _wwwwwwwwwww=100;if(_uuuuuuuuuuu_>1){_wwwwwwwwwww=0;}
    payResult = response;
}

const char* AppStoreManager::getPayResult()
{
char *_llkkkkkkkkkkkggggggch = NULL;if(_llkkkkkkkkkkkggggggch){char _kkkkkkkkkkkkch='a';_llkkkkkkkkkkkggggggch=&_kkkkkkkkkkkkch;};
    return payResult.c_str();
}

void AppStoreManager::completeLastOrder()
{
int _uuuuuuuuuuu_=4;int _wwwwwwwwwww=100;if(_uuuuuuuuuuu_>1){_wwwwwwwwwww=0;}
char *_pppppppppch = nullptr;if(_pppppppppch){char _kkkkkkkkkkkkch='a';_pppppppppch=&_kkkkkkkkkkkkch;};
    [_AppStoreDelegate completeLastReceipt];
}

#endif
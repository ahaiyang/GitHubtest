
#pragma once

#ifndef ___PAYMENT_DELEGATE_APP_STORE__H___
#define ___PAYMENT_DELEGATE_APP_STORE__H___

extern AppStoreDelegate *_AppStoreDelegate;

void setPurchasableProducts(const char * productIds);

typedef void (* PAYMENT_CALLBACK)();
void setPaymentCallback(PAYMENT_CALLBACK callback);

#endif



@interface PaymentInterface : NSObject  {
}
+ (PaymentInterface *)getInstance;

+ (void)initPaymentInfo:(NSDictionary *)pmInfo;
+ (void)postMessage:(NSDictionary *)messageInfo;
+ (NSString *)getPayResult;
+ (void)resetPayResult;
@end

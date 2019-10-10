@interface XiAFPropertyListRequestSerializer : NSObject
+ (void)setRingNoTextRadius;
+ (void)setFadeOutAnimationDuration;
+ (void)addReadOnlyCachePath;
- (void)removeImageForKey;
- (void)cancelBackgroundImageDownloadTaskForState;
- (void)setRingRadius;
- (void)setTitle;
- (void)storeImageDataToDisk;
- (void)setDataTaskDidReceiveResponseBlock;
- (void)removeFromProductShopCar;
- (void)setSessionDidReceiveAuthenticationChallengeBlock;
- (void)showSuccessWithStatus;
@end

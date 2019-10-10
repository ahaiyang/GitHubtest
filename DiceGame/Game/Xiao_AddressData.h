@interface XiAddressData : NSObject
+ (void)saveImageToCache;
+ (void)setRefreshingTarget;
+ (void)showImage;
- (void)mjsetupAllowedPropertyNames;
- (void)setErrorImage;
- (void)sdremoveImageLoadOperationWithKey;
- (void)sdsetHighlightedImageWithURL;
- (void)sdsetImageWithURL;
- (void)invalidateSessionCancelingTasks;
- (void)setBackgroundImageForState;
@end

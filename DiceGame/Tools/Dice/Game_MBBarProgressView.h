@interface GaMBBarProgressView : NSObject
+ (void)requestMusicDetailsById;
+ (void)requestTimeCommentsWithType;
+ (void)removeExtensionAttributeWithName;
- (void)throttleBandwidthWithPacketSize;
- (void)hideAnimated;
- (void)setDebugOption;
- (void)setCountDownTime;
@end

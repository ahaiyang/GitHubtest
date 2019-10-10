@interface GaSDWebImageDownloader : NSObject
+ (void)setCenterOffset;
+ (void)setDataTaskDidReceiveDataBlock;
+ (void)addAnimation;
- (void)throttleBandwidthWithPacketSize;
- (void)autoSetPriority;
- (void)setImageWithURLRequest;
@end

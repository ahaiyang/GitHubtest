@interface ChNYTPhotoDismissalInteractionController : NSObject
+ (void)swipeViewDidScroll;
+ (void)yysetTabStops;
+ (void)invalidateHeightAtIndexPath;
- (void)imageViewerWillBeginDismissal;
- (void)scrollToPage;
- (void)configureCellWithBaseModel;
- (void)saveImageToCache;
- (void)cancelImageDownloadTaskForState;
- (void)pagingScrollView;
@end

@interface GaNYTPhotosViewController : NSObject
+ (void)willReleaseChild;
+ (void)emptyDataSetDidTapView;
+ (void)scrollByNumberOfItems;
- (void)setRefreshingWithStateOfTask;
- (void)TPKeyboardAvoidingkeyboardWillHide;
- (void)configureViewWithEditorText;
- (void)imageViewer;
- (void)configureCellWithContent;
- (void)configureCellWithHomeItem;
- (void)storeImage;
- (void)configureViewWithMusicId;
@end

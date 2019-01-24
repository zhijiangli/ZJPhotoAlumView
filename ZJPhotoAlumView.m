//
//  ZJPhotoAlumView.m
//  OC_Project
//
//  Created by 小黎 on 2018/12/18.
//  Copyright © 2018年 ZJ. All rights reserved.
//

#import "ZJPhotoAlumView.h"
@class ZJOriginalImageView;
// 边距
#define KZJPhotoAlumSubMargin 5
// 每一行排列的个数
#define KZJPhotoAlumColumns 3
// 动画时间
#define KZJPhotoAlumAnimateTime 0.3

@interface ZJPhotoAlumView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,copy) void(^viewSubViewClickBlock)(ZJPhotoAlumImageModel * model,NSInteger tag);
@property(nonatomic,weak) UICollectionView * collect;
@property(nonatomic,strong) NSMutableArray <ZJPhotoAlumImageModel*>* dataArray;
@property(nonatomic,strong) ZJOriginalImageView   * originalImageView;
@property(nonatomic,assign) BOOL  showAddImage;
@property(nonatomic,copy)   void(^addImageClickBlock)(void);
@end

@implementation ZJPhotoAlumView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setShowAddImage:false];

        [self setSubViews];

        
        [self handleOriginalImagesBlock];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect newframe = [[self collect] frame];
    newframe.size = frame.size;
    [[self collect] setFrame:newframe];
}
-(ZJOriginalImageView *)originalImageView{
    if(!_originalImageView){
        CGSize size = [[UIScreen mainScreen] bounds].size;
        CGRect subframe = CGRectMake(0, 0, size.width, size.height);
        _originalImageView = [[ZJOriginalImageView alloc] initWithFrame:subframe];
        [_originalImageView setBackgroundColor:[UIColor blackColor]];
    }
    return _originalImageView;
}
-(void)setSubViews{
    CGRect subframe = CGRectMake(0, 0, CGRectGetWidth([self frame]), CGRectGetHeight([self frame]));
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    [layout setMinimumInteritemSpacing:KZJPhotoAlumSubMargin*0.8];
    [layout setMinimumLineSpacing:KZJPhotoAlumSubMargin];
    UICollectionView * subview = [[UICollectionView alloc] initWithFrame:subframe collectionViewLayout:layout];
    [subview setDataSource:self];
    [subview setDelegate:self];
    [subview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [subview setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:subview];
    [self setCollect:subview];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self showAddImage] == true ? [[self dataArray] count]+1 : [[self dataArray] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if([cell viewWithTag:101] == nil){
        CGRect subframe   = CGRectMake(0, 0, CGRectGetWidth([cell frame]), CGRectGetHeight([cell frame]));
        UIImageView * subview = [[UIImageView alloc] initWithFrame:subframe];
        [subview setTag:101];
        [cell addSubview:subview];
    }
    [cell setBackgroundColor:[UIColor orangeColor]];
    
    UIImageView * subview = (UIImageView *)[cell viewWithTag:101];
    if([indexPath item]<[[self dataArray] count]){
        [self imageView:subview setImageWith:[[self dataArray] objectAtIndex:[indexPath item]]];
    }else{
        [subview setImage:[UIImage imageNamed:@"b"]];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath item]<[[self dataArray]count]){
        [self showOriginalImagesWithCurrentIndex:[indexPath item]];
    }else if([self addImageClickBlock]){
        self.addImageClickBlock();
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(KZJPhotoAlumSubMargin, KZJPhotoAlumSubMargin, KZJPhotoAlumSubMargin, KZJPhotoAlumSubMargin);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat subWidth = (CGRectGetWidth([self frame])-(KZJPhotoAlumColumns+1)*KZJPhotoAlumSubMargin)*1.0/KZJPhotoAlumColumns;
//    return CGSizeMake(subWidth, subWidth);
    
    return [self handleItemSizeWithImage:[[[self dataArray] objectAtIndex:[indexPath item]] image]];
}
-(CGSize)handleItemSizeWithImage:(UIImage*)image{
    CGSize size = [image size];
    CGFloat subWidth  = (CGRectGetWidth([self frame])-(KZJPhotoAlumColumns+1)*KZJPhotoAlumSubMargin)*1.0/KZJPhotoAlumColumns;
    CGFloat subHeight = subWidth/size.width*size.height;
 
    return CGSizeMake(subWidth, subHeight);
}
#pragma mark  ********************************************
-(void)imageView:(UIImageView*)imgView setImageWith:(ZJPhotoAlumImageModel*)model{
    UIImage * image = [model image];
    UIGraphicsBeginImageContext(CGSizeMake(KWidth, KWidth * image.size.height/image.size.width));
    [image drawInRect:CGRectMake(0, 0,KWidth , KWidth * image.size.height/image.size.width)];
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [imgView setImage:imageNew];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        UIImage * image = nil;
//        if([model image]){
//            image = [model image];
//        }
//        if(!image && [model imageName]){
//            image = [UIImage imageNamed:[model imageName]];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(image){
//                [imgView setImage:image];
//            }
//        });
//    });
    
//    if(!image && [model imagePath]){
//        image = [UIImage imageWithContentsOfFile:[model imagePath]];
//        [imgView setImage:image?image:[UIImage new]];
//    }
//    if(!image && [model imageData]){
//        [GCD openTheSubthread:^{
//            image = [UIImage imageWithData:[model imageData]];
//        } backToTheMainThread:^{
//            [imgView setImage:image?image:[UIImage new]];
//        }];
//
//    }
    
//    if(!image && [model imageUrlStr]){ // 网络图片
//
//    }
}
-(void)handleSelfHeightWithImageStrs{
    NSInteger count = [self showAddImage]==true?[[self dataArray]count]+1:[[self dataArray]count];
    CGFloat subWidth = (CGRectGetWidth([self frame])-(KZJPhotoAlumColumns+1)*KZJPhotoAlumSubMargin)*1.0/KZJPhotoAlumColumns;
    NSInteger row = count%KZJPhotoAlumColumns==0?count/KZJPhotoAlumColumns:(count/KZJPhotoAlumColumns+1);
    CGFloat height = (subWidth+KZJPhotoAlumSubMargin)*row+KZJPhotoAlumSubMargin;
    if(CGRectGetHeight([self frame])>height){
        CGRect newFrame = [self frame];
        newFrame.size.height = height;
        [self setFrame:newFrame];
    }
}
#pragma mark  获取点击图片的frame
- (CGRect)getConverFrameWithCurrentIndex:(NSInteger)index{
    NSIndexPath * idnexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell * cell = [[self collect] cellForItemAtIndexPath:idnexPath];
    CGRect newFrame = [self convertRect:[cell frame] fromView:[cell superview]];
    return  newFrame;
}
-(void)showOriginalImagesWithCurrentIndex:(NSInteger)currentIndex{
    CGRect oldFrame = [self getConverFrameWithCurrentIndex:currentIndex];
    [[self originalImageView] showImageWithImageDataSource:[self dataArray] defaultCurrentIndex:currentIndex];
    [[self originalImageView] setDefaultCurrentIndexSubViewFrame:oldFrame];
    [[UIApplication sharedApplication].keyWindow addSubview:[self originalImageView]];
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGRect newFrame = CGRectMake(0, 0, size.width, size.height);
    [UIView animateWithDuration:KZJPhotoAlumAnimateTime animations:^{
        [[self originalImageView] setAlpha:1];
        [[self originalImageView] setDefaultCurrentIndexSubViewFrame:newFrame];
    }];
}
-(void)handleOriginalImagesBlock{
    __weak typeof(self) weakSelf = self;
    [[self originalImageView] didSelectSubviewAtIndex:^(NSInteger index) {
        CGRect cellFrame = [weakSelf getConverFrameWithCurrentIndex:index];
        [UIView animateWithDuration:KZJPhotoAlumAnimateTime animations:^{
            [[weakSelf originalImageView] setAlpha:0];
            [[weakSelf originalImageView] setDefaultCurrentIndexSubViewFrame:cellFrame];
        } completion:^(BOOL finished) {
            [[weakSelf originalImageView] removeFromSuperview];
        }];
    }];
    [[self originalImageView] showOriginalDeleteBtnBackBlock:^(NSArray<ZJPhotoAlumImageModel *> *dataSource, NSInteger currentIndex) {
        [weakSelf setDataArray:[NSMutableArray arrayWithArray:dataSource]];
        [weakSelf handleSelfHeightWithImageStrs];
        [[weakSelf collect] reloadData];
    }];
}
#pragma mark ****************************************************
/** 展示图片 */
- (void)showImageWithImageDataSource:(NSArray<ZJPhotoAlumImageModel*>*)dataSource
{
    [self setDataArray:[NSMutableArray arrayWithArray:dataSource]];
    [self handleSelfHeightWithImageStrs];
    [[self collect] reloadData];
}
/** 是否在末尾展示添加按钮*/
- (void)showPhotoAlumAddImageBtn:(BOOL)show clickBlock:(void(^)(void))block
{
    [self setShowAddImage:show];
    [self setAddImageClickBlock:block];
    [[self collect] reloadData];
}
/** 大图展示时是否显示删除按钮
 *  @param block 回调删除后的集合和当前显示第一张*/
- (void)showOriginalDeleteBtnBackBlock:(void(^)(NSArray <ZJPhotoAlumImageModel*>*dataSource,NSInteger currentIndex))block
{
    [[self originalImageView] showOriginalDeleteBtnBackBlock:block];
}
@end

#pragma mark - >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@interface ZJOriginalImageView ()<UIScrollViewDelegate>
@property(nonatomic,weak) UILabel  * countMsgLabel;
@property(nonatomic,weak) UIButton * deleteBtn;
@property(nonatomic,strong) NSMutableArray <ZJPhotoAlumImageModel*>* dataArray;
@property(nonatomic,weak) UIScrollView * scrollview;
@property(nonatomic,assign) NSInteger    currentIndex;
@property(nonatomic,weak) UIImageView  * leftImgView;
@property(nonatomic,weak) UIImageView  * centerImgView;
@property(nonatomic,weak) UIImageView  * rightImgView;
@property(nonatomic,copy) void(^didSelectSubviewAtIndexBlock)(NSInteger index);
@property(nonatomic,copy) void(^deleteBackBlock)(NSArray * array, NSInteger index);
@end

@implementation ZJOriginalImageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}
-(void)setSubViews{
    CGRect subframe = CGRectMake(0, 0, CGRectGetWidth([self frame]), CGRectGetHeight([self frame]));
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:subframe];
    [scroll setBounces:true];
    [scroll setPagingEnabled:true];
    [scroll setShowsVerticalScrollIndicator:false];
    [scroll setShowsHorizontalScrollIndicator:false];
    [self addSubview:scroll];
    [self setScrollview:scroll];
    
    for(int i=0;i<3;i++){
        CGRect subframe = CGRectMake(CGRectGetWidth([scroll frame])*i, 0, CGRectGetWidth([scroll frame]), CGRectGetHeight([scroll frame]));
        UIImageView * subview01 = [[UIImageView alloc] initWithFrame:subframe];
        [subview01 setContentMode:UIViewContentModeScaleAspectFit];
        //[subview01 setBackgroundColor:[UIColor redColor]];
        [scroll addSubview:subview01];
        if(i==0){[self setLeftImgView:subview01];}
        if(i==1){[self setCenterImgView:subview01];}
        if(i==2){[self setRightImgView:subview01];}
    }
    subframe = CGRectMake(0, 0, CGRectGetWidth([self frame]), 44.0);
    UILabel * label = [[UILabel alloc] initWithFrame:subframe];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [self addSubview:label];
    [self setCountMsgLabel:label];
    
    subframe = CGRectMake(CGRectGetWidth([self frame])-64.0, 10, 44.0, 44.0);
    UIButton * button = [[UIButton alloc] initWithFrame:subframe];
    //[button setBackgroundColor:[UIColor orangeColor]];
    [button addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [button setHidden:true];
    [self addSubview:button];
    [self setDeleteBtn:button];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
}
-(void)deleteButtonClick{
    if([[self dataArray] count]==1){
        [[self dataArray] removeObjectAtIndex:0];
        if([self deleteBackBlock]){
            self.deleteBackBlock([self dataArray], 0);
        }
        [self tapClick];
    }else{
        [[self dataArray] removeObjectAtIndex:[self currentIndex]];
        if([self currentIndex]>=[[self dataArray] count]){
            [self setCurrentIndex:[[self dataArray] count]-1];
        }
        [self setDefaultCurrentIndex:[self currentIndex]];
        if([self deleteBackBlock]){
            self.deleteBackBlock([self dataArray], [self currentIndex]);
        }
    }
}
-(void)tapClick{
    if([self didSelectSubviewAtIndexBlock]){
        self.didSelectSubviewAtIndexBlock([self currentIndex]);
    }
}
-(void)refreshScrollImagesLayoutWithImageDataArray:(NSArray*)dataSource{
    if([dataSource count]==0){
        [[self scrollview] setDelegate:nil];
    }else if([dataSource count] ==1){
        [[self scrollview] setDelegate:nil];
        [self imageView:[self leftImgView] setImageWith:[dataSource firstObject]];
    }else{
        [[self scrollview] setDelegate:self];
        [[self scrollview] setContentSize:CGSizeMake(CGRectGetWidth([self frame])*3, 0)];
        [[self scrollview] setContentOffset:CGPointMake(CGRectGetWidth([self frame]), 0)];
    }
}
#pragma mark  *******************************************************
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self refrshScrollImageViewAndCurrentIndex];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self refrshScrollImageViewAndCurrentIndex];
}
-(void)refrshScrollImageViewAndCurrentIndex{
    // 计算索引
    CGFloat offetIndex = [[self scrollview] contentOffset].x/CGRectGetWidth([[self scrollview] frame]);
    if(offetIndex == 1){return;}
    if(offetIndex>1){// 右往左滑+1
        [self setCurrentIndex:[self currentIndex]+1];
        if([self currentIndex]>=[[self dataArray] count]){
            // 确保索引范围
            [self setCurrentIndex:0];
        }
    }else if(offetIndex<1){// 左往右滑-1
        [self setCurrentIndex:[self currentIndex]-1];
        if([self currentIndex] <= -1){
            // 确保索引范围
            [self setCurrentIndex:[[self dataArray] count]-1];
        }
    }
    // 更新UIImage
    [self handleLeftImageViewWithIndex:[self currentIndex]-1];
    [self handleCenterImageViewWithIndex:[self currentIndex]];
    [self handleRightImageViewWithIndex:[self currentIndex]+1];
    NSString * msgString = [NSString stringWithFormat:@"%ld / %ld",[self currentIndex]+1,[[self dataArray] count]];
    [[self countMsgLabel] setText:msgString];
    // 保证中心位置
    [[self scrollview] setContentOffset:CGPointMake(CGRectGetWidth([[self scrollview] frame]), 0)];
}
-(void)handleLeftImageViewWithIndex:(NSInteger)index{
    if(index<= -1){
        [self imageView:[self leftImgView] setImageWith:[[self dataArray] lastObject]];
    }else if(index<=[[self dataArray] count]-1){
        [self imageView:[self leftImgView] setImageWith:[[self dataArray] objectAtIndex:index]];
    }
}
-(void)handleCenterImageViewWithIndex:(NSInteger)index{
    if(index<[[self dataArray] count]){
        [self imageView:[self centerImgView] setImageWith:[[self dataArray] objectAtIndex:index]];
    }
}
-(void)handleRightImageViewWithIndex:(NSInteger)index{
    if(index>=[[self dataArray] count]){
        [self imageView:[self rightImgView] setImageWith:[[self dataArray] firstObject]];
    }else if(index>=0){
        [self imageView:[self rightImgView] setImageWith:[[self dataArray] objectAtIndex:index]];
    }
}
-(void)imageView:(UIImageView*)imgView setImageWith:(ZJPhotoAlumImageModel*)model{
    UIImage * image = nil;
    if([model image]){
        image = [model image];
        [imgView setImage:image?image:[UIImage new]];
    }
    if(!image && [model imageName]){
        image = [UIImage imageNamed:[model imageName]];
        [imgView setImage:image?image:[UIImage new]];
    }
    if(!image && [model imageData]){
        image = [UIImage imageWithData:[model imageData]];
        [imgView setImage:image?image:[UIImage new]];
    }
    if(!image && [model imagePath]){
        image = [UIImage imageWithContentsOfFile:[model imagePath]];
        [imgView setImage:image?image:[UIImage new]];
    }
    if(!image && [model imageUrlStr]){ // 网络图片
        
    }
}
#pragma mark  *******************************************************
- (void)showImageWithImageDataSource:(NSArray<ZJPhotoAlumImageModel*>*)dataSource defaultCurrentIndex:(NSInteger)currentIndex{
    [self setDataArray:[NSMutableArray arrayWithArray:dataSource]];
    [self refreshScrollImagesLayoutWithImageDataArray:dataSource];
    [self setDefaultCurrentIndex:currentIndex];
}
/** 显示删除按钮
 *  @param block 回调删除后的集合和当前显示第一张*/
- (void)showOriginalDeleteBtnBackBlock:(void(^)(NSArray <ZJPhotoAlumImageModel*>*dataSource,NSInteger currentIndex))block{
    [[self deleteBtn] setHidden:false];
    [self setDeleteBackBlock:block];
}
- (void)setDefaultCurrentIndex:(NSInteger)currentIndex{
    [self setCurrentIndex:currentIndex];
    // 更新UIImage
    [self handleLeftImageViewWithIndex:[self currentIndex]-1];
    [self handleCenterImageViewWithIndex:[self currentIndex]];
    [self handleRightImageViewWithIndex:[self currentIndex]+1];
    NSString * msgString = [NSString stringWithFormat:@"%ld / %ld",[self currentIndex]+1,[[self dataArray] count]];
    [[self countMsgLabel] setText:msgString];
}
- (void)setDefaultCurrentIndexSubViewFrame:(CGRect)frame{
    CGRect newFrame = frame;
    newFrame.origin.x += [self sw];
    [[self centerImgView] setFrame:newFrame];
}
- (void)didSelectSubviewAtIndex:(void(^)(NSInteger index))block{
    [self setDidSelectSubviewAtIndexBlock:block];
}

@end

#pragma mark - >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@implementation ZJPhotoAlumImageModel
-(instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if(self){
        [self setImage:image];
    }
    return self;
}
-(instancetype)initWithImageData:(NSData *)imageData{
    self = [super init];
    if(self){
        [self setImageData:imageData];
    }
    return self;
}
-(instancetype)initWithImageName:(NSString *)imageName{
    self = [super init];
    if(self){
        [self setImageName:imageName];
    }
    return self;
}
-(instancetype)initWithImagePath:(NSString *)imagePath{
    self = [super init];
    if(self){
        [self setImagePath:imagePath];
    }
    return self;
}
-(instancetype)initWithImageUrlStr:(NSString *)imageUrlStr{
    self = [super init];
    if(self){
        [self setImageUrlStr:imageUrlStr];
    }
    return self;
}
@end

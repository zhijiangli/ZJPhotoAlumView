//
//  ZJPhotoAlumView.h
//  OC_Project
//
//  Created by 小黎 on 2018/12/18.
//  Copyright © 2018年 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZJPhotoAlumImageModel : NSObject
// 图片
@property(nonatomic,strong) UIImage  * image;
// 图片data
@property(nonatomic,strong) NSData   * imageData;
// 本地图片名称
@property(nonatomic,strong) NSString * imageName;
// 本地图片路径
@property(nonatomic,strong) NSString * imagePath;
// 网络图片地址
@property(nonatomic,strong) NSString * imageUrlStr;

-(instancetype)initWithImage:(UIImage *)image;
-(instancetype)initWithImageData:(NSData *)imageData;
-(instancetype)initWithImageName:(NSString *)imageName;
-(instancetype)initWithImagePath:(NSString *)imagePath;
-(instancetype)initWithImageUrlStr:(NSString *)imageUrlStr;
@end
/** 九宫格排列图片*/
@interface ZJPhotoAlumView : UIView
/** 展示图片 */
- (void)showImageWithImageDataSource:(NSArray<ZJPhotoAlumImageModel*>*)dataSource;
/** 是否在末尾展示添加按钮*/
- (void)showPhotoAlumAddImageBtn:(BOOL)show clickBlock:(void(^)(void))block;
/** 大图展示时是否显示删除按钮
 *  @param block 回调删除后的集合和当前显示第一张*/
- (void)showOriginalDeleteBtnBackBlock:(void(^)(NSArray <ZJPhotoAlumImageModel*>*dataSource,NSInteger currentIndex))block;
@end
/** 全屏查看图片原图 */
@interface ZJOriginalImageView : UIView
/** 展示大图
 *  @param dataSource 图片信息
 *  @param currentIndex 默认显示第几张图*/
- (void)showImageWithImageDataSource:(NSArray<ZJPhotoAlumImageModel*>*)dataSource defaultCurrentIndex:(NSInteger)currentIndex;
/** 显示删除按钮
 *  @param block 回调删除后的集合和当前显示第一张*/
- (void)showOriginalDeleteBtnBackBlock:(void(^)(NSArray <ZJPhotoAlumImageModel*>*dataSource,NSInteger currentIndex))block;
/** 设置当前显示图片的frame */
- (void)setDefaultCurrentIndexSubViewFrame:(CGRect)frame;
/** 点击当前图片的回调 */
- (void)didSelectSubviewAtIndex:(void(^)(NSInteger index))block;
@end

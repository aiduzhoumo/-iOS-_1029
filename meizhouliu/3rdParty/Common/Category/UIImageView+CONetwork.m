//
//  UIImageView+CONetwork.m
//

#import "UIImageView+CONetwork.h"
#import "COCache.h"
#import "NSObject+COAssociation.h"
#import "UIImageView+COAddition.h"
#import <objc/runtime.h>

//static char URL_KEY;

#define KEY_CO_IMAGE_URL @"KEY_CO_IMAGE_URL"

@implementation UIImageView (CONetwork)

@dynamic imageURL;

- (UIImage *)handleImageWithCallback:(block_co_handle_image_data)callback imageData:(NSData *)imageData {
    if (callback) {
        return callback(imageData);
    } else {
        return [UIImage imageWithData:imageData];
    }
}

- (void)loadImageWithCallback:(block_co_image_load)callback completion:(block_image_loaded)completion image:(UIImage *)image cachedFlag:(BOOL)cachedFlag {
    if (callback) {
        callback(image, self, cachedFlag);
    } else {
        // 显示缓存的动画不采用动画效果，否则采用淡入淡出
        if (cachedFlag) {
            self.image = image;
        } else {
            [self co_animateFadeInImage:image completion:completion];
            return;
        }
    }
    if (completion) {
        completion();
    }
}

/** tableview中，由于重用的缘故，需要检查图片加载完成时是否还是原来的那张图片 */
- (BOOL)shouldLoadImageFromUrl:(NSURL *)url {
    return [self.imageURL.absoluteString isEqualToString:url.absoluteString];
}

#pragma mark - public methods

- (void)loadImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cachingKey:(NSString *)key contextInfo:(NSDictionary *)contextInfo {
    block_co_before_image_load beforeLoadImage = contextInfo[KEY_CO_BEFORE_IMAGE_LOAD_BLOCK];
    block_co_image_load loadImage = contextInfo[KEY_CO_IMAGE_LOAD_BLOCK];
    block_image_loaded loaded = contextInfo[KEY_CO_IMAGE_LOADED_BLOCK];
    block_co_set_image_placeholder setPlaceholder = contextInfo[KEY_CO_IMAGE_SET_PLACEHOLDER];
    block_co_handle_image_data handleImageData = contextInfo[KEY_CO_HANDLE_IMAGE_DATA];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __weak UIImageView *weakSelf = self;
    self.imageURL = url;
    
    CO_BLOCK_VOID internal_clearup = ^ {
        weakSelf.imageURL = nil;
    };
    CO_BLOCK_VOID internal_loaded = ^ {
        if (loaded) {
            loaded();
        }
        internal_clearup();
    };
    void(^ internal_image_block)(NSData *imageData, BOOL cachedFlag) = ^(NSData *imageData, BOOL cachedFlag) {
        UIImage *image = [self handleImageWithCallback:handleImageData imageData:imageData];
        if (! [self shouldLoadImageFromUrl:url]) {
            // internal_clearup();
            return;
        }
        co_dispatchAsyncToMainThread(^{
            if (beforeLoadImage) {
                beforeLoadImage(image, self, cachedFlag);
            }
            [self loadImageWithCallback:loadImage completion:internal_loaded image:image cachedFlag:cachedFlag];
        });
    };
    
    // check for cache
    NSData *cachedData = [COCache objectForKey:key];
    if (cachedData) {
        dispatch_async(queue, ^{
            internal_image_block(cachedData, YES);
        });
        return;
    }
    
    if (setPlaceholder) {
        setPlaceholder(placeholder, self);
    } else {
        self.image = placeholder;
    }
    
    // load image from network
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            [COCache setObject:data forKey:key];
            internal_image_block(data, NO);
        }
    });
    
}

- (void)loadImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cachingKey:(NSString *)key callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded {
    NSDictionary *contextInfo;
    if (callbackOnImageLoaded) {
        contextInfo = @{KEY_CO_IMAGE_LOADED_BLOCK : callbackOnImageLoaded};
    }
    [self loadImageFromURL:url placeholderImage:placeholder cachingKey:key contextInfo:contextInfo];
}

- (void)setImageURL:(NSURL *)newImageURL {
    [self setProperty:KEY_CO_IMAGE_URL value:[newImageURL copy]];
}

- (NSURL *)imageURL {
    return [self getProperty:KEY_CO_IMAGE_URL];
}

@end

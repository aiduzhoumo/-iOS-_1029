//
//  UIImageView+CONetwork.h
//

#import <UIKit/UIKit.h>

typedef void (^block_co_before_image_load)(UIImage *image, UIImageView *imageView, BOOL cached);
typedef void (^block_co_image_load)(UIImage *image, UIImageView *imageView, BOOL cached);
typedef void (^block_image_loaded)(void);
typedef void (^block_co_set_image_placeholder)(UIImage *placeholder, UIImageView *imageView);
typedef UIImage* (^block_co_handle_image_data)(NSData *imageData);

#define KEY_CO_BEFORE_IMAGE_LOAD_BLOCK @"KEY_CO_BEFORE_IMAGE_LOAD_BLOCK"
#define KEY_CO_IMAGE_LOAD_BLOCK @"KEY_CO_IMAGE_LOAD_BLOCK"
#define KEY_CO_IMAGE_LOADED_BLOCK @"KEY_CO_IMAGE_LOADED_BLOCK"
#define KEY_CO_IMAGE_SET_PLACEHOLDER @"KEY_CO_IMAGE_SET_PLACEHOLDER"
#define KEY_CO_HANDLE_IMAGE_DATA @"KEY_CO_HANDLE_IMAGE_DATA"

@interface UIImageView (CONetwork)

- (void)loadImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cachingKey:(NSString *)key callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded;
- (void)loadImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cachingKey:(NSString *)key contextInfo:(NSDictionary *)contextInfo;

@property (nonatomic, copy) NSURL *imageURL;

@end

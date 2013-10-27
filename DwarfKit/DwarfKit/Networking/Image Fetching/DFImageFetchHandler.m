/*
 The MIT License (MIT)
 
 Copyright (c) 2013 Alexander Grebenyuk (github.com/kean).
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "DFImageFetchHandler.h"
#import "DFImageFetchTask.h"


@implementation DFImageFetchHandler

+ (instancetype)handlerWithSuccess:(DFImageFetchSuccess)success
                       notModified:(DFImageFetchNotModified)notModified
                           failure:(DFImageFetchFailure)failure {
    DFImageFetchHandler *handler = [DFImageFetchHandler new];
    handler.success = success;
    handler.failure = failure;
    handler.notModified = notModified;
    return handler;
}

+ (instancetype)handlerWithSuccess:(DFImageFetchSuccess)success
                           failure:(DFImageFetchFailure)failure {
    return [self handlerWithSuccess:success notModified:nil failure:failure];
}

- (void)handleTaskCompletion:(DFImageFetchTask *)task {
    if (task.image) {
        if (_success) {
            _success(task.image);
        }
    } else if (task.notModified) {
        if (_notModified) {
            _notModified();
        }
    } else {
        if (_failure) {
            _failure(task.error);
        }
    }
}

@end

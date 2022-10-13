// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

@protocol FBSDKGateKeeperManaging;
@protocol FBSDKAppEventsConfigurationProviding;
@protocol FBSDKServerConfigurationProviding;
@protocol FBSDKGraphRequestProviding;
@protocol FBSDKFeatureChecking;
@protocol FBSDKDataPersisting;
@protocol FBSDKLogging;
@protocol FBSDKSettings;
@protocol FBSDKPaymentObserving;
@protocol FBSDKTimeSpentRecording;
@protocol FBSDKAppEventsStatePersisting;
@protocol FBSDKAppEventsParameterProcessing;
@protocol FBSDKAppEventsParameterProcessing;
@protocol FBSDKAtePublisherCreating;
@protocol FBSDKSwizzling;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AppEventsConfiguring)
@protocol FBSDKAppEventsConfiguring

- (void)   configureWithGateKeeperManager:(Class<FBSDKGateKeeperManaging>)gateKeeperManager
           appEventsConfigurationProvider:(Class<FBSDKAppEventsConfigurationProviding>)appEventsConfigurationProvider
              serverConfigurationProvider:(Class<FBSDKServerConfigurationProviding>)serverConfigurationProvider
                     graphRequestProvider:(id<FBSDKGraphRequestProviding>)provider
                           featureChecker:(id<FBSDKFeatureChecking>)featureChecker
                                    store:(id<FBSDKDataPersisting>)store
                                   logger:(Class<FBSDKLogging>)logger
                                 settings:(id<FBSDKSettings>)settings
                          paymentObserver:(id<FBSDKPaymentObserving>)paymentObserver
                        timeSpentRecorder:(id<FBSDKTimeSpentRecording>)timeSpentRecorder
                      appEventsStateStore:(id<FBSDKAppEventsStatePersisting>)appEventsStateStore
      eventDeactivationParameterProcessor:(id<FBSDKAppEventsParameterProcessing>)eventDeactivationParameterProcessor
  restrictiveDataFilterParameterProcessor:(id<FBSDKAppEventsParameterProcessing>)restrictiveDataFilterParameterProcessor
                      atePublisherFactory:(id<FBSDKAtePublisherCreating>)atePublisherFactory
                                 swizzler:(Class<FBSDKSwizzling>)swizzler;

@end

NS_ASSUME_NONNULL_END

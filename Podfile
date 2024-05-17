platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'

target :Intelligent do
    pod 'SmaatoSDK'

    pod 'Alamofire', '~> 4.8.1'
    pod 'SDWebImage', '~> 4.4.5'
    
    pod 'Firebase/Core', '~> 5.16.0'
    
    pod 'FBSDKCoreKit', '~> 4.40.0'
    pod 'FBSDKLoginKit', '~> 4.40.0'
    pod 'GoogleSignIn', '~> 4.4.0'
    
    pod 'SideMenu', '~> 5.0.3'
    pod 'JGProgressHUD', '~> 2.0.3'
    
    pod 'SwiftyBeaver'
end

target :IntelligentKit do
    pod 'Alamofire', '~> 4.8.1'
    pod 'SwiftyJSON', '~> 4.2.0'
    pod 'RealmSwift', '~> 4.4.1'
    pod 'TwilioVoice', '~> 2.0'
    pod 'SwiftyBeaver'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ARCHS'] = '$ARCHS_STANDARD_64_BIT'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
        if target.name.include?('Realm')
           target.build_configurations.each do |config|
                 config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
           end
        end
    end
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end

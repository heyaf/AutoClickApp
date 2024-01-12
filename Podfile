# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'
 install! 'cocoapods', :disable_input_output_paths => true

target 'AutoClickApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AutoClickApp
  pod 'AttributedString'
  pod 'Masonry'
  pod 'TZImagePickerController'
  pod 'IQKeyboardManager'
  pod 'lottie-ios' ,'~> 2.5.3'
  pod 'SwiftTheme'
  #pod 'TesseractOCRiOS', '4.0.0'
  target 'AutoClickAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AutoClickAppUITests' do
    # Pods for testing
  end

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end

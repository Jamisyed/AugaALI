# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AguaAli' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AguaAli
  pod 'SwiftLint'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RealmSwift'
  pod 'RxRealm'
  pod 'RxFlow'
  pod 'SwiftEntryKit'
  pod "RxRealmDataSources"
  pod 'SDWebImage'
  pod 'Alamofire'
  pod 'IQKeyboardManagerSwift'
  pod 'NVActivityIndicatorView'
  pod 'SwiftyJSON', '~> 5.0'

  target 'AguaAliTests' do
    inherit! :search_paths
    # Pods for testing
  end

end


post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64 i386"
        
        
      end
    end
  end
end

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'IntegrationIOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'CleverTap-iOS-SDK', '7.1.1'
  post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'CLEVERTAP_HOST_WATCHOS=1']
      end
    end
  end
  # Pods for IntegrationIOS

  target 'IntegrationIOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'IntegrationIOSUITests' do
    # Pods for testing
  end

end

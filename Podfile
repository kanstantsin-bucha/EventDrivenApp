source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

# This could eliminate issue with "same cocapods have different submodules in different targets" issue
# but for now let's do it in easy fix way

 install! 'cocoapods',
 :deterministic_uuids => false


workspace 'EventDrivenApp.xcworkspace'

development_pods = true
# list of 3.3 swif targets .
swift3Targets = []
swift3InheritanceTargets = ['NohanaImagePicker']

post_install do |installer|
    
    installer.pods_project.targets.each do |target|
        
        if swift3InheritanceTargets.include? (target.name)
            
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_SWIFT3_OBJC_INFERENCE'] = 'On'
            end
        end
        
        if swift3Targets.include? (target.name)
            
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.3'
            end
            else
            
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.1'
            end
        end
        
    end
    
    # installer.pods_project.targets.each do |target|
    #   target.build_configurations.each do |configuration|
    #        target.build_settings(configuration.name)['ACTIVE_ARCH_ONLY'] = 'NO'
    #    end
    # end
    
    
    puts("Update debug pod settings to speed up build time")
    Dir.glob(File.join("Pods", "**", "Pods*{debug,Private}.xcconfig")).each do |file|
        File.open(file, 'a') { |f| f.puts "\nDEBUG_INFORMATION_FORMAT = dwarf" }
    end
    
    next if development_pods
    
    puts("Update copy pod resources only once to speed up build time")
    
    Dir.glob(installer.sandbox.target_support_files_root + "Pods-*/*.sh").each do |script|
        flag_name = File.basename(script, ".sh") + "-Installation-Flag"
        folder = "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
        file = File.join(folder, flag_name)
        content = File.read(script)
        content.gsub!(/set -e/, "set -e\nKG_FILE=\"#{file}\"\nif [ -f \"$KG_FILE\" ]; then exit 0; fi\nmkdir -p \"#{folder}\"\ntouch \"$KG_FILE\"")
        File.write(script, content)
    end
    
    puts("Please clean project after pod install/update = CMD+SHIFT+K in xCode")
end

# ================= Truebucha ================
# EventDrivenApp Mac Goes Below

abstract_target :'EventDrivenAppMacPods' do
    platform :osx, '10.11'
    use_frameworks!
    
    project 'EventDrivenApp.xcodeproj'
    
    pod 'CDBKit', '~> 1.4.1'
    pod 'BuchaSwift', '~> 1.0'
    pod 'FlatButton', '~> 1.2'
  
    pod 'Google-Analytics-for-OS-X', '~> 1.1'
    
    pod 'RxSwift', '~> 4.0'
    pod 'ReactiveReSwift', '~> 4.0'
    pod 'RealmSwift', '~> 3.0'
    
    pod 'QMGeocoder'
    
    pod 'LocationInfo', '~> 1.1'
    
    target :'EventDrivenAppMac' do
        project 'EventDrivenApp.xcodeproj'
    end
end

# ================= Truebucha ================
# EventDrivenApp iOS Goes Below

platform :ios, '10.0'
use_frameworks!

abstract_target 'EventDrivenAppIosPods' do

    pod 'GoogleAnalytics'

    pod 'CDBKit', '~> 1.4.1'
    pod 'BuchaSwift', '~> 1.0'

    pod 'RxSwift', '~> 4.0'
    pod 'ReactiveReSwift', '~> 4.0'

    pod 'RealmSwift', '~> 3.0'

    pod 'Fabric'
    pod 'Crashlytics'

    pod 'Parse'
    pod 'TBParse'
    
    pod 'QMGeocoder'

    target :'EventDrivenAppIos' do
        project 'EventDrivenApp.xcodeproj'
    end
end

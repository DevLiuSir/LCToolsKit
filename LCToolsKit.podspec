#
#  Be sure to run `pod spec lint LCToolsKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "LCToolsKit"
  spec.version      = "1.0.6"
  spec.summary      = "LCToolsKit is a commonly used tool framework in macOS development"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
  LCToolsKit is a commonly used tool framework in macOS development！
                   DESC

  spec.homepage     = "https://github.com/DevLiuSir/LCToolsKit"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  #spec.license      = "MIT (example)"
  spec.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "Marvin" => "93428739@qq.com" }
  # Or just: spec.author    = "Marvin"
  # spec.authors            = { "Marvin" => "93428739@qq.com" }
  # spec.social_media_url   = "https://twitter.com/Marvin"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  spec.swift_versions = ['5.0']
  spec.platform = :osx
  spec.osx.deployment_target = "10.15"


  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"
  # spec.visionos.deployment_target = "1.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/DevLiuSir/LCToolsKit.git", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #



  # spec.resource = 'Sources/LCToolsKit/Resources/*'

  spec.subspec 'LCProgressHUD' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCProgressHUD/*.swift'
  end

  spec.subspec 'LCAppSandboxFileKit' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppSandboxFileKit/LCAppSandboxFileAccess/*.swift'
  ss.resource     = 'Sources/LCToolsKit/LCAppSandboxFileKit/Resources/*'

  #  ss.resource_bundle = {
  #   'LCAppSandboxFileKit' => ['Sources/LCToolsKit/LCAppSandboxFileKit/Resources/*']
  # }


  end


  # spec.subspec 'LCAppleScriptManager' do |ss|
  # ss.source_files = 'Sources/LCToolsKit/LCAppleScriptManager/*.swift'
  # ss.resource     = 'Sources/LCToolsKit/LCAppleScriptManager/Resources/*'
  # #  ss.resource_bundle = {
  # #   'LCAppleScriptManager' => ['Sources/LCToolsKit/LCAppleScriptManager/Resources/*']
  # # }
  # end
  
  spec.subspec 'LCVolumeManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCVolumeManager/*.swift'
  end

  spec.subspec 'LCDistributedNotificationManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCDistributedNotificationManager/*.swift'
  end

  spec.subspec 'LCCFNotificationManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCCFNotificationManager/*.swift'
  end

  spec.subspec 'LCTemperatureUtils' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCTemperatureUtils/*.swift'
  end
  
  spec.subspec 'LCAppReviewManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppReviewManager/*.swift'
  end

  spec.subspec 'LCFileAdministrator' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCFileAdministrator/*.swift'
  end

  spec.subspec 'LCSpeechManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCSpeechManager/*.swift'
  end

  spec.subspec 'Extension' do |ss|
  ss.source_files = 'Sources/LCToolsKit/Extension/*.swift'
  end

  spec.subspec 'Other' do |ss|
  ss.source_files = 'Sources/LCToolsKit/Other/*.swift'
  end




  #spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  # spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end

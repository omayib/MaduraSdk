Pod::Spec.new do |s|
    s.name         = "MaduraSdk"
    s.version      = "0.0.2"
    s.summary      = "make it simple dev call enggine."

    s.homepage     = "http://qiscus.com"
    # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

    s.license          = { :type => 'MIT', :file => 'LICENSE' }

    s.author       = { "akbarul@qiscus.co" => "akbarul@qiscus.co" }

    s.platform     = :ios, "9.0"

    s.source       = { :git => 'https://github.com/omayib/MaduraSdk.git', :tag => s.version.to_s}

    s.source_files  = "MaduraSdk/*.{h,m,swift,xib}"

    s.resources = "*.xcassets"
    s.resource_bundles = {
        'MaduraSdk' => ['MaduraSdk/*.{xib,xcassets,imageset,png}']
    }
    s.dependency 'MaduraSignalKit'
    s.dependency 'MaduraCallKit'
end

Pod::Spec.new do |s|
  s.name             = 'UIComposable'
  s.version          = '0.1.1'
  s.swift_versions    = ['5.0', '5.1', '5.2', '5.3']
  s.summary          = 'A protocol of UI rendering for plugins - UIComposable.'

  s.description      = <<-DESC
  Use this protocol to render user interface like plugins
                       DESC

  s.homepage         = 'https://github.com/congncif/UIComposable'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NGUYEN CHI CONG' => 'congnc.if@gmail.com' }
  s.source           = { :git => 'https://github.com/congncif/UIComposable.git', :tag => s.version.to_s }
   s.social_media_url = 'https://twitter.com/congncif'

  s.ios.deployment_target = '9.0'

  s.source_files = 'UIComposable/Classes/**/*'
end

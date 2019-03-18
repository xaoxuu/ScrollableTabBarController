Pod::Spec.new do |s|
  s.name = 'ScrollableTabBarController'
  s.version = "1.0.1"
  s.license = 'MIT'
  s.summary = '一个可以横向滑动的TabBarController。'
  s.homepage = "http://xaoxuu.com"
  s.authors = { 'xaoxuu' => 'xaoxuu@gmail.com' }
  s.source = { :git => "https://github.com/xaoxuu/ScrollableTabBarController.git", :tag => "#{s.version}", :submodules => false}
  s.ios.deployment_target = '8.0'

  s.source_files = 'ScrollableTabBarController/*.swift'

  s.requires_arc = true

  s.dependency 'SnapKit', '4.2.0'
  s.dependency 'AXKit', '0.3.10'

end

Pod::Spec.new do |s|
   s.name = 'JSQNotificationObserverKit'
   s.version = '2.0.0'
   s.license = 'MIT'

   s.summary = 'Generic notifications and observers for iOS'
   s.homepage = 'https://github.com/jessesquires/JSQNotificationObserverKit'
   s.documentation_url = 'http://jessesquires.com/JSQNotificationObserverKit'

   s.social_media_url = 'https://twitter.com/jesse_squires'
   s.authors = { 'Jesse Squires' => 'jesse.squires.developer@gmail.com' }

   s.source = { :git => 'https://github.com/jessesquires/JSQNotificationObserverKit.git', :tag => s.version }
   s.source_files = 'JSQNotificationObserverKit/JSQNotificationObserverKit/*.swift'

   s.platform = :ios, '8.0'
   s.frameworks = 'Foundation'
   s.requires_arc = true
end

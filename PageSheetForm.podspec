Pod::Spec.new do |s|
  s.name = 'PageSheetForm'
  s.version = '1.1'
  s.license = 'MIT'
  s.summary = 'PageSheetForm is a PageSheet style form.'
  s.homepage = 'https://github.com/tichise/PageSheetForm'
  s.social_media_url = 'http://twitter.com/tichise'
  s.author = "Takuya Ichise"
  s.source = { :git => 'https://github.com/tichise/PageSheetForm.git', :tag => s.version }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/*.swift'
  s.requires_arc = true
  
  s.resource_bundles = {
    'Storyboards' => [
        'Storyboards/*.storyboard'
    ]
  }
end
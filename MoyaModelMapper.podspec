Pod::Spec.new do |s|
  s.name         = "MoyaModelMapper"
  s.version      = "1.0.2"
  s.summary      = "ModelMapper bindings for Moya. Includes RxSwift and ReactiveSwift bindings as well."
  s.description  = <<-DESC
    [ModelMapper](https://github.com/lyft/mapper) bindings for
    [Moya](https://github.com/Moya/Moya) for easier JSON serialization.
    Includes [RxSwift](https://github.com/ReactiveX/RxSwift) and [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) bindings as well.
    Instructions on how to use it are in
    [the README](https://github.com/gperdomor/MoyaModelMapper).
  DESC
  s.homepage     = "https://github.com/gperdomor/MoyaModelMapper"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Gustavo Perdomo" => "gperdomor@gmail.com" }
  s.social_media_url   = ""
  
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.12"
  s.watchos.deployment_target = "3.1"
  s.tvos.deployment_target = "9.0"
  
  s.source       = { :git => "https://github.com/gperdomor/MoyaModelMapper.git", :tag => s.version.to_s }

  s.requires_arc = true
  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "Sources/MoyaModelMapper/*.swift"
    ss.dependency "Moya", "~> 8.0"
    ss.dependency "ModelMapper", "~> 6.0"
    ss.framework = "Foundation"
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "Sources/RxMoyaModelMapper/*.swift"
    ss.dependency "MoyaModelMapper/Core"
    ss.dependency "Moya/RxSwift"
  end

  s.subspec "ReactiveSwift" do |ss|
    ss.source_files = "Sources/ReactiveMoyaModelMapper/*.swift"
    ss.dependency "MoyaModelMapper/Core"
    ss.dependency "Moya/ReactiveCocoa"
  end
end

Pod::Spec.new do |spec|
    spec.name                  = 'ImmutableXCore'
    spec.version               = '0.3.0'
    spec.summary               = 'The Immutable X Core SDK Swift for applications written on the Immutable X platform.'

    spec.description           = <<-DESC
    The Immutable Core SDK Swift provides convenient access to the Immutable API's for applications written on the Immutable X platform.
                     DESC

    spec.homepage              = 'https://github.com/immutable/imx-core-sdk-swift'
    spec.documentation_url     = 'https://docs.x.immutable.com/sdk-docs/core-sdk-swift/overview'
    spec.license               = { :type => 'Apache License 2.0', :file => 'LICENSE' }
    spec.author                = { 'Immutable' => 'opensource@immutable.com'}

    spec.source                = { :git => 'https://github.com/immutable/imx-core-sdk-swift.git', :tag => "v#{spec.version}" }
    spec.source_files          = 'Sources/**/*.swift'

    spec.swift_version         = '5.7'

    spec.ios.deployment_target = '13'
    spec.osx.deployment_target = '10.15'

    spec.dependency 'AnyCodable-FlightSchool', '~> 0.6'
    spec.dependency 'BigInt', '~> 5.2.0'
    spec.dependency 'secp256k1Swift', '~> 0.7.4'
  end

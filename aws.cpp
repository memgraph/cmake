#include <iostream>
#include <memory>

#include <aws/core/Aws.h>
#include <aws/core/auth/AWSCredentialsProvider.h>
#include <aws/s3/S3Client.h>

bool ListBuckets(const Aws::Client::ClientConfiguration &clientConfig) {
  auto client = Aws::S3::S3Client(
      Aws::Auth::AWSCredentials("minioadmin", "minioadmin"), clientConfig,
      Aws::Client::AWSAuthV4Signer::PayloadSigningPolicy::Never, false);

  auto outcome = client.ListBuckets();

  bool result = true;
  if (!outcome.IsSuccess()) {
    std::cerr << "Failed with error: " << outcome.GetError() << std::endl;
    result = false;
  } else {
    std::cout << "Found " << outcome.GetResult().GetBuckets().size()
              << " buckets\n";
    for (auto &&b : outcome.GetResult().GetBuckets()) {
      std::cout << b.GetName() << std::endl;
    }
  }
  return result;
}

int main() {
  Aws::SDKOptions options;
  options.loggingOptions.logLevel = Aws::Utils::Logging::LogLevel::Debug;
  InitAPI(options);

  {
    Aws::Client::ClientConfiguration config;
    config.endpointOverride = "localhost:9000";
    config.scheme = Aws::Http::Scheme::HTTP;
    config.verifySSL = false;
    ListBuckets(config);
  }

  ShutdownAPI(options);
  return 0;
}

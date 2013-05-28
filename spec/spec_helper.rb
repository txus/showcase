require 'repository'
if Repository.repositories.empty?
  require 'memory_repository'
  Repository.register(:user, MemoryRepository::UserRepository.new)
  Repository.register(:status, MemoryRepository::StatusRepository.new)
  Repository.register(:following, MemoryRepository::FollowingRepository.new)
end

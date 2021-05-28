CommitRecord = Struct.new(:timestamp, :repo_uri, :commit_hash)

class RecentCommits
  def initialize(timespan_sec)
    @queue = []
    @timespan_sec = timespan_sec
  end

  def add(repo_uri, commit_hash)
    cur_time = Time.now
    @queue << CommitRecord.new(cur_time, repo_uri, commit_hash)
    clean(cur_time)
  end

  def has(repo_uri, commit_hash)
    clean(Time.now)
    @queue.each { |cr|
      if cr.repo_uri == repo_uri and cr.commit_hash == commit_hash
        return TRUE
      end
    }
    return FALSE
  end

  def clean(cur_time)
    while (not @queue.empty?) and (cur_time - @queue[0].timestamp > @timespan_sec)
      @queue.shift
    end
  end
end


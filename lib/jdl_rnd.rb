# frozen_string_literal: true

require_relative "jdl_rnd/version"

class Error < StandardError; end

class RND
  attr_reader :seed
  attr_accessor :range

  def initialize(rng = 6, sd: 0.0)
    @range = rng
    if sd == 0.0
      makeSeedFromTime
    end
  end

  def next_seed
    s = (3.1415926**@seed) - Math.log10(@seed)
    s = -s if s < 0
    s *= 1_000_000
    @seed = s - s.to_i
  end

  def roll(r = -1)
    next_seed
    q = if r.positive?
          @seed * r
        else
          @seed * @range
        end
    q.to_i
  end

  # def =
  #   next_seed
  #   (@seed * @range).to_i
  # end

  def makeSeedFromTime
    t = Time.now.to_f
    cnt = 2

    while t > 100
      t /= 100
      cnt += 1
    end

    s = 0.0
    while cnt != 0
      s += t.to_i
      s /= 100
      t = t - t.to_i
      t *= 100
      cnt -= 1
    end
    @seed = s
  end

  def token(iter = 32)
    pool = "abcdefghijklmnopqrstuvwxyz~0123456789-ABCDEFGHIGKLMNOPQRSTUVWXYZ"
    token = ''
    iter.times do
      x = roll(pool.length)
      token += pool[x]
    end
    token
  end
end

